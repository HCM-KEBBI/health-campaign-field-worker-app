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
import '../../blocs/auth/auth.dart';
import '../../blocs/delivery_intervention/deliver_intervention.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/product_variant/product_variant.dart';
import '../../blocs/project/project.dart';
import '../../blocs/search_households/search_households.dart';
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
  final List<TaskModel> tasks;

  const RecordRedosePage({
    super.key,
    super.appLocalizations,
    this.isEditing = false,
    required this.tasks,
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
  bool doseAdministered = true;

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
                      List<ProductVariantsModel>? productVariants = projectState
                                  .projectType?.cycles?.isNotEmpty ==
                              true
                          ? (fetchProductVariant(
                              projectState
                                  .projectType!
                                  .cycles![deliveryInterventionstate.cycle - 1]
                                  .deliveries?[deliveryInterventionstate
                                      .dose -
                                  1],
                              householdOverviewState.selectedIndividual,
                            )?.productVariants)
                          : projectState.projectType?.resources;

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
                                    footer: BlocBuilder<DeliverInterventionBloc,
                                        DeliverInterventionState>(
                                      builder: (context, state) {
                                        return DigitCard(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, kPadding, 0, 0),
                                          padding: const EdgeInsets.fromLTRB(
                                              kPadding, 0, kPadding, 0),
                                          child: DigitElevatedButton(
                                            onPressed: () async {
                                              form.markAllAsTouched();
                                              if (!form.valid) {
                                                return;
                                              }
                                              if (((form.control(
                                                _resourceDeliveredKey,
                                              ) as FormArray)
                                                          .value
                                                      as List<
                                                          ProductVariantModel?>)
                                                  .any((ele) =>
                                                      ele?.productId == null)) {
                                                await DigitToast.show(
                                                  context,
                                                  options: DigitToastOptions(
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
                                                  options: DigitToastOptions(
                                                    localizations.translate(i18
                                                        .deliverIntervention
                                                        .resourceCannotBeZero),
                                                    true,
                                                    theme,
                                                  ),
                                                );
                                              } else {
                                                // get the latest successful task
                                                var successfulTask = widget
                                                    .tasks
                                                    .where((element) =>
                                                        element.status ==
                                                        Status
                                                            .administeredSuccess
                                                            .toValue())
                                                    .lastOrNull;
                                                // Extract productvariantList from the form
                                                final productvariantList = ((form
                                                                .control(
                                                                    _resourceDeliveredKey)
                                                            as FormArray)
                                                        .value
                                                    as List<
                                                        ProductVariantModel?>);

                                                var quantityDistributedFormArray =
                                                    form.control(
                                                  _quantityDistributedKey,
                                                ) as FormArray?;

                                                if (successfulTask != null &&
                                                    quantityDistributedFormArray !=
                                                        null) {
                                                  var updatedTask = updateTask(
                                                    successfulTask,
                                                    productvariantList,
                                                    quantityDistributedFormArray,
                                                    form,
                                                  );
                                                  var newTask = getNewTask(
                                                    context,
                                                    updatedTask,
                                                  );

                                                  final shouldSubmit =
                                                      await DigitDialog.show<
                                                          bool>(
                                                    context,
                                                    options: DigitDialogOptions(
                                                      titleText: localizations
                                                          .translate(
                                                        i18.deliverIntervention
                                                            .dialogTitle,
                                                      ),
                                                      contentText: localizations
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
                                                            rootNavigator: true,
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
                                                          rootNavigator: true,
                                                        ).pop(false),
                                                      ),
                                                    ),
                                                  );

                                                  if (shouldSubmit ?? false) {
                                                    if (context.mounted) {
                                                      // context.router
                                                      //     .popUntilRouteWithName(
                                                      //   BeneficiaryWrapperRoute
                                                      //       .name,
                                                      // );

                                                      int spaq1 = 0;
                                                      int spaq2 = 0;

                                                      var productVariantId =
                                                          updatedTask
                                                              .resources!
                                                              .first
                                                              .productVariantId;
                                                      final productVariant =
                                                          productvariantList
                                                              .where((element) =>
                                                                  element?.id ==
                                                                  productVariantId)
                                                              .firstOrNull;

                                                      var quantityIndex =
                                                          productvariantList
                                                              .indexOf(
                                                        productVariant,
                                                      );

                                                      final quantity =
                                                          quantityDistributedFormArray
                                                                  .value![
                                                              quantityIndex];

                                                      if (productVariant ==
                                                              null ||
                                                          productVariant.sku ==
                                                              null ||
                                                          productVariant.sku!
                                                              .contains(
                                                            Constants
                                                                .spaq1String,
                                                          )) {
                                                        spaq1 = quantity !=
                                                                    null &&
                                                                quantity !=
                                                                    'null'
                                                            ? int.parse(quantity
                                                                    .toString()) *
                                                                -1
                                                            : 0;
                                                      } else {
                                                        spaq2 = quantity !=
                                                                    null &&
                                                                quantity !=
                                                                    'null'
                                                            ? int.parse(quantity
                                                                    .toString()) *
                                                                -1
                                                            : 0;
                                                      }

                                                      context
                                                          .read<AuthBloc>()
                                                          .add(
                                                            AuthAddSpaqCountsEvent(
                                                              spaq1Count: spaq1,
                                                              spaq2Count: spaq2,
                                                            ),
                                                          );
                                                      final reloadState =
                                                          context.read<
                                                              HouseholdOverviewBloc>();
                                                      // submit the updated task

                                                      context
                                                          .read<
                                                              DeliverInterventionBloc>()
                                                          .add(
                                                            DeliverInterventionSubmitEvent(
                                                              [
                                                                updatedTask,
                                                              ],
                                                              true,
                                                              context.boundary,
                                                            ),
                                                          );
                                                      // submit the newly created task
                                                      context
                                                          .read<
                                                              DeliverInterventionBloc>()
                                                          .add(
                                                            DeliverInterventionSubmitEvent(
                                                              [
                                                                newTask,
                                                              ],
                                                              false,
                                                              context.boundary,
                                                            ),
                                                          );

                                                      Future.delayed(
                                                        const Duration(
                                                          milliseconds: 300,
                                                        ),
                                                        () {
                                                          reloadState.add(
                                                            HouseholdOverviewReloadEvent(
                                                              projectId: context
                                                                  .projectId,
                                                              projectBeneficiaryType:
                                                                  context
                                                                      .beneficiaryType,
                                                            ),
                                                          );
                                                        },
                                                      ).then((value) => {
                                                            context.router.push(
                                                              HouseholdAcknowledgementRoute(
                                                                enableViewHousehold:
                                                                    true,
                                                              ),
                                                            ),
                                                          });
                                                    }
                                                  }
                                                }
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                localizations.translate(
                                                  i18.common.coreCommonSubmit,
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
                                                kPadding,
                                                kPadding * 2,
                                                kPadding,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      localizations.translate(
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
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  localizations.translate(
                                                    i18.deliverIntervention
                                                        .deliverInterventionResourceLabel,
                                                  ),
                                                  style: theme
                                                      .textTheme.headlineLarge,
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
                                                          onDelete: (index) {
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
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                BlocBuilder<
                                                    AppInitializationBloc,
                                                    AppInitializationState>(
                                                  builder: (context, state) {
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
                                                      validationMessages: {
                                                        'required': (object) =>
                                                            localizations
                                                                .translate(
                                                              i18.deliverIntervention
                                                                  .selectReasonForRedoseLabel,
                                                            ),
                                                      },
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
    FormArray quantityDistributedFormArray,
    FormGroup form,
  ) {
    final taskResources = oldTask.resources ?? [];
    List<TaskResourceModel> updatedTaskResources = [];
    if (taskResources.isNotEmpty) {
      for (var resource in taskResources) {
        var productVariantId = resource.productVariantId;
        var productVariant = productvariantList
            .where((element) => element?.id == productVariantId)
            .firstOrNull;
        var quantity = 0;

        if (productVariant == null) {
          updatedTaskResources.add(resource);
          continue;
        }
        var quantityIndex = productvariantList.indexOf(productVariant);
        TaskResourceModel updatedResource;

        if (resource.additionalFields == null) {
          quantity = quantityDistributedFormArray.value![quantityIndex];
          updatedResource = resource.copyWith(
            additionalFields: TaskResourceAdditionalFields(
              version: 1,
              fields: [
                const AdditionalField(Constants.reAdministeredKey, true),
                AdditionalField(_reDoseQuantityKey, quantity.toString()),
              ],
            ),
          );
        } else {
          List<AdditionalField> newAdditionalFields = [
            const AdditionalField(Constants.reAdministeredKey, true),
            AdditionalField(_reDoseQuantityKey, quantity.toString()),
          ];
          updatedResource = resource.additionalFields!.fields.isEmpty
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
        if (form.control(_deliveryCommentKey).value != null) {
          updatedResource = updatedResource.copyWith(
            deliveryComment: form.control(_deliveryCommentKey).value,
          );
        }
        updatedTaskResources.add(updatedResource);
      }
    }
    oldTask = oldTask.copyWith(
      resources: updatedTaskResources,
    );
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

  TaskModel getNewTask(
    BuildContext context,
    TaskModel? oldTask,
  ) {
    // Initialize task with oldTask if available, or create a new one
    var task = oldTask;
    var clientReferenceId = IdGen.i.identifier;

    // update the task with latest clientauditDetails and auditdetails

    task = oldTask!.copyWith(
      id: null,
      clientReferenceId: clientReferenceId,
      tenantId: envConfig.variables.tenantId,
      rowVersion: 1,
      auditDetails: AuditDetails(
        createdBy: context.loggedInUserUuid,
        createdTime: context.millisecondsSinceEpoch(),
      ),
      clientAuditDetails: ClientAuditDetails(
        createdBy: context.loggedInUserUuid,
        createdTime: context.millisecondsSinceEpoch(),
      ),
      // setting the status here as visited to separate this task from other successful task
      status: Status.visited.toValue(),
    );
    // update the task resources with latest clientauditDetails and auditdetails

    List<TaskResourceModel> newTaskResources = [];

    for (var resource in task.resources!) {
      newTaskResources.add(
        TaskResourceModel(
          taskclientReferenceId: clientReferenceId,
          clientReferenceId: IdGen.i.identifier,
          productVariantId: resource.productVariantId,
          isDelivered: true,
          taskId: task?.id,
          tenantId: envConfig.variables.tenantId,
          rowVersion: task?.rowVersion ?? 1,
          quantity: resource.quantity,
          additionalFields: resource.additionalFields,
          deliveryComment: resource.deliveryComment,
          clientAuditDetails: ClientAuditDetails(
            createdBy: context.loggedInUserUuid,
            createdTime: context.millisecondsSinceEpoch(),
          ),
          auditDetails: AuditDetails(
            createdBy: context.loggedInUserUuid,
            createdTime: context.millisecondsSinceEpoch(),
          ),
        ),
      );
    }

    task = task.copyWith(
      resources: newTaskResources,
    );

    return task;
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
        validators: [
          Validators.required,
        ],
      ),
      _doseAdministeredByKey: FormControl<String>(
        validators: [],
        value: context.loggedInUser.userName,
      ),
    });
  }
}
