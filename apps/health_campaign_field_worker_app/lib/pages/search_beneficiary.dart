import 'package:auto_route/auto_route.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_scanner/blocs/scanner.dart';
import 'package:digit_scanner/pages/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:health_campaign_field_worker_app/utils/global_search_parameter_smc.dart';
import 'package:registration_delivery/blocs/search_households/individual_global_search.dart';

import 'package:registration_delivery/registration_delivery.dart';

import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/models/entities/status.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart'
    as registration_delivery_router;
import 'package:registration_delivery/utils/global_search_parameters.dart';
import 'package:registration_delivery/utils/utils.dart';
import 'package:registration_delivery/widgets/back_navigation_help_header.dart';
import 'package:registration_delivery/widgets/beneficiary/view_beneficiary_card.dart';
import 'package:registration_delivery/widgets/localized.dart';
import 'package:registration_delivery/widgets/status_filter/status_filter.dart';

// import '../../../blocs/blocs-smc/searchBeneficiary/individual_global_search_smc.dart';
// import '../../../blocs/blocs-smc/searchBeneficiary/search_households_smc.dart';
import '../../../router/app_router.dart';
import '../../../utils/extensions/extensions.dart';
// import '../../../utils/utils_smc/global_search_parameters_smc.dart';
import '../../../utils/i18_key_constants.dart' as i18_local;

// import '../../../widgets/widgets_smc/beneficiary/custom_view_beneficiary_card_smc.dart';
// import '../../../widgets/widgets_smc/status_filter_smc.dart';
import '../blocs/search_beneficiary/individual_global_search_smc.dart';
import '../blocs/search_beneficiary/search_households_smc.dart';
import '../widgets/progress_bar/status_filter_smc.dart';
import 'beneficiary/widgets/custom_beneficiary_card.dart';

class SearchBeneficiaryPage extends LocalizedStatefulWidget {
  const SearchBeneficiaryPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<SearchBeneficiaryPage> createState() => _SearchBeneficiaryPageState();
}

class _SearchBeneficiaryPageState
    extends LocalizedState<SearchBeneficiaryPage> {
  final TextEditingController searchController = TextEditingController();
  bool isProximityEnabled = false;
  bool isSearchByBeneficaryIdEnabled = false;
  int offset = 0;
  int limit = 10;
  RegExp pattern = RegExp(r'^[0-9A-Z-]+$');

  double lat = 0.0;
  double long = 0.0;
  List<String> selectedFilters = [];

  SearchHouseholdsState searchHouseholdsState = const SearchHouseholdsState(
    loading: false,
    householdMembers: [],
  );

  SearchHouseholdsSMCState searchHouseholdsSMCState =
      const SearchHouseholdsSMCState(loading: false, householdMembers: []);

  late final SearchBlocWrapper blocWrapper; // Declare BlocWrapper

  @override
  void initState() {
    // Initialize the BlocWrapper with instances of SearchHouseholdsBloc, SearchMemberBloc, and ProximitySearchBloc
    blocWrapper = context.read<SearchBlocWrapper>();
    context.read<LocationBloc>().add(const LoadLocationEvent());

    isProximityEnabled = true;
    var ifSearchTriggered = false;
    if (!ifSearchTriggered) {
      // Listen to LocationBloc's state to ensure location is loaded before triggering search
      context.read<LocationBloc>().stream.listen((locationState) {
        if (!locationState.loading &&
            isProximityEnabled == true &&
            locationState.latitude != null &&
            locationState.longitude != null) {
          setState(() {
            lat = locationState.latitude!;
            long = locationState.longitude!;
          });
          if (!ifSearchTriggered) {
            ifSearchTriggered = true;
            // Trigger search after location is loaded
            blocWrapper.clearEvent();
            triggerGlobalSearchEvent();
          }
        }
      });
    }

    blocWrapper.stateChanges.listen((state) {
      if (mounted) {
        setState(() {
          searchHouseholdsState = state;
        });
      }
    });

    context
        .read<IndividualGlobalSearchSMCBloc>()
        .add(SearchHouseholdsSMCEvent.clear());

    super.initState();
  }

  @override
  void dispose() {
    isProximityEnabled = false;
    blocWrapper.clearEvent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) => Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              final metrics = scrollNotification.metrics;
              if (metrics.atEdge && metrics.pixels != 0) {
                triggerGlobalSearchEvent(isPagination: true);
              }
            }
            return true;
          },
          child: ScrollableContent(
            header: const Column(children: [
              BackNavigationHelpHeaderWidget(
                showHelp: false,
                showcaseButton: null,
              ),
            ]),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(kPadding),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            localizations.translate(
                              RegistrationDeliverySingleton().beneficiaryType !=
                                      BeneficiaryType.individual
                                  ? i18.searchBeneficiary.statisticsLabelText
                                  : i18.searchBeneficiary
                                      .searchIndividualLabelText,
                            ),
                            style: theme.textTheme.displayMedium,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, locationState) {
                          return Column(
                            children: [
                              locationState.latitude != null
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Switch(
                                              value: isProximityEnabled,
                                              onChanged: (value) {
                                                searchController.clear();
                                                setState(() {
                                                  isProximityEnabled = value;
                                                  isSearchByBeneficaryIdEnabled =
                                                      false;
                                                  lat = locationState.latitude!;
                                                  long =
                                                      locationState.longitude!;
                                                });

                                                if (locationState
                                                        .hasPermissions &&
                                                    value &&
                                                    locationState.latitude !=
                                                        null &&
                                                    locationState.longitude !=
                                                        null &&
                                                    RegistrationDeliverySingleton()
                                                            .maxRadius !=
                                                        null &&
                                                    isProximityEnabled) {
                                                  triggerGlobalSearchEvent();
                                                } else {
                                                  blocWrapper.clearEvent();
                                                  triggerGlobalSearchEvent();
                                                }
                                              },
                                            ),
                                            Text(
                                              localizations.translate(
                                                i18.searchBeneficiary
                                                    .proximityLabel,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Switch(
                                              value:
                                                  isSearchByBeneficaryIdEnabled,
                                              onChanged: (value) {
                                                searchController.clear();
                                                context
                                                    .read<
                                                        IndividualGlobalSearchSMCBloc>()
                                                    .add(
                                                        const SearchHouseholdsSMCEvent
                                                            .clear());
                                                setState(() {
                                                  isSearchByBeneficaryIdEnabled =
                                                      value;
                                                  isProximityEnabled = false;
                                                  searchController.clear();
                                                  blocWrapper.clearEvent();
                                                });
                                              },
                                            ),
                                            Text(
                                              localizations.translate(
                                                  'SEARCH_BY_BENEFICIARY_ID'),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  : const Offstage(),
                              DigitSearchBar(
                                controller: searchController,
                                hintText: localizations.translate(
                                  i18.searchBeneficiary
                                      .beneficiarySearchHintText,
                                ),
                                textCapitalization: TextCapitalization.words,
                                onChanged: (value) {
                                  context
                                      .read<IndividualGlobalSearchSMCBloc>()
                                      .add(const SearchHouseholdsSMCEvent
                                          .clear());

                                  blocWrapper.clearEvent();
                                  if (isSearchByBeneficaryIdEnabled &&
                                      isBeneficiaryIdValid(value.trim())) {
                                    SearchByBeneficiaryId(
                                        beneficiaryId: value.trim());
                                  } else if (!isSearchByBeneficaryIdEnabled &&
                                      (value.isEmpty ||
                                          value.trim().length > 2)) {
                                    triggerGlobalSearchEvent();
                                  }
                                },
                              ),
                              if (!isSearchByBeneficaryIdEnabled)
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: kPadding),
                                    child: DigitIconButton(
                                      // textDirection: TextDirection.rtl,
                                      iconText: getFilterIconNLabel()['label'],
                                      icon: getFilterIconNLabel()['icon'],
                                      onPressed: () => showFilterDialog(),
                                    ),
                                  ),
                                ),
                              selectedFilters.isNotEmpty
                                  ? Align(
                                      alignment: Alignment.topLeft,
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: selectedFilters.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                  padding: const EdgeInsets.all(
                                                      kPadding / 2),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            kPadding / 2),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              const DigitColors()
                                                                  .cloudGray),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              kPadding / 2),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            localizations.translate(
                                                                getStatus(
                                                                    selectedFilters[
                                                                        index])),
                                                            style: TextStyle(
                                                                color: const DigitColors()
                                                                    .davyGray)),
                                                        Text(
                                                            ' (${searchHouseholdsState.totalResults})',
                                                            style: TextStyle(
                                                                color: const DigitColors()
                                                                    .davyGray)),
                                                        const SizedBox(
                                                            width: kPadding),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedFilters.remove(
                                                                  selectedFilters[
                                                                      index]);
                                                            });
                                                            blocWrapper
                                                                .clearEvent();
                                                            triggerGlobalSearchEvent();
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  const DigitColors()
                                                                      .davyGray,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          kPadding /
                                                                              2),
                                                            ),
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  const DigitColors()
                                                                      .white,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                            }),
                                      ),
                                    )
                                  : const Offstage(),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: kPadding * 2),
                      if (!isSearchByBeneficaryIdEnabled &&
                          searchHouseholdsState.resultsNotFound &&
                          !searchHouseholdsState.loading)
                        DigitInfoCard(
                          description: localizations.translate(
                            i18.searchBeneficiary.beneficiaryInfoDescription,
                          ),
                          title: localizations.translate(
                            i18.searchBeneficiary.beneficiaryInfoTitle,
                          ),
                        ),
                      if (isSearchByBeneficaryIdEnabled &&
                          searchController.text.trim().isNotEmpty &&
                          !isBeneficiaryIdValidPattern(
                              searchController.text.trim()))
                        DigitInfoCard(
                          description: localizations.translate(
                            i18_local.searchBeneficiary
                                .beneficiaryIdValidInfoDescription,
                          ),
                          title: localizations.translate(
                            i18.searchBeneficiary.beneficiaryInfoTitle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (!isSearchByBeneficaryIdEnabled &&
                  searchHouseholdsState.loading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              BlocListener<DigitScannerBloc, DigitScannerState>(
                listener: (context, scannerState) {
                  if (scannerState.qrCodes.isNotEmpty) {
                    context.read<SearchBlocWrapper>().tagSearchBloc.add(
                          SearchHouseholdsEvent.searchByTag(
                            tag: scannerState.qrCodes.isNotEmpty
                                ? scannerState.qrCodes.lastOrNull!
                                : '',
                            projectId:
                                RegistrationDeliverySingleton().projectId!,
                          ),
                        );
                  }
                },
                child: BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, locationState) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, index) {
                          final i = searchHouseholdsState.householdMembers
                              .elementAt(index);
                          final distance = calculateDistance(
                            Coordinate(
                              lat,
                              long,
                            ),
                            Coordinate(
                              i.household?.address?.latitude,
                              i.household?.address?.longitude,
                            ),
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: kPadding),
                            child: CustomViewBeneficiaryCardSMC(
                              distance: isProximityEnabled ? distance : null,
                              householdMember: i,
                              onOpenPressed: () async {
                                final scannerBloc =
                                    context.read<DigitScannerBloc>();

                                scannerBloc.add(
                                  const DigitScannerEvent.handleScanner(),
                                );

                                if ((i.tasks != null &&
                                        i.tasks?.last.status ==
                                            Status.closeHousehold.toValue() &&
                                        (i.tasks ?? []).isNotEmpty) ||
                                    (i.projectBeneficiaries ?? []).isEmpty) {
                                  setState(() {
                                    selectedFilters = [];
                                  });
                                  blocWrapper.clearEvent();
                                  await context.router.push(
                                    registration_delivery_router
                                        .BeneficiaryRegistrationWrapperRoute(
                                      initialState: BeneficiaryRegistrationState
                                          .editHousehold(
                                              householdModel: i.household!,
                                              individualModel: i.members!,
                                              registrationDate: DateTime.now(),
                                              projectBeneficiaryModel:
                                                  (i.projectBeneficiaries ?? [])
                                                          .isNotEmpty
                                                      ? i.projectBeneficiaries
                                                          ?.last
                                                      : null,
                                              addressModel: i.headOfHousehold!
                                                  .address!.last,
                                              headOfHousehold:
                                                  i.headOfHousehold),
                                    ),
                                  );
                                } else {
                                  await context.router.push(
                                      registration_delivery_router
                                          .BeneficiaryWrapperRoute(wrapper: i));
                                }
                                setState(() {
                                  isProximityEnabled = false;
                                });
                                searchController.clear();
                                selectedFilters.clear();
                                blocWrapper.clearEvent();
                              },
                            ),
                          );
                        },
                        childCount:
                            searchHouseholdsState.householdMembers.length,
                      ),
                    );
                  },
                ),
              ),
              if (isSearchByBeneficaryIdEnabled)
                BlocConsumer<IndividualGlobalSearchSMCBloc,
                    SearchHouseholdsSMCState>(
                  listener: (context, searchSMCstate) {},
                  builder: (context, searchSMCstate) {
                    if (searchSMCstate.loading) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, index) {
                            final i = searchSMCstate.householdMembers[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: kPadding),
                              child: CustomViewBeneficiaryCardSMC(
                                householdMember: i,
                                onOpenPressed: () async {
                                  final scannerBloc =
                                      context.read<DigitScannerBloc>();

                                  scannerBloc.add(
                                    const DigitScannerEvent.handleScanner(),
                                  );

                                  if ((i.tasks != null &&
                                          i.tasks?.last.status ==
                                              Status.closeHousehold.toValue() &&
                                          (i.tasks ?? []).isNotEmpty) ||
                                      (i.projectBeneficiaries ?? []).isEmpty) {
                                    setState(() {
                                      selectedFilters = [];
                                    });
                                    blocWrapper.clearEvent();
                                    await context.router.push(
                                      registration_delivery_router
                                          .BeneficiaryRegistrationWrapperRoute(
                                        initialState: BeneficiaryRegistrationState
                                            .editHousehold(
                                                householdModel: i.household!,
                                                individualModel: i.members!,
                                                registrationDate:
                                                    DateTime.now(),
                                                projectBeneficiaryModel:
                                                    (i.projectBeneficiaries ??
                                                                [])
                                                            .isNotEmpty
                                                        ? i.projectBeneficiaries
                                                            ?.last
                                                        : null,
                                                addressModel: i.headOfHousehold!
                                                    .address!.last,
                                                headOfHousehold:
                                                    i.headOfHousehold),
                                      ),
                                    );
                                  } else {
                                    await context.router.push(
                                        registration_delivery_router
                                            .BeneficiaryWrapperRoute(
                                                wrapper: i));
                                  }
                                  setState(() {
                                    isProximityEnabled = false;
                                    isSearchByBeneficaryIdEnabled = false;
                                  });
                                  searchController.clear();
                                  selectedFilters.clear();
                                  blocWrapper.clearEvent();
                                },
                              ),
                            );
                          },
                          childCount: searchSMCstate.householdMembers.length,
                        ),
                      );
                    }
                  },
                ),
              if (isSearchByBeneficaryIdEnabled &&
                  searchController.text.trim().isNotEmpty &&
                  !isBeneficiaryIdValid(searchController.text.trim()))
                SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, index) {
                  return DigitInfoCard(
                    description: localizations.translate(
                      i18.searchBeneficiary.beneficiaryInfoDescription,
                    ),
                    title: localizations.translate(
                      i18.searchBeneficiary.beneficiaryInfoTitle,
                    ),
                  );
                }, childCount: 1))
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 70,
          child: Card(
            margin: const EdgeInsets.all(0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(kPadding, 0, kPadding, 0),
              child: Column(
                children: [
                  DigitElevatedButton(
                    onPressed: searchHouseholdsState.searchQuery != null &&
                            searchHouseholdsState.searchQuery!.isNotEmpty
                        ? () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<DigitScannerBloc>().add(
                                  const DigitScannerEvent.handleScanner(),
                                );
                            context.router.push(registration_delivery_router
                                .BeneficiaryRegistrationWrapperRoute(
                              initialState:
                                  const BeneficiaryRegistrationCreateState(),
                            ));
                            setState(() {
                              isProximityEnabled = false;
                            });
                            searchController.clear();
                            selectedFilters = [];
                            blocWrapper.clearEvent();
                          }
                        : null,
                    child: Center(
                      child: Text(localizations.translate(
                        i18.searchBeneficiary.beneficiaryAddActionLabel,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getFilterIconNLabel() {
    return {
      'label': localizations.translate(
        i18.searchBeneficiary.filterLabel,
      ),
      'icon': Icons.filter_alt
    };
  }

  showFilterDialog() async {
    var filters = await DigitDialog.show(context,
        options: DigitDialogOptions(
          titlePadding: EdgeInsets.zero,
          dialogPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          barrierDismissible: true,
          content: StatusFilterSMC(
            selectedFilters: selectedFilters,
            titleIcon: Icon(getFilterIconNLabel()['icon'],
                color: const DigitColors().burningOrange),
            titleText: getFilterIconNLabel()['label'],
            isCloseIcon: true,
          ),
        ));

    if (filters != null && filters.isNotEmpty) {
      setState(() {
        selectedFilters = [];
      });
      setState(() {
        selectedFilters.addAll(filters);
      });
      triggerGlobalSearchEvent();
    } else {
      setState(() {
        selectedFilters = [];
      });
      blocWrapper.clearEvent();
      triggerGlobalSearchEvent();
    }
  }

  void SearchByBeneficiaryId(
      {bool isPagination = false, String beneficiaryId = ""}) {
    final individualglobalsearchSMC =
        context.read<IndividualGlobalSearchSMCBloc>();
    individualglobalsearchSMC.add(IndividualGlobalSearchSMCEvent(
        globalSearchParams: GlobalSearchParametersSMC(
      isProximityEnabled: isProximityEnabled,
      latitude: lat,
      longitude: long,
      maxRadius: RegistrationDeliverySingleton().maxRadius,
      nameSearch: searchController.text.trim().length > 2
          ? searchController.text.trim()
          : blocWrapper.searchHouseholdsBloc.state.searchQuery,
      beneficiaryId: beneficiaryId,
      filter: selectedFilters,
      offset: isPagination
          ? blocWrapper.individualGlobalSearchBloc.state.offset
          : offset,
      limit: isPagination
          ? blocWrapper.individualGlobalSearchBloc.state.limit
          : limit,
      projectId: context.projectId,
    )));
  }

  void triggerGlobalSearchEvent({bool isPagination = false}) {
    if (!isPagination) {
      blocWrapper.clearEvent();
    }
    if (RegistrationDeliverySingleton().beneficiaryType ==
        BeneficiaryType.individual) {
      if (isProximityEnabled ||
          selectedFilters.isNotEmpty ||
          searchController.text.isNotEmpty) {
        blocWrapper.individualGlobalSearchBloc
            .add(SearchHouseholdsEvent.individualGlobalSearch(
                globalSearchParams: GlobalSearchParameters(
          isProximityEnabled: isProximityEnabled,
          latitude: lat,
          longitude: long,
          maxRadius: RegistrationDeliverySingleton().maxRadius,
          nameSearch: searchController.text.trim().length > 2
              ? searchController.text.trim()
              : blocWrapper.searchHouseholdsBloc.state.searchQuery,
          filter: selectedFilters,
          offset: isPagination
              ? blocWrapper.individualGlobalSearchBloc.state.offset
              : offset,
          limit: isPagination
              ? blocWrapper.individualGlobalSearchBloc.state.limit
              : limit,
          projectId: context.projectId,
        )));
      }
    } else {
      if (isProximityEnabled ||
          selectedFilters.isNotEmpty ||
          searchController.text.isNotEmpty) {
        blocWrapper.houseHoldGlobalSearchBloc
            .add(SearchHouseholdsEvent.houseHoldGlobalSearch(
                globalSearchParams: GlobalSearchParameters(
          projectId: RegistrationDeliverySingleton().projectId,
          isProximityEnabled: isProximityEnabled,
          latitude: lat,
          longitude: long,
          maxRadius: RegistrationDeliverySingleton().maxRadius,
          nameSearch: searchController.text.trim().length > 2
              ? searchController.text.trim()
              : blocWrapper.searchHouseholdsBloc.state.searchQuery,
          filter: selectedFilters,
          offset: isPagination
              ? blocWrapper.houseHoldGlobalSearchBloc.state.offset
              : offset,
          limit: isPagination
              ? blocWrapper.houseHoldGlobalSearchBloc.state.limit
              : limit,
        )));
      }
    }
  }

  String getStatus(String selectedFilter) {
    final statusMap = {
      Status.delivered.toValue(): Status.delivered,
      // Status.notDelivered.toValue(): Status.notDelivered,
      Status.visited.toValue(): Status.visited,
      Status.notVisited.toValue(): Status.notVisited,
      Status.beneficiaryRefused.toValue(): Status.beneficiaryRefused,
      Status.beneficiaryReferred.toValue(): Status.beneficiaryReferred,
      Status.administeredSuccess.toValue(): Status.administeredSuccess,
      Status.administeredFailed.toValue(): Status.administeredFailed,
      Status.inComplete.toValue(): Status.inComplete,
      Status.toAdminister.toValue(): Status.toAdminister,
      Status.closeHousehold.toValue(): Status.closeHousehold,
      Status.registered.toValue(): Status.registered,
      Status.notRegistered.toValue(): Status.notRegistered,
    };

    var mappedStatus = statusMap.entries
        .where((element) => element.value.name == selectedFilter)
        .first
        .key;
    if (mappedStatus != null) {
      return mappedStatus;
    } else {
      return selectedFilter;
    }
  }

  bool isBeneficiaryIdValid(String value) {
    if (value.trim().length != 14) return false;
    for (var i = 0; i < value.length; i++) {
      if ((i == 4 || i == 9) && value[i] != '-')
        return false;
      else if (isLowerCase(value[i])) return false;
    }
    return true;
  }

  bool isLowerCase(String ch) {
    return ch.codeUnitAt(0) >= 97 && ch.codeUnitAt(0) <= 122;
  }

  bool isBeneficiaryIdValidPattern(String value) {
    bool isValid = true;
    if (value.trim().length > 14) {
      isValid = false;
    } else if (!pattern.hasMatch(value.trim())) {
      isValid = false;
    }
    return isValid;
  }
}
