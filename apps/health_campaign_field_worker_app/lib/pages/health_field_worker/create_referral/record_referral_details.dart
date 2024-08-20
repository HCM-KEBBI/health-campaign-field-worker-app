import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_radio_button_list.dart';
import 'package:digit_components/widgets/atoms/digit_reactive_search_dropdown.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../blocs/app_initialization/app_initialization.dart';
import '../../../blocs/hf_referrals/record_referral.dart';
import '../../../blocs/service/service.dart';
import '../../../blocs/service_definition/service_definition.dart';
import '../../../data/local_store/no_sql/schema/app_configuration.dart';
import '../../../models/data_model.dart';
import '../../../router/app_router.dart';
import '../../../utils/environment_config.dart';
import '../../../utils/i18_key_constants.dart' as i18;
import '../../../utils/utils.dart';
import '../../../widgets/header/back_navigation_help_header.dart';
import '../../../widgets/localized.dart';

class RecordReferralDetailsPage extends LocalizedStatefulWidget {
  final bool isEditing;

  const RecordReferralDetailsPage({
    super.key,
    super.appLocalizations,
    this.isEditing = false,
  });

  @override
  State<RecordReferralDetailsPage> createState() =>
      _RecordReferralDetailsPageState();
}

class _RecordReferralDetailsPageState
    extends LocalizedState<RecordReferralDetailsPage> {
  static const _nameOfChildKey = 'nameOfChild';
  static const _evaluationFacilityKey = 'evaluationFacility';
  static const _referralReason = 'referralReason';
  static const _cycleKey = 'cycle';
  static const _referredByKey = 'referredBy';
  static const _referralCodeKey = 'referralCode';
  final clickedStatus = ValueNotifier<bool>(false);

  @override
  void dispose() {
    clickedStatus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final router = context.router;

    return BlocBuilder<ServiceDefinitionBloc, ServiceDefinitionState>(
      builder: (context, state) {
        return state.map(
          empty: (value) => const Text('No Checklist'),
          isloading: (value) => const Center(
            child: CircularProgressIndicator(),
          ),
          serviceDefinitionFetch: (ServiceDefinitionServiceFetchedState value) {
            return Scaffold(
              body: BlocBuilder<RecordHFReferralBloc, RecordHFReferralState>(
                builder: (context, recordState) {
                  final bool viewOnly = recordState.mapOrNull(
                        create: (value) => value.viewOnly,
                      ) ??
                      false;

                  return ReactiveFormBuilder(
                    form: () => buildForm(recordState),
                    builder: (context, form, child) => ScrollableContent(
                      enableFixedButton: true,
                      header: const Column(children: [
                        BackNavigationHelpHeaderWidget(),
                      ]),
                      footer: BlocBuilder<ServiceBloc, ServiceState>(
                        builder: (context, serviceState) {
                          return serviceState.maybeWhen(
                            orElse: () => DigitCard(
                              margin:
                                  const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                              padding: const EdgeInsets.fromLTRB(
                                  kPadding, 0, kPadding, 0),
                              child: ValueListenableBuilder(
                                valueListenable: clickedStatus,
                                builder: (context, bool isClicked, _) {
                                  return DigitElevatedButton(
                                    onPressed: isClicked
                                        ? null
                                        : () {
                                            if (form.control(_cycleKey).value ==
                                                null) {
                                              clickedStatus.value = false;
                                              form
                                                  .control(_cycleKey)
                                                  .setErrors({'': true});
                                            } else if (form
                                                    .control(_referralReason)
                                                    .value ==
                                                null) {
                                              clickedStatus.value = false;
                                              form
                                                  .control(_referralReason)
                                                  .setErrors({'': true});
                                            }
                                            form.markAllAsTouched();

                                            if (viewOnly) {
                                              final symptom = form
                                                  .control(_referralReason)
                                                  .value as KeyValue;
                                              context
                                                  .read<ServiceDefinitionBloc>()
                                                  .add(
                                                    ServiceDefinitionSelectionEvent(
                                                      serviceDefinition: value
                                                          .serviceDefinitionList
                                                          .where((e) =>
                                                              e.code!.contains(
                                                                symptom.key,
                                                              ))
                                                          .first,
                                                    ),
                                                  );
                                              context.read<ServiceBloc>().add(
                                                    ServiceSearchEvent(
                                                      serviceSearchModel:
                                                          ServiceSearchModel(
                                                        clientId: recordState
                                                            .mapOrNull(
                                                          create: (value) => value
                                                                  .viewOnly
                                                              ? value
                                                                  .hfReferralModel
                                                                  ?.clientReferenceId
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                              context.router.push(
                                                ReferralReasonCheckListPreviewRoute(),
                                              );
                                            } else if (!form.valid) {
                                              return;
                                            } else if (value
                                                .serviceDefinitionList
                                                .isEmpty) {
                                              DigitToast.show(
                                                context,
                                                options: DigitToastOptions(
                                                  i18.referBeneficiary
                                                      .noChecklistFound,
                                                  true,
                                                  DigitTheme
                                                      .instance.mobileTheme,
                                                ),
                                              );
                                            } else {
                                              final hfState = BlocProvider.of<
                                                  RecordHFReferralBloc>(
                                                context,
                                              ).state;
                                              clickedStatus.value = true;
                                              final cycle =
                                                  form.control(_cycleKey).value;
                                              final nameOfChild = form
                                                  .control(_nameOfChildKey)
                                                  .value as String;
                                              final referralCode = form
                                                  .control(_referralCodeKey)
                                                  .value as String?;
                                              final symptom = form
                                                  .control(_referralReason)
                                                  .value as KeyValue;
                                              final hfCoordinator =
                                                  hfState.mapOrNull(
                                                create: (val) =>
                                                    val.healthFacilityCord,
                                              );
                                              final referredBy =
                                                  hfState.mapOrNull(
                                                create: (val) => val.referredBy,
                                              );
                                              final dateOfEvaluation = hfState
                                                  .mapOrNull(
                                                    create: (val) =>
                                                        val.dateOfEvaluation,
                                                  )
                                                  ?.millisecondsSinceEpoch;
                                              final facilityId =
                                                  hfState.mapOrNull(
                                                create: (val) => val.facilityId,
                                              );
                                              final hfClientRefId =
                                                  IdGen.i.identifier;

                                              final event = context
                                                  .read<RecordHFReferralBloc>();
                                              event.add(
                                                RecordHFReferralCreateEntryEvent(
                                                  hfReferralModel:
                                                      HFReferralModel(
                                                    clientReferenceId:
                                                        hfClientRefId,
                                                    projectFacilityId:
                                                        facilityId,
                                                    projectId:
                                                        context.projectId,
                                                    name: nameOfChild.trim(),
                                                    referralCode: referralCode,
                                                    symptom: symptom.key,
                                                    tenantId: envConfig
                                                        .variables.tenantId,
                                                    rowVersion: 1,
                                                    auditDetails: AuditDetails(
                                                      createdBy: context
                                                          .loggedInUserUuid,
                                                      createdTime: context
                                                          .millisecondsSinceEpoch(),
                                                      lastModifiedBy: context
                                                          .loggedInUserUuid,
                                                      lastModifiedTime: context
                                                          .millisecondsSinceEpoch(),
                                                    ),
                                                    clientAuditDetails:
                                                        ClientAuditDetails(
                                                      createdBy: context
                                                          .loggedInUserUuid,
                                                      createdTime: context
                                                          .millisecondsSinceEpoch(),
                                                      lastModifiedBy: context
                                                          .loggedInUserUuid,
                                                      lastModifiedTime: context
                                                          .millisecondsSinceEpoch(),
                                                    ),
                                                    additionalFields:
                                                        HFReferralAdditionalFields(
                                                      version: 1,
                                                      fields: [
                                                        if (hfCoordinator !=
                                                                null &&
                                                            hfCoordinator
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                          AdditionalField(
                                                            AdditionalFieldsType
                                                                .hFCoordinator
                                                                .toValue(),
                                                            hfCoordinator,
                                                          ),
                                                        if (referredBy !=
                                                                null &&
                                                            referredBy
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                          AdditionalField(
                                                            AdditionalFieldsType
                                                                .referredBy
                                                                .toValue(),
                                                            referredBy,
                                                          ),
                                                        if (dateOfEvaluation !=
                                                                null &&
                                                            dateOfEvaluation
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                          AdditionalField(
                                                            AdditionalFieldsType
                                                                .dateOfEvaluation
                                                                .toValue(),
                                                            dateOfEvaluation,
                                                          ),
                                                        if (nameOfChild !=
                                                                null &&
                                                            nameOfChild
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                          AdditionalField(
                                                            AdditionalFieldsType
                                                                .nameOfReferral
                                                                .toValue(),
                                                            nameOfChild,
                                                          ),
                                                        if (cycle != null &&
                                                            cycle
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                          AdditionalField(
                                                            AdditionalFieldsType
                                                                .cycle
                                                                .toValue(),
                                                            cycle,
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                              context
                                                  .read<ServiceDefinitionBloc>()
                                                  .add(
                                                    ServiceDefinitionSelectionEvent(
                                                      serviceDefinition: value
                                                          .serviceDefinitionList
                                                          .where((e) =>
                                                              e.code!.contains(
                                                                symptom.key,
                                                              ))
                                                          .first,
                                                    ),
                                                  );
                                              final parent = context.router
                                                  .parent() as StackRouter;
                                              parent.push(
                                                ReferralReasonChecklistRoute(
                                                  referralClientRefId:
                                                      hfClientRefId,
                                                ),
                                              );
                                            }
                                          },
                                    child: Center(
                                      child: Text(
                                        localizations.translate(recordState
                                                .mapOrNull(
                                              create: (value) => value.viewOnly
                                                  ? i18.common.coreCommonNext
                                                  : i18.common.coreCommonSubmit,
                                            ) ??
                                            i18.common.coreCommonSubmit),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            serviceSearch: (value1, value2, value3) {
                              return DigitCard(
                                margin: const EdgeInsets.fromLTRB(
                                    0, kPadding, 0, 0),
                                padding: const EdgeInsets.fromLTRB(
                                    kPadding, 0, kPadding, 0),
                                child: ValueListenableBuilder(
                                  valueListenable: clickedStatus,
                                  builder: (context, bool isClicked, _) {
                                    return DigitElevatedButton(
                                      onPressed: isClicked
                                          ? null
                                          : () {
                                              if (form
                                                      .control(_cycleKey)
                                                      .value ==
                                                  null) {
                                                clickedStatus.value = false;
                                                form
                                                    .control(_cycleKey)
                                                    .setErrors({'': true});
                                              } else if (form
                                                      .control(_referralReason)
                                                      .value ==
                                                  null) {
                                                clickedStatus.value = false;
                                                form
                                                    .control(_referralReason)
                                                    .setErrors({'': true});
                                              }
                                              form.markAllAsTouched();

                                              if (viewOnly) {
                                                final symptom = form
                                                    .control(_referralReason)
                                                    .value as KeyValue;
                                                if (value1.isNotEmpty) {
                                                  context
                                                      .read<
                                                          ServiceDefinitionBloc>()
                                                      .add(
                                                        ServiceDefinitionSelectionEvent(
                                                          serviceDefinition: value
                                                              .serviceDefinitionList
                                                              .where((e) => e
                                                                  .code!
                                                                  .contains(
                                                                      symptom
                                                                          .key))
                                                              .first,
                                                        ),
                                                      );
                                                  context
                                                      .read<ServiceBloc>()
                                                      .add(
                                                        ServiceSearchEvent(
                                                          serviceSearchModel:
                                                              ServiceSearchModel(
                                                            clientId:
                                                                recordState
                                                                    .mapOrNull(
                                                              create: (value) => value
                                                                      .viewOnly
                                                                  ? value
                                                                      .hfReferralModel
                                                                      ?.clientReferenceId
                                                                  : null,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                  context.router.push(
                                                    ReferralReasonCheckListPreviewRoute(),
                                                  );
                                                } else {
                                                  final hfClientRefId =
                                                      recordState.mapOrNull(
                                                    create: (value) => value
                                                        .hfReferralModel
                                                        ?.clientReferenceId,
                                                  );
                                                  context
                                                      .read<
                                                          ServiceDefinitionBloc>()
                                                      .add(
                                                        ServiceDefinitionSelectionEvent(
                                                          serviceDefinition: value
                                                              .serviceDefinitionList
                                                              .where((e) => e
                                                                  .code!
                                                                  .contains(
                                                                      symptom
                                                                          .key))
                                                              .first,
                                                        ),
                                                      );
                                                  final parent = context.router
                                                      .parent() as StackRouter;
                                                  parent.push(
                                                    ReferralReasonChecklistRoute(
                                                      referralClientRefId:
                                                          hfClientRefId,
                                                    ),
                                                  );
                                                }
                                              } else if (!form.valid) {
                                                return;
                                              } else if (value
                                                  .serviceDefinitionList
                                                  .isEmpty) {
                                                DigitToast.show(
                                                  context,
                                                  options: DigitToastOptions(
                                                    i18.referBeneficiary
                                                        .noChecklistFound,
                                                    true,
                                                    DigitTheme
                                                        .instance.mobileTheme,
                                                  ),
                                                );
                                              } else {
                                                final hfState = BlocProvider.of<
                                                    RecordHFReferralBloc>(
                                                  context,
                                                ).state;
                                                clickedStatus.value = true;
                                                final cycle = form
                                                    .control(_cycleKey)
                                                    .value;
                                                final nameOfChild = form
                                                    .control(_nameOfChildKey)
                                                    .value as String;
                                                final referralCode = form
                                                    .control(_referralCodeKey)
                                                    .value as String?;
                                                final symptom = form
                                                    .control(_referralReason)
                                                    .value as KeyValue;
                                                final hfCoordinator =
                                                    hfState.mapOrNull(
                                                  create: (val) =>
                                                      val.healthFacilityCord,
                                                );
                                                final referredBy =
                                                    hfState.mapOrNull(
                                                  create: (val) =>
                                                      val.referredBy,
                                                );
                                                final dateOfEvaluation = hfState
                                                    .mapOrNull(
                                                      create: (val) =>
                                                          val.dateOfEvaluation,
                                                    )
                                                    ?.millisecondsSinceEpoch;
                                                final facilityId =
                                                    hfState.mapOrNull(
                                                  create: (val) =>
                                                      val.facilityId,
                                                );
                                                final hfClientRefId =
                                                    IdGen.i.identifier;

                                                final event = context.read<
                                                    RecordHFReferralBloc>();
                                                event.add(
                                                  RecordHFReferralCreateEntryEvent(
                                                    hfReferralModel:
                                                        HFReferralModel(
                                                      clientReferenceId:
                                                          hfClientRefId,
                                                      projectFacilityId:
                                                          facilityId,
                                                      projectId:
                                                          context.projectId,
                                                      name: nameOfChild.trim(),
                                                      referralCode:
                                                          referralCode,
                                                      symptom: symptom.key,
                                                      tenantId: envConfig
                                                          .variables.tenantId,
                                                      rowVersion: 1,
                                                      auditDetails:
                                                          AuditDetails(
                                                        createdBy: context
                                                            .loggedInUserUuid,
                                                        createdTime: context
                                                            .millisecondsSinceEpoch(),
                                                        lastModifiedBy: context
                                                            .loggedInUserUuid,
                                                        lastModifiedTime: context
                                                            .millisecondsSinceEpoch(),
                                                      ),
                                                      clientAuditDetails:
                                                          ClientAuditDetails(
                                                        createdBy: context
                                                            .loggedInUserUuid,
                                                        createdTime: context
                                                            .millisecondsSinceEpoch(),
                                                        lastModifiedBy: context
                                                            .loggedInUserUuid,
                                                        lastModifiedTime: context
                                                            .millisecondsSinceEpoch(),
                                                      ),
                                                      additionalFields:
                                                          HFReferralAdditionalFields(
                                                        version: 1,
                                                        fields: [
                                                          if (hfCoordinator !=
                                                                  null &&
                                                              hfCoordinator
                                                                  .toString()
                                                                  .trim()
                                                                  .isNotEmpty)
                                                            AdditionalField(
                                                              AdditionalFieldsType
                                                                  .hFCoordinator
                                                                  .toValue(),
                                                              hfCoordinator,
                                                            ),
                                                          if (referredBy !=
                                                                  null &&
                                                              referredBy
                                                                  .toString()
                                                                  .trim()
                                                                  .isNotEmpty)
                                                            AdditionalField(
                                                              AdditionalFieldsType
                                                                  .referredBy
                                                                  .toValue(),
                                                              referredBy,
                                                            ),
                                                          if (dateOfEvaluation !=
                                                                  null &&
                                                              dateOfEvaluation
                                                                  .toString()
                                                                  .trim()
                                                                  .isNotEmpty)
                                                            AdditionalField(
                                                              AdditionalFieldsType
                                                                  .dateOfEvaluation
                                                                  .toValue(),
                                                              dateOfEvaluation,
                                                            ),
                                                          if (nameOfChild !=
                                                                  null &&
                                                              nameOfChild
                                                                  .toString()
                                                                  .trim()
                                                                  .isNotEmpty)
                                                            AdditionalField(
                                                              AdditionalFieldsType
                                                                  .nameOfReferral
                                                                  .toValue(),
                                                              nameOfChild,
                                                            ),
                                                          if (cycle != null &&
                                                              cycle
                                                                  .toString()
                                                                  .trim()
                                                                  .isNotEmpty)
                                                            AdditionalField(
                                                              AdditionalFieldsType
                                                                  .cycle
                                                                  .toValue(),
                                                              cycle,
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                                context
                                                    .read<
                                                        ServiceDefinitionBloc>()
                                                    .add(
                                                      ServiceDefinitionSelectionEvent(
                                                        serviceDefinition: value
                                                            .serviceDefinitionList
                                                            .where((e) => e
                                                                    .code!
                                                                    .contains(
                                                                  symptom.key,
                                                                ))
                                                            .first,
                                                      ),
                                                    );
                                                final parent = context.router
                                                    .parent() as StackRouter;
                                                parent.push(
                                                  ReferralReasonChecklistRoute(
                                                    referralClientRefId:
                                                        hfClientRefId,
                                                  ),
                                                );
                                              }
                                            },
                                      child: Center(
                                        child: Text(
                                          localizations
                                              .translate(recordState.mapOrNull(
                                                    create: (value) => value
                                                            .viewOnly
                                                        ? i18.common
                                                            .coreCommonNext
                                                        : i18.common
                                                            .coreCommonSubmit,
                                                  ) ??
                                                  i18.common.coreCommonSubmit),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
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
                                              i18.referBeneficiary
                                                  .referralDetails,
                                            ),
                                            style:
                                                theme.textTheme.displayMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(children: [
                                      DigitReactiveSearchDropdown<String>(
                                        label: localizations.translate(
                                          i18.referBeneficiary.selectCycle,
                                        ),
                                        form: form,
                                        isRequired: true,
                                        enabled: !viewOnly,
                                        menuItems: context.cycles,
                                        formControlName: _cycleKey,
                                        valueMapper: (value) {
                                          return '${localizations.translate(i18.deliverIntervention.cycle)} $value';
                                        },
                                        validationMessage:
                                            localizations.translate(
                                          i18.common.corecommonRequired,
                                        ),
                                        emptyText: localizations
                                            .translate(i18.common.noMatchFound),
                                      ),
                                      DigitTextFormField(
                                        formControlName: _nameOfChildKey,
                                        label: localizations.translate(
                                          i18.referBeneficiary
                                              .nameOfTheChildLabel,
                                        ),
                                        readOnly: viewOnly,
                                        isRequired: true,
                                        validationMessages: {
                                          'required': (_) =>
                                              localizations.translate(
                                                i18.common.corecommonRequired,
                                              ),
                                        },
                                      ),
                                      DigitTextFormField(
                                        formControlName: _referralCodeKey,
                                        label: localizations.translate(
                                          i18.referBeneficiary
                                              .referralCodeLabel,
                                        ),
                                        isRequired: true,
                                        readOnly: viewOnly,
                                        validationMessages: {
                                          'required': (_) =>
                                              localizations.translate(
                                                i18.common.corecommonRequired,
                                              ),
                                        },
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                              DigitCard(
                                child: BlocBuilder<AppInitializationBloc,
                                    AppInitializationState>(
                                  builder: (context, state) {
                                    return state.maybeWhen(
                                      orElse: () => const Offstage(),
                                      initialized: (appConfiguration, _) {
                                        final List<KeyValue> reasons =
                                            (appConfiguration.referralReasons ??
                                                    [])
                                                .map(
                                                  (e) =>
                                                      KeyValue(e.code, e.code),
                                                )
                                                .toList();
                                        form.control(_referralReason).value =
                                            recordState.mapOrNull(
                                          create: (value) => value.viewOnly
                                              ? reasons
                                                  .where((e) =>
                                                      e.label ==
                                                      value.hfReferralModel
                                                          ?.symptom)
                                                  .first
                                              : null,
                                        );

                                        return DigitRadioButtonList<KeyValue>(
                                          labelStyle:
                                              theme.textTheme.displayMedium,
                                          isEnabled: !viewOnly,
                                          formControlName: _referralReason,
                                          valueMapper: (val) => localizations
                                              .translate(val.label),
                                          options: reasons,
                                          labelText: localizations.translate(
                                            i18.referBeneficiary
                                                .reasonForReferralHeader,
                                          ),
                                          isRequired: true,
                                          errorMessage: localizations.translate(
                                            i18.common.corecommonRequired,
                                          ),
                                          onValueChange: (val) {
                                            form
                                                .control(_referralReason)
                                                .value = val;
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  FormGroup buildForm(RecordHFReferralState referralState) {
    return fb.group(<String, Object>{
      _cycleKey: FormControl<String>(
        value: referralState.mapOrNull(
          create: (value) => value.viewOnly
              ? value.hfReferralModel?.additionalFields?.fields
                  .where((e) => e.key == AdditionalFieldsType.cycle.toValue())
                  .first
                  .value
              : null,
        ),
        disabled: referralState.mapOrNull(
              create: (value) => value.viewOnly,
            ) ??
            false,
      ),
      _nameOfChildKey: FormControl<String>(
        value: referralState.mapOrNull(
          create: (value) => value.viewOnly
              ? value.hfReferralModel?.additionalFields?.fields
                  .where((e) =>
                      e.key == AdditionalFieldsType.nameOfReferral.toValue())
                  .first
                  .value
              : value.hfReferralModel?.name ?? '',
        ),
        disabled: referralState.mapOrNull(
              create: (value) => value.viewOnly,
            ) ??
            false,
        validators: [
          Validators.required,
        ],
      ),
      _referralCodeKey: FormControl<String>(
        value: referralState.mapOrNull(
          create: (value) =>
              value.viewOnly ? value.hfReferralModel?.referralCode : null,
        ),
        disabled: referralState.mapOrNull(
              create: (value) => value.viewOnly,
            ) ??
            false,
        validators: [
          Validators.required,
        ],
      ),
      _referralReason: FormControl<KeyValue>(
        value: referralState.mapOrNull(
          create: (value) =>
              value.viewOnly && value.hfReferralModel?.symptom != null
                  ? KeyValue(
                      value.hfReferralModel!.symptom.toString(),
                      value.hfReferralModel?.symptom,
                    )
                  : null,
        ),
        disabled: referralState.mapOrNull(
              create: (value) => value.viewOnly,
            ) ??
            false,
        // validators: [
        //   Validators.required,
        // ],
      ),
    });
  }
}