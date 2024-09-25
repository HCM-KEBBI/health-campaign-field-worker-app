import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../blocs/app_initialization/app_initialization.dart';
import '../blocs/beneficiary_registration/beneficiary_registration.dart';
import '../blocs/search_households/search_households.dart';
import '../models/data_model.dart';
import '../router/app_router.dart';
import '../utils/i18_key_constants.dart' as i18;
import '../utils/utils.dart';
import '../widgets/beneficiary/view_beneficiary_card.dart';
import '../widgets/header/back_navigation_help_header.dart';
import '../widgets/localized.dart';

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

  double lat = 0.0;
  double long = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) =>
          BlocBuilder<AppInitializationBloc, AppInitializationState>(
        builder: (appcontext, state) {
          if (state is! AppInitialized) return const Offstage();

          final appConfig = state.appConfiguration;

          return Scaffold(
            body: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {
                  final metrics = scrollNotification.metrics;
                  if (metrics.atEdge &&
                      isProximityEnabled &&
                      searchController.text == '' &&
                      metrics.pixels != 0) {
                    final bloc = context.read<SearchHouseholdsBloc>();
                    bloc.add(
                      const SearchHouseholdsLoadingEvent(),
                    );

                    bloc.add(SearchHouseholdsEvent.searchByProximity(
                      latitude: lat,
                      longititude: long,
                      projectId: context.projectId,
                      maxRadius: appConfig.maxRadius!,
                      offset: bloc.state.offset,
                      limit: bloc.state.limit,
                    ));
                  } else if (metrics.atEdge &&
                      searchController.text != '' &&
                      metrics.pixels != 0) {
                    final bloc = context.read<SearchHouseholdsBloc>();
                    bloc.add(
                      const SearchHouseholdsLoadingEvent(),
                    );
                    bloc.add(SearchHouseholdsEvent.searchByHouseholdHead(
                      searchText: searchController.text,
                      projectId: context.projectId,
                      isProximityEnabled: isProximityEnabled,
                      offset: bloc.state.offset,
                      limit: bloc.state.limit,
                    ));
                  }
                }
                // Return true to allow the notification to continue to be dispatched to further ancestors.

                return true;
              },
              child: BlocBuilder<SearchHouseholdsBloc, SearchHouseholdsState>(
                builder: (context, searchState) {
                  return ScrollableContent(
                    header: const Column(children: [
                      BackNavigationHelpHeaderWidget(),
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
                                      context.beneficiaryType !=
                                              BeneficiaryType.individual
                                          ? i18.searchBeneficiary
                                              .statisticsLabelText
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
                                      DigitSearchBar(
                                        controller: searchController,
                                        hintText: localizations.translate(
                                          i18.searchBeneficiary
                                              .beneficiarySearchHintText,
                                        ),
                                        textCapitalization:
                                            TextCapitalization.words,
                                        onChanged: (value) {
                                          final bloc = context
                                              .read<SearchHouseholdsBloc>();
                                          bloc.add(
                                            const SearchHouseholdsClearEvent(),
                                          );

                                          if (value.trim().length < 3 &&
                                              !isProximityEnabled) {
                                            bloc.add(
                                              const SearchHouseholdsClearEvent(),
                                            );

                                            return;
                                          } else {
                                            if (isProximityEnabled &&
                                                value.trim().length < 3) {
                                              bloc.add(
                                                const SearchHouseholdsLoadingEvent(),
                                              );
                                              bloc.add(SearchHouseholdsEvent
                                                  .searchByProximity(
                                                latitude:
                                                    locationState.latitude!,
                                                longititude:
                                                    locationState.longitude!,
                                                projectId: context.projectId,
                                                maxRadius: appConfig.maxRadius!,
                                                limit: bloc.state.limit,
                                                offset: 0,
                                              ));
                                            } else {
                                              bloc.add(
                                                const SearchHouseholdsClearEvent(),
                                              );
                                              bloc.add(
                                                const SearchHouseholdsLoadingEvent(),
                                              );
                                              bloc.add(
                                                SearchHouseholdsEvent
                                                    .searchByHouseholdHead(
                                                  searchText: value.trim(),
                                                  projectId: context.projectId,
                                                  latitude:
                                                      locationState.latitude,
                                                  longitude:
                                                      locationState.longitude,
                                                  isProximityEnabled:
                                                      isProximityEnabled,
                                                  maxRadius:
                                                      appConfig.maxRadius,
                                                  limit: bloc.state.limit,
                                                  offset: 0,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                      locationState.latitude != null
                                          ? Row(
                                              children: [
                                                Switch(
                                                  value: isProximityEnabled,
                                                  onChanged: (value) {
                                                    searchController.clear();
                                                    final bloc = context.read<
                                                        SearchHouseholdsBloc>();
                                                    bloc.add(
                                                      const SearchHouseholdsClearEvent(),
                                                    );

                                                    setState(() {
                                                      isProximityEnabled =
                                                          value;
                                                      lat = locationState
                                                          .latitude!;
                                                      long = locationState
                                                          .longitude!;
                                                    });

                                                    if (locationState
                                                            .hasPermissions &&
                                                        value &&
                                                        locationState
                                                                .latitude !=
                                                            null &&
                                                        locationState
                                                                .longitude !=
                                                            null &&
                                                        appConfig.maxRadius !=
                                                            null &&
                                                        isProximityEnabled) {
                                                      final bloc = context.read<
                                                          SearchHouseholdsBloc>();
                                                      bloc.add(
                                                        const SearchHouseholdsLoadingEvent(),
                                                      );
                                                      bloc.add(
                                                        SearchHouseholdsEvent
                                                            .searchByProximity(
                                                          latitude:
                                                              locationState
                                                                  .latitude!,
                                                          longititude:
                                                              locationState
                                                                  .longitude!,
                                                          projectId:
                                                              context.projectId,
                                                          maxRadius: appConfig
                                                              .maxRadius!,
                                                          limit:
                                                              bloc.state.limit,
                                                          offset: 0,
                                                        ),
                                                      );
                                                    } else {
                                                      final bloc = context.read<
                                                          SearchHouseholdsBloc>();
                                                      bloc.add(
                                                        const SearchHouseholdsClearEvent(),
                                                      );
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
                                            )
                                          : const Offstage(),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: kPadding * 2),
                              if (searchState.resultsNotFound)
                                DigitInfoCard(
                                  description: localizations.translate(
                                    i18.searchBeneficiary
                                        .beneficiaryInfoDescription,
                                  ),
                                  title: localizations.translate(
                                    i18.searchBeneficiary.beneficiaryInfoTitle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, locationState) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (ctx, index) {
                                final i = searchState.householdMembers
                                    .elementAt(index);
                                final distance = calculateDistance(
                                  Coordinate(
                                    lat,
                                    long,
                                  ),
                                  Coordinate(
                                    i.household.address?.latitude,
                                    i.household.address?.longitude,
                                  ),
                                );

                                return ViewBeneficiaryCard(
                                  distance:
                                      isProximityEnabled ? distance : null,
                                  householdMember: i,
                                  onOpenPressed: () async {
                                    final bloc =
                                        context.read<SearchHouseholdsBloc>();

                                    await context.router.push(
                                      BeneficiaryWrapperRoute(
                                        wrapper: i,
                                      ),
                                    );
                                    setState(() {
                                      isProximityEnabled = false;
                                    });
                                    searchController.clear();

                                    bloc.add(
                                      const SearchHouseholdsClearEvent(),
                                    );
                                  },
                                );
                              },
                              childCount: searchState.householdMembers.length,
                            ),
                          );
                        },
                      ),
                      if (searchState.loading)
                        SliverFillRemaining(
                          child: Container(
                            height: 150,
                            color: Colors.white,
                            child: Center(
                              child: Text(
                                '${localizations.translate(i18.common.loading)}...',
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            bottomNavigationBar: SizedBox(
              child: DigitCard(
                margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
                child: BlocBuilder<SearchHouseholdsBloc, SearchHouseholdsState>(
                  builder: (context, state) {
                    final router = context.router;
                    final spaq1 = context.spaq1;
                    final spaq2 = context.spaq2;

                    VoidCallback? onPressed;

                    onPressed = () {
                      FocusManager.instance.primaryFocus?.unfocus();

                      // if (spaq1 >= 2 && spaq2 >= 2) {
                      searchController.clear();
                      router.push(BeneficiaryRegistrationWrapperRoute(
                        initialState: BeneficiaryRegistrationCreateState(
                          searchQuery: state.searchQuery,
                        ),
                      ));
                      // } else {
                      //   DigitDialog.show(
                      //     context,
                      //     options: DigitDialogOptions(
                      //       titleText: localizations.translate(
                      //         i18.beneficiaryDetails.insufficientStockHeading,
                      //       ),
                      //       titleIcon: Icon(
                      //         Icons.warning,
                      //         color: DigitTheme.instance.colorScheme.error,
                      //       ),
                      //       contentText: localizations.translate(
                      //         i18.beneficiaryDetails.insufficientStockMessage,
                      //       ),
                      //       primaryAction: DigitDialogActions(
                      //         label: localizations
                      //             .translate(i18.beneficiaryDetails.backToHome),
                      //         action: (ctx) {
                      //           Navigator.of(context, rootNavigator: true)
                      //               .pop();
                      //           context.router
                      //               .popUntilRouteWithName(HomeRoute.name);
                      //         },
                      //       ),
                      //     ),
                      //   );
                      //   }
                    };

                    return DigitElevatedButton(
                      onPressed: onPressed,
                      child: Center(
                        child: Text(localizations.translate(
                          i18.searchBeneficiary.beneficiaryAddActionLabel,
                        )),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
