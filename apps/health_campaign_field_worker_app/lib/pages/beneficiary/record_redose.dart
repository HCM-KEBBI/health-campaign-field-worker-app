import 'dart:math';

import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_reactive_search_dropdown.dart';
import 'package:digit_components/widgets/atoms/digit_stepper.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../blocs/app_initialization/app_initialization.dart';
import '../../blocs/delivery_intervention/deliver_intervention.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/product_variant/product_variant.dart';
import '../../blocs/project/project.dart';
import '../../data/local_store/no_sql/schema/app_configuration.dart';
import '../../models/data_model.dart';
import '../../models/project_type/project_type_model.dart';
import '../../router/app_router.dart';
import '../../utils/environment_config.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/utils.dart';
import '../../widgets/beneficiary/resource_beneficiary_card.dart';
import '../../widgets/component_wrapper/product_variant_bloc_wrapper.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';

class RecordRedosePage extends LocalizedStatefulWidget {
  final bool isEditing;

  const RecordRedosePage({
    super.key,
    super.appLocalizations,
    this.isEditing = false,
  });

  @override
  State<RecordRedosePage> createState() => _RecordRedosePageState();
}

class _RecordRedosePageState extends LocalizedState<RecordRedosePage> {
  // Constants for form control keys
  static const _resourceDeliveredKey = 'resourceDelivered';
  static const _quantityDistributedKey = 'quantityDistributed';
  static const _doseAdministrationKey = 'doseAdministered';
  static const _dateOfAdministrationKey = 'dateOfAdministration';
  static const _doseAdministeredByKey = 'doseAdministeredBy';
  static const _deliveryCommentKey = 'deliveryComment';
  //static key for recording redose
  static const _reDoseQuantityKey = 'reDoseQuantity';

  // Variable to track dose administration status
  bool doseAdministered = false;

  // List of controllers for form elements
  final List _controllers = [];

  // toggle doseAdministered
  void checkDoseAdministration(bool newValue) {
    setState(() {
      doseAdministered = newValue;
    });
  }

// Initialize the currentStep variable to keep track of the current step in a process.
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<StepsModel> generateSteps(int numberOfDoses) {
      return List.generate(numberOfDoses, (index) {
        return StepsModel(
          title:
              '${localizations.translate(i18.deliverIntervention.dose)}${index + 1}',
          number: (index + 1).toString(),
        );
      });
    }

    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        return ProductVariantBlocWrapper(
          child: BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
            builder: (context, householdOverviewState) {
              final householdMemberWrapper =
                  householdOverviewState.householdMemberWrapper;

              final projectBeneficiary =
                  context.beneficiaryType != BeneficiaryType.individual
                      ? [householdMemberWrapper.projectBeneficiaries.first]
                      : householdMemberWrapper.projectBeneficiaries
                          .where(
                            (element) =>
                                element.beneficiaryClientReferenceId ==
                                householdOverviewState
                                    .selectedIndividual?.clientReferenceId,
                          )
                          .toList();

              final projectState = context.read<ProjectBloc>().state;

              return Scaffold(
                body: householdOverviewState.loading
                    ? const Center(child: CircularProgressIndicator())
                    : BlocBuilder<DeliverInterventionBloc,
                        DeliverInterventionState>(
                        builder: (context, deliveryInterventionstate) {
                          List<ProductVariantsModel>? productVariants =
                              projectState.projectType?.cycles?.isNotEmpty ==
                                      true
                                  ? (fetchProductVariant(
                                      projectState
                                              .projectType!
                                              .cycles![deliveryInterventionstate
                                                      .cycle -
                                                  1]
                                              .deliveries?[
                                          deliveryInterventionstate.dose - 1],
                                      householdOverviewState.selectedIndividual,
                                    )?.productVariants)
                                  : projectState.projectType?.resources;

                          final int numberOfDoses = (projectState
                                      .projectType?.cycles?.isNotEmpty ==
                                  true)
                              ? (projectState
                                      .projectType
                                      ?.cycles?[
                                          deliveryInterventionstate.cycle - 1]
                                      .deliveries
                                      ?.length) ??
                                  0
                              : 0;

                          final String? getDeliveryStrategy = (projectState
                                          .projectType?.cycles ??
                                      [])
                                  .isNotEmpty
                              ? (projectState
                                  .projectType
                                  ?.cycles?[deliveryInterventionstate.cycle == 0
                                      ? deliveryInterventionstate.cycle
                                      : deliveryInterventionstate.cycle - 1]
                                  .deliveries?[
                                      deliveryInterventionstate.dose - 1]
                                  .deliveryStrategy)
                              : DeliverStrategyType.direct.toValue();

                          final steps = generateSteps(numberOfDoses);

                          return BlocBuilder<ProductVariantBloc,
                              ProductVariantState>(
                            builder: (context, productState) {
                              return productState.maybeWhen(
                                orElse: () => const Offstage(),
                                fetched: (productVariantsvalue) {
                                  final variant = productState.whenOrNull(
                                    fetched: (productVariants) {
                                      return productVariants;
                                    },
                                  );

                                  return ReactiveFormBuilder(
                                    form: () => buildForm(
                                      context,
                                      productVariants,
                                      variant,
                                    ),
                                    builder: (context, form, child) {
                                      return ScrollableContent(
                                        enableFixedButton: true,
                                        footer: BlocBuilder<
                                            DeliverInterventionBloc,
                                            DeliverInterventionState>(
                                          builder: (context, state) {
                                            return DigitCard(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, kPadding, 0, 0),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      kPadding, 0, kPadding, 0),
                                              child: DigitElevatedButton(
                                                onPressed: () async {
                                                  if (((form.control(
                                                    _resourceDeliveredKey,
                                                  ) as FormArray)
                                                              .value
                                                          as List<
                                                              ProductVariantModel?>)
                                                      .any((ele) =>
                                                          ele?.productId ==
                                                          null)) {
                                                    await DigitToast.show(
                                                      context,
                                                      options:
                                                          DigitToastOptions(
                                                        localizations.translate(i18
                                                            .deliverIntervention
                                                            .resourceDeliveredValidation),
                                                        true,
                                                        theme,
                                                      ),
                                                    );
                                                  } else if ((((form.control(
                                                            _quantityDistributedKey,
                                                          ) as FormArray)
                                                              .value) ??
                                                          [])
                                                      .any((e) => e == 0)) {
                                                    await DigitToast.show(
                                                      context,
                                                      options:
                                                          DigitToastOptions(
                                                        localizations.translate(i18
                                                            .deliverIntervention
                                                            .resourceCannotBeZero),
                                                        true,
                                                        theme,
                                                      ),
                                                    );
                                                  } else if (doseAdministered &&
                                                      form
                                                              .control(
                                                                _deliveryCommentKey,
                                                              )
                                                              .value ==
                                                          null) {
                                                    await DigitToast.show(
                                                      context,
                                                      options:
                                                          DigitToastOptions(
                                                        localizations.translate(i18
                                                            .deliverIntervention
                                                            .deliveryCommentRequired),
                                                        true,
                                                        theme,
                                                      ),
                                                    );
                                                  } else {
                                                    final oldTask =
                                                        deliveryInterventionstate
                                                            .oldTask;
                                                    // Extract productvariantList from the form
                                                    final productvariantList =
                                                        ((form.control(_resourceDeliveredKey)
                                                                    as FormArray)
                                                                .value
                                                            as List<
                                                                ProductVariantModel?>);

                                                    var quantityDistributedFormArray =
                                                        form.control(
                                                      _quantityDistributedKey,
                                                    ) as FormArray?;

                                                    if (oldTask != null &&
                                                        quantityDistributedFormArray !=
                                                            null) {
                                                      var updatedTask =
                                                          updateTask(
                                                        oldTask,
                                                        productvariantList,
                                                        form,
                                                        quantityDistributedFormArray,
                                                      );

                                                      final shouldSubmit =
                                                          await DigitDialog
                                                              .show<bool>(
                                                        context,
                                                        options:
                                                            DigitDialogOptions(
                                                          titleText:
                                                              localizations
                                                                  .translate(
                                                            i18.deliverIntervention
                                                                .dialogTitle,
                                                          ),
                                                          contentText:
                                                              localizations
                                                                  .translate(
                                                            i18.deliverIntervention
                                                                .dialogContent,
                                                          ),
                                                          primaryAction:
                                                              DigitDialogActions(
                                                            label: localizations
                                                                .translate(
                                                              i18.common
                                                                  .coreCommonSubmit,
                                                            ),
                                                            action: (ctx) {
                                                              Navigator.of(
                                                                context,
                                                                rootNavigator:
                                                                    true,
                                                              ).pop(true);
                                                            },
                                                          ),
                                                          secondaryAction:
                                                              DigitDialogActions(
                                                            label: localizations
                                                                .translate(
                                                              i18.common
                                                                  .coreCommonCancel,
                                                            ),
                                                            action: (context) =>
                                                                Navigator.of(
                                                              context,
                                                              rootNavigator:
                                                                  true,
                                                            ).pop(false),
                                                          ),
                                                        ),
                                                      );

                                                      if (shouldSubmit ??
                                                          false) {
                                                        if (context.mounted) {
                                                          context.router
                                                              .popUntilRouteWithName(
                                                            BeneficiaryWrapperRoute
                                                                .name,
                                                          );

                                                          context
                                                              .read<
                                                                  DeliverInterventionBloc>()
                                                              .add(
                                                                DeliverInterventionSubmitEvent(
                                                                  [
                                                                    updatedTask,
                                                                  ],
                                                                  true,
                                                                  context
                                                                      .boundary,
                                                                ),
                                                              );

                                                          if (state.futureDeliveries !=
                                                                  null &&
                                                              state
                                                                  .futureDeliveries!
                                                                  .isNotEmpty &&
                                                              projectState
                                                                      .projectType
                                                                      ?.cycles
                                                                      ?.isNotEmpty ==
                                                                  true) {
                                                            context.router.push(
                                                              SplashAcknowledgementRoute(
                                                                doseAdministrationVerification:
                                                                    true,
                                                              ),
                                                            );
                                                          } else {
                                                            context.router.push(
                                                              SplashAcknowledgementRoute(
                                                                enableBackToSearch:
                                                                    true,
                                                              ),
                                                            );
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Center(
                                                  child: Text(
                                                    localizations.translate(
                                                      i18.common
                                                          .coreCommonSubmit,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        header: const Column(children: [
                                          BackNavigationHelpHeaderWidget(
                                            showHelp: false,
                                          ),
                                        ]),
                                        children: [
                                          Column(
                                            children: [
                                              DigitCard(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    kPadding * 2,
                                                    kPadding * 2,
                                                    kPadding * 2,
                                                    kPadding * 2,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          localizations
                                                              .translate(
                                                            i18.deliverIntervention
                                                                .recordRedoseLabel,
                                                          ),
                                                          style: theme.textTheme
                                                              .displayMedium,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              DigitCard(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      localizations.translate(
                                                        i18.deliverIntervention
                                                            .deliverInterventionResourceLabel,
                                                      ),
                                                      style: theme.textTheme
                                                          .headlineLarge,
                                                    ),
                                                    ..._controllers
                                                        .map((e) =>
                                                            ResourceBeneficiaryCard(
                                                              form: form,
                                                              cardIndex:
                                                                  _controllers
                                                                      .indexOf(
                                                                e,
                                                              ),
                                                              totalItems:
                                                                  _controllers
                                                                      .length,
                                                              isAdministered:
                                                                  doseAdministered,
                                                              onDelete:
                                                                  (index) {
                                                                (form.control(
                                                                  _resourceDeliveredKey,
                                                                ) as FormArray)
                                                                    .removeAt(
                                                                  index,
                                                                );
                                                                (form.control(
                                                                  _quantityDistributedKey,
                                                                ) as FormArray)
                                                                    .removeAt(
                                                                  index,
                                                                );
                                                                _controllers
                                                                    .removeAt(
                                                                  index,
                                                                );
                                                                setState(() {
                                                                  _controllers;
                                                                });
                                                              },
                                                            ))
                                                        .toList(),
                                                  ],
                                                ),
                                              ),
                                              DigitCard(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    BlocBuilder<
                                                        AppInitializationBloc,
                                                        AppInitializationState>(
                                                      builder:
                                                          (context, state) {
                                                        if (state
                                                            is! AppInitialized) {
                                                          return const Offstage();
                                                        }

                                                        final deliveryCommentOptions = state
                                                                .appConfiguration
                                                                .deliveryCommentOptionsSmc ??
                                                            <DeliveryCommentOptions>[];

                                                        return DigitReactiveDropdown<
                                                            String>(
                                                          label: localizations
                                                              .translate(
                                                            i18.deliverIntervention
                                                                .reasonForRedoseLabel,
                                                          ),
                                                          readOnly: false,
                                                          isRequired: true,
                                                          valueMapper: (value) =>
                                                              localizations
                                                                  .translate(
                                                            value,
                                                          ),
                                                          initialValue:
                                                              deliveryCommentOptions
                                                                  .firstOrNull
                                                                  ?.name,
                                                          menuItems:
                                                              deliveryCommentOptions
                                                                  .map((e) {
                                                            return e.code;
                                                          }).toList(),
                                                          formControlName:
                                                              _deliveryCommentKey,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
              );
            },
          ),
        );
      },
    );
  }

  addController(FormGroup form) {
    (form.control(_resourceDeliveredKey) as FormArray)
        .add(FormControl<ProductVariantModel>());
    (form.control(_quantityDistributedKey) as FormArray)
        .add(FormControl<String>(validators: [Validators.required]));
  }

  TaskModel updateTask(
    TaskModel oldTask,
    List<ProductVariantModel?> productvariantList,
    FormGroup form,
    FormArray quantityDistributedFormArray,
  ) {
    final taskResources = oldTask.resources ?? [];
    if (taskResources.isNotEmpty) {
      for (var resource in taskResources) {
        var productVariantId = resource.productVariantId;
        var productVariant = productvariantList
            .where((element) => element?.id == productVariantId)
            .firstOrNull;
        var quantity = 0;

        if (productVariant == null) {
          continue;
        }
        var quantityIndex = productvariantList.indexOf(productVariant);

        if (resource.additionalFields == null) {
          quantity = quantityDistributedFormArray.value![quantityIndex];
          resource = resource.copyWith(
            additionalFields: TaskResourceAdditionalFields(
              version: 1,
              fields: [
                const AdditionalField(Constants.reAdministeredKey, true),
                AdditionalField(_reDoseQuantityKey, quantity),
              ],
            ),
          );
        } else {
          List<AdditionalField> newAdditionalFields = [
            const AdditionalField(Constants.reAdministeredKey, true),
            AdditionalField(_reDoseQuantityKey, quantity),
          ];
          resource = resource.additionalFields!.fields.isEmpty
              ? resource.copyWith(
                  additionalFields: resource.additionalFields!
                      .copyWith(fields: newAdditionalFields),
                )
              : resource.copyWith(
                  additionalFields: resource.additionalFields!.copyWith(
                    fields: [
                      ...resource.additionalFields!.fields,
                      ...newAdditionalFields,
                    ],
                  ),
                );
        }
      }
    }
    var updatedTask = oldTask.copyWith(
      additionalFields: oldTask.additionalFields != null
          ? TaskAdditionalFields(
              version: oldTask.additionalFields!.version,
              fields: [
                ...oldTask.additionalFields!.fields,
                const AdditionalField(Constants.reAdministeredKey, true),
              ],
            )
          : TaskAdditionalFields(
              version: 1,
              fields: [
                const AdditionalField(Constants.reAdministeredKey, true),
              ],
            ),
    );

    return updatedTask;
  }

// This method builds a form used for delivering interventions.

  FormGroup buildForm(
    BuildContext context,
    List<ProductVariantsModel>? productVariants,
    List<ProductVariantModel>? variants,
  ) {
    final bloc = context.read<DeliverInterventionBloc>().state;

    // Add controllers for each product variant to the _controllers list.

    _controllers
        .addAll(productVariants!.map((e) => productVariants.indexOf(e)));

    return fb.group(<String, Object>{
      _doseAdministrationKey: FormControl<String>(
        value:
            '${localizations.translate(i18.deliverIntervention.cycle)} ${bloc.cycle == 0 ? (bloc.cycle + 1) : bloc.cycle}'
                .toString(),
        validators: [],
      ),
      _dateOfAdministrationKey:
          FormControl<DateTime>(value: DateTime.now(), validators: []),
      _resourceDeliveredKey: FormArray<ProductVariantModel>(
        [
          ..._controllers.map((e) => FormControl<ProductVariantModel>(
                value: variants != null &&
                        _controllers.indexOf(e) < variants.length
                    ? variants.firstWhereOrNull(
                        (element) =>
                            element.id ==
                            productVariants
                                .elementAt(_controllers.indexOf(e))
                                .productVariantId,
                      )
                    : null,
              )),
        ],
      ),
      _quantityDistributedKey: FormArray<int>([
        ..._controllers.map(
          (e) => FormControl<int>(
            validators: [
              Validators.required,
              Validators.min(0),
              Validators.max(1),
            ],
            value: 0,
          ),
        ),
      ]),
      _deliveryCommentKey: FormControl<String>(
        validators: [],
      ),
      _doseAdministeredByKey: FormControl<String>(
        validators: [],
        value: context.loggedInUser.userName,
      ),
    });
  }
}
