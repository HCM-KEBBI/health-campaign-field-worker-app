import 'package:auto_route/auto_route.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/selection_card.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/router/app_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:registration_delivery/registration_delivery.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import 'package:registration_delivery/utils/extensions/extensions.dart';

import '../../models/entities/status.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/widgets/back_navigation_help_header.dart';
import '../../widgets/localized.dart';
import 'package:registration_delivery/widgets/showcase/config/showcase_constants.dart';
import 'package:registration_delivery/widgets/showcase/showcase_button.dart';

@RoutePage()
class CustomRefusedDeliveryPage extends LocalizedStatefulWidget {
  const CustomRefusedDeliveryPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<CustomRefusedDeliveryPage> createState() =>
      CustomRefusedDeliveryPageState();
}

class CustomRefusedDeliveryPageState
    extends LocalizedState<CustomRefusedDeliveryPage> {
  static const _dataOfRefusalKey = 'dateOfAdministration';
  static const _reasonOfRefusal = 'reasonOfRefusal';

  @override
  void initState() {
    final registrationState = context.read<HouseholdOverviewBloc>().state;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<HouseholdOverviewBloc>();
    final router = context.router;

    return Scaffold(
      body: ReactiveFormBuilder(
          form: () => buildForm(),
          builder: (_, form, __) =>
              BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
                builder: (context, registrationState) {
                  return ScrollableContent(
                    enableFixedButton: true,
                    header: const Column(
                      children: [
                        BackNavigationHelpHeaderWidget(
                          showcaseButton: ShowcaseButton(),
                          showHelp: false,
                        ),
                      ],
                    ),
                    footer: DigitCard(
                      margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                      padding:
                          const EdgeInsets.fromLTRB(kPadding, 0, kPadding, 0),
                      child: DigitElevatedButton(
                        onPressed: () {
                          form.markAllAsTouched();

                          if (form.control(_reasonOfRefusal).value == null) {
                            setState(() {
                              form
                                  .control(_reasonOfRefusal)
                                  .setErrors({'': true});
                            });
                          }

                          if (!form.valid) return;

                          final reasonOfRefusal =
                              form.control(_reasonOfRefusal).value;

                          final projectBeneficiary = [
                            registrationState.householdMemberWrapper
                                .projectBeneficiaries?.first
                          ];

                          context.read<DeliverInterventionBloc>().add(
                                DeliverInterventionSubmitEvent(
                                  task: TaskModel(
                                    projectBeneficiaryClientReferenceId:
                                        projectBeneficiary?.first
                                            ?.clientReferenceId, //TODO: need to check for individual based campaign
                                    clientReferenceId: IdGen.i.identifier,
                                    tenantId: RegistrationDeliverySingleton()
                                        .tenantId,
                                    rowVersion: 1,
                                    auditDetails: AuditDetails(
                                      createdBy: RegistrationDeliverySingleton()
                                          .loggedInUserUuid!,
                                      createdTime:
                                          context.millisecondsSinceEpoch(),
                                    ),
                                    projectId: RegistrationDeliverySingleton()
                                        .projectId,
                                    status: Status.administeredFailed.toValue(),
                                    clientAuditDetails: ClientAuditDetails(
                                      createdBy: RegistrationDeliverySingleton()
                                          .loggedInUserUuid!,
                                      createdTime:
                                          context.millisecondsSinceEpoch(),
                                      lastModifiedBy:
                                          RegistrationDeliverySingleton()
                                              .loggedInUserUuid,
                                      lastModifiedTime:
                                          context.millisecondsSinceEpoch(),
                                    ),
                                    additionalFields: TaskAdditionalFields(
                                      version: 1,
                                      fields: [
                                        AdditionalField(
                                          'taskStatus',
                                          reasonOfRefusal,
                                        ),
                                      ],
                                    ),
                                  ),
                                  isEditing: false,
                                  boundaryModel:
                                      RegistrationDeliverySingleton().boundary!,
                                ),
                              );
                          context.router
                              .popAndPush(CustomHouseholdAcknowledgementRoute(
                            enableViewHousehold: true,
                          ));
                        },
                        child: Center(
                          child: Text(
                            localizations.translate(
                              i18.householdLocation.actionLabel,
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0, 0, 0, kPadding),
                                child: Text(
                                  localizations.translate(
                                    i18.deliverIntervention
                                        .refusedDeliveryLabel,
                                  ),
                                  style: theme.textTheme.displayMedium,
                                ),
                              ),
                              Column(children: [
                                refusedDeliveryShowcaseData.dateOfVisit
                                    .buildWith(
                                  child: DigitDateFormPicker(
                                    isEnabled: false,
                                    formControlName: _dataOfRefusalKey,
                                    label: localizations.translate(
                                      i18.deliverIntervention
                                          .refusedDeliveryVisitDateLabel,
                                    ),
                                    confirmText: localizations.translate(
                                      i18.common.coreCommonOk,
                                    ),
                                    cancelText: localizations.translate(
                                      i18.common.coreCommonCancel,
                                    ),
                                    isRequired: false,
                                    padding: const EdgeInsets.only(
                                      top: kPadding,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: kPadding,
                                ),
                                refusedDeliveryShowcaseData.reasonOfRefusal
                                    .buildWith(
                                  child: LabeledField(
                                    label: localizations.translate(
                                      i18.deliverIntervention
                                          .reasonForRefusalLabel,
                                    ),
                                    isRequired: true,
                                    child: SelectionBox<String>(
                                      width: 122,
                                      allowMultipleSelection: false,
                                      options: RegistrationDeliverySingleton()
                                              .refusalReasons ??
                                          [],
                                      onSelectionChanged: (value) {
                                        form
                                            .control(_reasonOfRefusal)
                                            .markAsTouched();
                                        setState(() {
                                          if (value.isNotEmpty) {
                                            form
                                                .control(_reasonOfRefusal)
                                                .value = value.first;
                                          } else {
                                            form
                                                .control(_reasonOfRefusal)
                                                .value = null;
                                            setState(() {
                                              form
                                                  .control(_reasonOfRefusal)
                                                  .setErrors({'': true});
                                            });
                                          }
                                        });
                                      },
                                      valueMapper: (value) {
                                        return localizations
                                            .translate(value.toString());
                                      },
                                      errorMessage: form
                                                  .control(_reasonOfRefusal)
                                                  .hasErrors &&
                                              form
                                                  .control(_reasonOfRefusal)
                                                  .touched
                                          ? localizations.translate(
                                              i18.common.corecommonRequired)
                                          : null,
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )),
    );
  }

  FormGroup buildForm() {
    return fb.group(<String, Object>{
      _dataOfRefusalKey:
          FormControl<DateTime>(value: DateTime.now(), validators: []),
      _reasonOfRefusal:
          FormControl<String>(value: null, validators: [Validators.required]),
    });
  }
}