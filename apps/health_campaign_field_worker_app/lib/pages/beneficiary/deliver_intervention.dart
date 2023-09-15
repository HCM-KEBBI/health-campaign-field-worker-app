import 'dart:math';

import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:digit_components/widgets/atoms/digit_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recase/recase.dart';

import '../../blocs/app_initialization/app_initialization.dart';
import '../../blocs/delivery_intervention/deliver_intervention.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/product_variant/product_variant.dart';
import '../../data/local_store/no_sql/schema/app_configuration.dart';
import '../../models/data_model.dart';
import '../../router/app_router.dart';
import '../../utils/environment_config.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/utils.dart';
import '../../widgets/component_wrapper/product_variant_bloc_wrapper.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';

class DeliverInterventionPage extends LocalizedStatefulWidget {
  final bool isEditing;

  const DeliverInterventionPage({
    super.key,
    super.appLocalizations,
    this.isEditing = false,
  });

  @override
  State<DeliverInterventionPage> createState() =>
      _DeliverInterventionPageState();
}

class _DeliverInterventionPageState
    extends LocalizedState<DeliverInterventionPage> {
  static const _resourceDeliveredKey = 'resourceDelivered';
  static const _quantityDistributedKey = 'quantityDistributed';
  static const _deliveryCommentKey = 'deliveryComment';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProductVariantBlocWrapper(
      child: BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
        builder: (context, state) {
          final householdMemberWrapper = state.householdMemberWrapper;

          final projectBeneficiary =
              context.beneficiaryType != BeneficiaryType.individual
                  ? [householdMemberWrapper.projectBeneficiaries.first]
                  : householdMemberWrapper.projectBeneficiaries
                      .where(
                        (element) =>
                            element.beneficiaryClientReferenceId ==
                            state.selectedIndividual?.clientReferenceId,
                      )
                      .toList();

          final taskData = state.householdMemberWrapper.tasks
              ?.where((element) =>
                  element.projectBeneficiaryClientReferenceId ==
                  projectBeneficiary.first.clientReferenceId)
              .toList();

          return Scaffold(
            body: state.loading
                ? const Center(child: CircularProgressIndicator())
                : ReactiveFormBuilder(
                    form: () => buildForm(context),
                    builder: (context, form, child) {
                      return ScrollableContent(
                        header: const BackNavigationHelpHeaderWidget(),
                        footer: SizedBox(
                          height: 100,
                          child: DigitCard(
                            child: DigitElevatedButton(
                              onPressed: () async {
                                form.markAllAsTouched();
                                if (!form.valid) return;
                                final router = context.router;
                                final clientReferenceId = taskData != null
                                    ? taskData.isEmpty
                                        ? IdGen.i.identifier
                                        : taskData.first.clientReferenceId
                                    : IdGen.i.identifier;
                                final TaskModel taskModel = TaskModel(
                                  id: taskData != null
                                      ? taskData.isEmpty
                                          ? null
                                          : taskData.first.id
                                      : null,
                                  clientReferenceId: clientReferenceId,
                                  projectBeneficiaryClientReferenceId:
                                      projectBeneficiary
                                          .first.clientReferenceId,
                                  tenantId: envConfig.variables.tenantId,
                                  rowVersion: taskData != null
                                      ? taskData.isEmpty
                                          ? 1
                                          : taskData.first.rowVersion
                                      : 1,
                                  projectId: context.projectId,
                                  status: Status.delivered.name,
                                  createdDate: context.millisecondsSinceEpoch(),
                                  resources: [
                                    TaskResourceModel(
                                      id: taskData != null
                                          ? taskData.isNotEmpty
                                              ? taskData
                                                  .first.resources?.first.id
                                              : null
                                          : null,
                                      taskId: taskData != null
                                          ? taskData.isNotEmpty
                                              ? taskData.first.id
                                              : null
                                          : null,
                                      clientReferenceId: clientReferenceId,
                                      rowVersion: taskData != null
                                          ? taskData.isEmpty
                                              ? 1
                                              : taskData.first.resources?.first
                                                  .rowVersion
                                          : 1,
                                      isDelivered: true,
                                      tenantId: envConfig.variables.tenantId,
                                      quantity: form
                                          .control(
                                            _quantityDistributedKey,
                                          )
                                          .value
                                          .toString(),
                                      productVariantId: (form
                                              .control(
                                                _resourceDeliveredKey,
                                              )
                                              .value as ProductVariantModel)
                                          .id,
                                      deliveryComment: form
                                          .control(
                                            _deliveryCommentKey,
                                          )
                                          .value,
                                      auditDetails: AuditDetails(
                                        createdBy: context.loggedInUserUuid,
                                        createdTime: taskData != null
                                            ? taskData.isNotEmpty
                                                ? taskData
                                                        .first
                                                        .resources
                                                        ?.first
                                                        .auditDetails
                                                        ?.createdTime ??
                                                    context
                                                        .millisecondsSinceEpoch()
                                                : context
                                                    .millisecondsSinceEpoch()
                                            : context.millisecondsSinceEpoch(),
                                        lastModifiedBy:
                                            context.loggedInUserUuid,
                                        lastModifiedTime:
                                            context.millisecondsSinceEpoch(),
                                      ),
                                    ),
                                  ],
                                  address: householdMemberWrapper
                                      .household.address
                                      ?.copyWith(
                                    relatedClientReferenceId: clientReferenceId,
                                    id: null,
                                  ),
                                  auditDetails: AuditDetails(
                                    createdBy: context.loggedInUserUuid,
                                    createdTime:
                                        context.millisecondsSinceEpoch(),
                                    lastModifiedBy: context.loggedInUserUuid,
                                    lastModifiedTime:
                                        context.millisecondsSinceEpoch(),
                                  ),
                                );
                                context.read<DeliverInterventionBloc>().add(
                                      DeliverInterventionSubmitEvent(
                                        taskModel,
                                        taskData == null
                                            ? false
                                            : taskData.isEmpty
                                                ? false
                                                : true,
                                        context.boundary,
                                      ),
                                    );

                                if (taskData == null || taskData.isEmpty) {
                                  DigitDialog.show<bool>(
                                    context,
                                    options: DigitDialogOptions(
                                      titleText: localizations.translate(
                                        i18.deliverIntervention
                                            .didYouObserveAdvEventsTitle,
                                      ),
                                      primaryAction: DigitDialogActions(
                                        label: localizations.translate(
                                          i18.common.coreCommonYes,
                                        ),
                                        action: (ctx) {
                                          router.popUntilRouteWithName(
                                            SearchBeneficiaryRoute.name,
                                          );
                                          router.push(AdverseEventsRoute(
                                            tasks: [taskModel],
                                          ));
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pop(true);
                                        },
                                      ),
                                      secondaryAction: DigitDialogActions(
                                        label: localizations.translate(
                                          i18.common.coreCommonNo,
                                        ),
                                        action: (context) {
                                          final parent =
                                              router.parent() as StackRouter;
                                          parent.popUntilRouteWithName(
                                            SearchBeneficiaryRoute.name,
                                          );
                                          router.push(
                                            AcknowledgementRoute(),
                                          );
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pop(false);
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  final parent = router.parent() as StackRouter;
                                  parent.popUntilRouteWithName(
                                    SearchBeneficiaryRoute.name,
                                  );
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
                          ),
                        ),
                        children: [
                          DigitCard(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        localizations.translate(
                                          i18.deliverIntervention
                                              .deliverInterventionLabel,
                                        ),
                                        style: theme.textTheme.displayMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                DigitTableCard(
                                  element: {
                                    localizations.translate(i18
                                        .deliverIntervention
                                        .dateOfRegistrationLabel): () {
                                      final date = projectBeneficiary
                                          .first.dateOfRegistration;

                                      final registrationDate =
                                          DateTime.fromMillisecondsSinceEpoch(
                                        date,
                                      );

                                      return DateFormat('dd MMMM yyyy')
                                          .format(registrationDate);
                                    }(),
                                  },
                                ),
                                DigitTableCard(
                                  color: Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1.0,
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 16,
                                  ),
                                  element: {
                                    localizations.translate(i18
                                            .householdOverView
                                            .householdOverViewHouseholdHeadLabel):
                                        householdMemberWrapper.headOfHousehold
                                                .name?.givenName ??
                                            '',
                                    localizations.translate(
                                      i18.deliverIntervention.idTypeText,
                                    ): () {
                                      final identifiers = householdMemberWrapper
                                          .headOfHousehold.identifiers;
                                      if (identifiers == null ||
                                          identifiers.isEmpty) {
                                        return '';
                                      }

                                      return identifiers.first.identifierType ??
                                          '';
                                    }(),
                                    localizations.translate(
                                      i18.deliverIntervention.idNumberText,
                                    ): () {
                                      final identifiers = householdMemberWrapper
                                          .headOfHousehold.identifiers;
                                      if (identifiers == null ||
                                          identifiers.isEmpty) {
                                        return '';
                                      }

                                      return identifiers.first.identifierId ??
                                          '';
                                    }(),
                                    localizations.translate(
                                      i18.common.coreCommonAge,
                                    ): () {
                                      final dob = householdMemberWrapper
                                          .headOfHousehold.dateOfBirth;
                                      if (dob == null || dob.isEmpty) {
                                        return '';
                                      }

                                      final int years =
                                          DigitDateUtils.calculateAge(
                                        DigitDateUtils
                                                .getFormattedDateToDateTime(
                                              dob,
                                            ) ??
                                            DateTime.now(),
                                      ).years;
                                      final int months =
                                          DigitDateUtils.calculateAge(
                                        DigitDateUtils
                                                .getFormattedDateToDateTime(
                                              dob,
                                            ) ??
                                            DateTime.now(),
                                      ).months;

                                      return "$years ${localizations.translate(i18.memberCard.deliverDetailsYearText)} $months ${localizations.translate(i18.memberCard.deliverDetailsMonthsText)}";
                                    }(),
                                    localizations.translate(
                                      i18.common.coreCommonGender,
                                    ): householdMemberWrapper.headOfHousehold
                                            .gender?.name.sentenceCase ??
                                        '',
                                    localizations.translate(
                                      i18.common.coreCommonMobileNumber,
                                    ): householdMemberWrapper
                                            .headOfHousehold.mobileNumber ??
                                        '',
                                  },
                                ),
                                DigitTableCard(
                                  element: {
                                    state.selectedIndividual != null
                                            ? localizations.translate(
                                                i18.deliverIntervention
                                                    .heightLabelText,
                                              )
                                            : '':
                                        state.selectedIndividual != null
                                            ? state
                                                .selectedIndividual
                                                ?.additionalFields
                                                ?.fields
                                                .first
                                                .value
                                            : '',
                                  },
                                ),
                                DigitTableCard(
                                  element: {
                                    localizations.translate(
                                      i18.deliverIntervention.memberCountText,
                                    ): householdMemberWrapper
                                            .household.memberCount ??
                                        householdMemberWrapper.members.length,
                                  },
                                ),
                                const DigitDivider(),
                                DigitTableCard(
                                  element: {
                                    localizations.translate(
                                      '${i18.deliverIntervention.noOfResourcesForDelivery}_${context.beneficiaryType}',
                                    ): () {
                                      final count = householdMemberWrapper
                                              .household.memberCount ??
                                          householdMemberWrapper.members.length;

                                      return min(count / 1.8, 3).round();
                                    }(),
                                  },
                                ),
                                const DigitDivider(),
                                BlocBuilder<ProductVariantBloc,
                                    ProductVariantState>(
                                  builder: (context, productState) {
                                    return productState.maybeWhen(
                                      orElse: () => const Offstage(),
                                      fetched: (productVariants) {
                                        final productVariantId = taskData
                                            ?.firstOrNull
                                            ?.resources
                                            ?.firstOrNull
                                            ?.productVariantId;

                                        final variant = productState.whenOrNull(
                                          fetched: (productVariants) {
                                            return productVariants
                                                .firstWhereOrNull(
                                              (element) =>
                                                  element.id ==
                                                  productVariantId,
                                            );
                                          },
                                        );

                                        form
                                            .control(_resourceDeliveredKey)
                                            .value = variant;

                                        return DigitReactiveDropdown<
                                            ProductVariantModel>(
                                          label: localizations.translate(
                                            i18.deliverIntervention
                                                .resourceDeliveredLabel,
                                          ),
                                          isRequired: true,
                                          valueMapper: (value) {
                                            return localizations.translate(
                                              value.sku ?? value.id,
                                            );
                                          },
                                          menuItems: productVariants,
                                          validationMessages: {
                                            'required': (object) =>
                                                localizations.translate(
                                                  i18.deliverIntervention
                                                      .resourceDeliveredError,
                                                ),
                                          },
                                          formControlName:
                                              _resourceDeliveredKey,
                                        );
                                      },
                                    );
                                  },
                                ),
                                DigitIntegerFormPicker(
                                  form: form,
                                  minimum: 0,
                                  formControlName: _quantityDistributedKey,
                                  label: localizations.translate(
                                    i18.deliverIntervention
                                        .quantityDistributedLabel,
                                  ),
                                  incrementer: true,
                                ),
                                BlocBuilder<AppInitializationBloc,
                                    AppInitializationState>(
                                  builder: (context, state) {
                                    if (state is! AppInitialized) {
                                      return const Offstage();
                                    }

                                    final deliveryCommentOptions = state
                                            .appConfiguration
                                            .deliveryCommentOptions ??
                                        <DeliveryCommentOptions>[];

                                    return DigitReactiveDropdown<String>(
                                      label: localizations.translate(
                                        i18.deliverIntervention
                                            .deliveryCommentLabel,
                                      ),
                                      valueMapper: (value) => value,
                                      initialValue: deliveryCommentOptions
                                          .firstOrNull?.name,
                                      menuItems:
                                          deliveryCommentOptions.map((e) {
                                        return localizations.translate(e.name);
                                      }).toList(),
                                      formControlName: _deliveryCommentKey,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  FormGroup buildForm(BuildContext context) {
    final state = context.read<HouseholdOverviewBloc>().state;

    final projectBeneficiary =
        context.beneficiaryType != BeneficiaryType.individual
            ? [state.householdMemberWrapper.projectBeneficiaries.first]
            : state.householdMemberWrapper.projectBeneficiaries
                .where(
                  (element) =>
                      element.beneficiaryClientReferenceId ==
                      state.selectedIndividual?.clientReferenceId,
                )
                .toList();
    final taskData = state.householdMemberWrapper.tasks
        ?.where((element) =>
            element.projectBeneficiaryClientReferenceId ==
            projectBeneficiary.first.clientReferenceId)
        .toList();

    return fb.group(<String, Object>{
      _resourceDeliveredKey: FormControl<ProductVariantModel>(
        validators: [Validators.required],
      ),
      _quantityDistributedKey: FormControl<int>(
        value: taskData?.firstOrNull?.resources?.firstOrNull?.quantity != null
            ? int.tryParse(taskData!.first.resources!.first.quantity!)
            : 1,
        validators: [Validators.required],
      ),
      _deliveryCommentKey: FormControl<String>(
        value: taskData?.firstOrNull?.resources?.firstOrNull?.deliveryComment,
      ),
    });
  }
}
