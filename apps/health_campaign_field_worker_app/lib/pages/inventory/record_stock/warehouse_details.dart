import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../blocs/digit_scanner/digit_scanner.dart';
import '../../../blocs/facility/facility.dart';
import '../../../blocs/project/project.dart';
import '../../../blocs/record_stock/record_stock.dart';
import '../../../models/data_model.dart';
import '../../../router/app_router.dart';
import '../../../utils/i18_key_constants.dart' as i18;
import '../../../utils/utils.dart';
import '../../../widgets/header/back_navigation_help_header.dart';
import '../../../widgets/inventory/no_facilities_assigned_dialog.dart';
import '../../../widgets/localized.dart';
import '../../digit_scanner.dart';
import '../facility_selection.dart';

class WarehouseDetailsPage extends LocalizedStatefulWidget {
  const WarehouseDetailsPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<WarehouseDetailsPage> createState() => _WarehouseDetailsPageState();
}

class _WarehouseDetailsPageState extends LocalizedState<WarehouseDetailsPage> {
  static const _dateOfEntryKey = 'dateOfReceipt';
  static const _administrativeUnitKey = 'administrativeUnit';
  static const _warehouseKey = 'warehouse';
  static const _teamCodeKey = 'teamCode';
  bool deliveryTeamSelected = false;

  FacilityModel? facility;

  FormGroup buildForm(
    bool isDistributor,
    RecordStockState stockState,
  ) =>
      fb.group(<String, Object>{
        _dateOfEntryKey: FormControl<DateTime>(value: DateTime.now()),
        _administrativeUnitKey: FormControl<String>(
          value: context.boundary.name,
        ),
        _warehouseKey: FormControl<FacilityModel>(
          validators: isDistributor ? [] : [Validators.required],
          value: facility,
        ),
        _teamCodeKey: FormControl<String>(
          value: stockState.primaryId ??
              context.loggedInUser.userName.toString() +
                  Constants.pipeSeparator +
                  context.loggedInUserUuid,
          validators: isDistributor ? [Validators.required] : [],
        ),
      });

  @override
  Widget build(BuildContext context) {
    final recordStockBloc = BlocProvider.of<RecordStockBloc>(context);
    final isDistributor = context.isDistributor;

    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (ctx, projectState) {
        final selectedProject = projectState.selectedProject;

        if (selectedProject == null) {
          return const Center(child: Text('No project selected'));
        }

        final theme = Theme.of(context);

        return BlocConsumer<FacilityBloc, FacilityState>(
          listener: (context, state) {
            state.whenOrNull(
              empty: () => NoFacilitiesAssignedDialog.show(context),
            );
          },
          builder: (ctx, facilityState) {
            final facilities = facilityState.whenOrNull(
                  fetched: (facilities, _, __) {
                    if (ctx.selectedProject.address?.boundaryType ==
                        Constants.stateBoundaryLevel) {
                      List<FacilityModel> filteredFacilities = facilities
                          .where(
                            (element) =>
                                element.usage == Constants.stateFacility,
                          )
                          .toList();
                      facilities = filteredFacilities.isEmpty
                          ? facilities
                          : filteredFacilities;
                    } else if (ctx.selectedProject.address?.boundaryType ==
                        Constants.lgaBoundaryLevel) {
                      List<FacilityModel> filteredFacilities = facilities
                          .where(
                            (element) => element.usage == Constants.lgaFacility,
                          )
                          .toList();
                      facilities = filteredFacilities.isEmpty
                          ? facilities
                          : filteredFacilities;
                    } else {
                      List<FacilityModel> filteredFacilities = facilities
                          .where(
                            (element) =>
                                element.usage == Constants.healthFacility,
                          )
                          .toList();
                      facilities = filteredFacilities.isEmpty
                          ? facilities
                          : filteredFacilities;
                    }
                    final teamFacilities = [
                      FacilityModel(
                        id: 'Delivery Team',
                        name: 'Delivery Team',
                      ),
                    ];
                    teamFacilities.addAll(
                      facilities,
                    );

                    return context.isDistributor && !context.isWarehouseMgr
                        ? teamFacilities
                        : facilities;
                  },
                ) ??
                [];
            facility = facilities.length >= 2
                ? facilityState.whenOrNull(
                    fetched: (_, __, facility) => facility,
                  )
                : facilities.isNotEmpty
                    ? facilities.first
                    : null;

            if (facility == null && context.isSupervisor) {
              facility = facilities.firstWhereOrNull(
                (element) => element.name == context.loggedInUser.userName,
              );
            }

            final stockState = recordStockBloc.state;
            String dateLabel = i18.warehouseDetails.dateOfReceipt;

            switch (stockState.entryType) {
              case StockRecordEntryType.dispatch:
                dateLabel = isDistributor
                    ? i18.warehouseDetails.dateOfReturn
                    : i18.warehouseDetails.dateOfIssue;
                break;
              case StockRecordEntryType.returned:
                dateLabel = i18.warehouseDetails.dateOfReturn;
                break;
              default:
                dateLabel = i18.warehouseDetails.dateOfReceipt;
                break;
            }

            return Scaffold(
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ReactiveFormBuilder(
                  form: () => buildForm(
                    isDistributor,
                    stockState,
                  ),
                  builder: (context, form, child) {
                    return ScrollableContent(
                      header: const Column(children: [
                        BackNavigationHelpHeaderWidget(),
                      ]),
                      enableFixedButton: true,
                      footer: SizedBox(
                        child: DigitCard(
                          margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                          padding: const EdgeInsets.fromLTRB(
                            kPadding,
                            0,
                            kPadding,
                            0,
                          ),
                          child: ReactiveFormConsumer(
                            builder: (context, form, child) {
                              return DigitElevatedButton(
                                onPressed: !form.valid
                                    ? null
                                    : () {
                                        form.markAllAsTouched();
                                        if (!form.valid) {
                                          return;
                                        }
                                        final dateOfRecord = form
                                            .control(_dateOfEntryKey)
                                            .value as DateTime;

                                        final facility = form
                                            .control(_warehouseKey)
                                            .value as FacilityModel?;

                                        final teamCode = form
                                            .control(_teamCodeKey)
                                            .value as String?;

                                        if (!isDistributor &&
                                            facility == null) {
                                          DigitToast.show(
                                            context,
                                            options: DigitToastOptions(
                                              localizations.translate(
                                                i18.manageStock
                                                    .facilityRequired,
                                              ),
                                              true,
                                              theme,
                                            ),
                                          );
                                        } else if (isDistributor &&
                                            (teamCode == null ||
                                                teamCode.trim().isEmpty)) {
                                          DigitToast.show(
                                            context,
                                            options: DigitToastOptions(
                                              localizations.translate(
                                                i18.manageStock
                                                    .teamCodeRequired,
                                              ),
                                              true,
                                              theme,
                                            ),
                                          );
                                        } else {
                                          context.read<RecordStockBloc>().add(
                                                RecordStockSaveWarehouseDetailsEvent(
                                                  loggedInUserId:
                                                      context.loggedInUserUuid,
                                                  dateOfRecord: dateOfRecord,
                                                  facilityModel: !isDistributor
                                                      ? facility
                                                      : FacilityModel(
                                                          id: teamCode
                                                              .toString()
                                                              .split(
                                                                Constants
                                                                    .pipeSeparator,
                                                              )
                                                              .last,
                                                        ),
                                                  primaryId: (isDistributor
                                                          ? FacilityModel(
                                                              id: teamCode
                                                                  .toString()
                                                                  .split(
                                                                    Constants
                                                                        .pipeSeparator,
                                                                  )
                                                                  .last,
                                                            )
                                                          : facility)!
                                                      .id,
                                                  primaryType: isDistributor
                                                      ? 'STAFF'
                                                      : 'WAREHOUSE',
                                                ),
                                              );
                                          context.router.push(
                                            StockDetailsRoute(),
                                          );
                                        }
                                      },
                                child: child!,
                              );
                            },
                            child: Center(
                              child: Text(
                                localizations.translate(
                                  i18.householdDetails.actionLabel,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      slivers: [
                        SliverToBoxAdapter(
                          child: DigitCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  localizations.translate(
                                    isDistributor
                                        ? i18.warehouseDetails
                                            .transactionDetailsLabel
                                        : i18.warehouseDetails
                                            .warehouseDetailsLabel,
                                  ),
                                  style: theme.textTheme.displayMedium,
                                ),
                                Column(children: [
                                  DigitDateFormPicker(
                                    isEnabled: true,
                                    lastDate: DateTime.now(),
                                    formControlName: _dateOfEntryKey,
                                    label: localizations.translate(
                                      dateLabel,
                                    ),
                                    isRequired: false,
                                    confirmText: localizations.translate(
                                      i18.common.coreCommonOk,
                                    ),
                                    cancelText: localizations.translate(
                                      i18.common.coreCommonCancel,
                                    ),
                                  ),
                                  DigitTextFormField(
                                    readOnly: true,
                                    formControlName: _administrativeUnitKey,
                                    label: localizations.translate(
                                      i18.warehouseDetails.administrativeUnit,
                                    ),
                                  ),
                                ]),
                                if (!isDistributor)
                                  InkWell(
                                    onTap: () async {
                                      final parent = context.router.parent()
                                          as StackRouter;
                                      final facility =
                                          await parent.push<FacilityModel>(
                                        FacilitySelectionRoute(
                                          facilities: facilities,
                                        ),
                                      );

                                      if (facility == null) return;

                                      if (facility.id == 'Delivery Team') {
                                        form.control(_teamCodeKey).value =
                                            context.loggedInUserUuid;
                                        setState(() {
                                          deliveryTeamSelected = true;
                                        });
                                      } else {
                                        setState(() {
                                          deliveryTeamSelected = false;
                                        });
                                      }
                                      form.control(_warehouseKey).value =
                                          facility;
                                    },
                                    child: IgnorePointer(
                                      child: DigitTextFormField(
                                        valueAccessor: FacilityValueAccessor(
                                          facilities,
                                        ),
                                        isRequired: true,
                                        label: localizations.translate(
                                          i18.warehouseDetails.warehouseNameId,
                                        ),
                                        suffix: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(Icons.search),
                                        ),
                                        formControlName: _warehouseKey,
                                        readOnly: false,
                                        onTap: () async {
                                          final parent = context.router.parent()
                                              as StackRouter;
                                          final facility =
                                              await parent.push<FacilityModel>(
                                            FacilitySelectionRoute(
                                              facilities: facilities,
                                            ),
                                          );

                                          if (facility == null) return;

                                          if (facility.id == 'Delivery Team') {
                                            form.control(_teamCodeKey).value =
                                                context.loggedInUserUuid;
                                            setState(() {
                                              deliveryTeamSelected = true;
                                            });
                                          } else {
                                            setState(() {
                                              deliveryTeamSelected = false;
                                            });
                                          }
                                          form.control(_warehouseKey).value =
                                              facility;
                                        },
                                      ),
                                    ),
                                  ),
                                if (isDistributor)
                                  DigitTextFormField(
                                    label: localizations.translate(
                                      i18.manageStock.cddTeamCodeLabel,
                                    ),
                                    readOnly: isDistributor,
                                    formControlName: _teamCodeKey,
                                    onChanged: (val) {
                                      String? value = val as String?;
                                      if (value != null &&
                                          value.trim().isNotEmpty) {
                                        context.read<DigitScannerBloc>().add(
                                              DigitScannerEvent.handleScanner(
                                                barCode: [],
                                                qrCode: [value],
                                              ),
                                            );
                                      } else {
                                        clearQRCodes();
                                      }
                                    },
                                    isRequired: true,
                                    // suffix: IconButton(
                                    //   onPressed: () {
                                    //     Navigator.of(context).push(
                                    //       MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const DigitScannerPage(
                                    //           quantity: 1,
                                    //           isGS1code: false,
                                    //           singleValue: false,
                                    //         ),
                                    //         settings: const RouteSettings(
                                    //           name: '/qr-scanner',
                                    //         ),
                                    //       ),
                                    //     );
                                    //   },
                                    //   icon: Icon(
                                    //     Icons.qr_code_2,
                                    //     color: theme.colorScheme.secondary,
                                    //   ),
                                    // ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void clearQRCodes() {
    context.read<DigitScannerBloc>().add(const DigitScannerEvent.handleScanner(
          barCode: [],
          qrCode: [],
        ));
  }
}
