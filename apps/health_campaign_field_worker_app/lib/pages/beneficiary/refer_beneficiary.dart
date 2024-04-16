import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_radio_button_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../blocs/app_initialization/app_initialization.dart';
import '../../blocs/delivery_intervention/deliver_intervention.dart';
import '../../blocs/facility/facility.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/referral_management/referral_management.dart';
import '../../models/data_model.dart';
import '../../router/app_router.dart';
import '../../utils/environment_config.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/utils.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/inventory/no_facilities_assigned_dialog.dart';
import '../../widgets/localized.dart';
import '../inventory/facility_selection.dart';

class ReferBeneficiaryPage extends LocalizedStatefulWidget {
  final bool isEditing;
  final String projectBeneficiaryClientRefId;
  final IndividualModel individual;
  final bool isReadministrationUnSuccessful;
  final String quantityWasted;
  final String? productVariantId;

  const ReferBeneficiaryPage({
    super.key,
    super.appLocalizations,
    this.isEditing = false,
    required this.projectBeneficiaryClientRefId,
    required this.individual,
    this.isReadministrationUnSuccessful = false,
    this.quantityWasted = "00",
    this.productVariantId,
  });
  @override
  State<ReferBeneficiaryPage> createState() => _ReferBeneficiaryPageState();
}

class _ReferBeneficiaryPageState extends LocalizedState<ReferBeneficiaryPage> {
  static const _dateOfReferralKey = 'dateOfReferral';
  static const _administrativeUnitKey = 'administrativeUnit';
  static const _referredByKey = 'referredBy';
  static const _referredToKey = 'referredTo';
  static const _referralReason = 'referralReason';
  static const _referralCode = 'referralCode';
  static const _referralComments = 'referralComments';
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

    return BlocConsumer<FacilityBloc, FacilityState>(
      listener: (context, state) {
        state.whenOrNull(
          empty: () => NoFacilitiesAssignedDialog.show(context),
        );
      },
      builder: (ctx, facilityState) {
        final facilities = facilityState.whenOrNull(
              fetched: (_, facilities, __) {
                final projectFacilities = facilities
                    .where((e) =>
                        e.id != 'NA' &&
                        e.id != 'DT' &&
                        (context.loggedInUser.permanentCity == null ||
                            e.name == context.loggedInUser.permanentCity))
                    .toList();
                final healthFacilities = [
                  FacilityModel(
                    id: 'APS',
                    name: 'APS',
                  ),
                ];
                healthFacilities.addAll(projectFacilities);

                return healthFacilities;
              },
            ) ??
            [];

        return WillPopScope(
          onWillPop: () =>
              _onBackPressed(context, widget.isReadministrationUnSuccessful),
          child: Scaffold(
            body: Scaffold(
              body: ReactiveFormBuilder(
                form: buildForm,
                builder: (context, form, child) => ScrollableContent(
                  enableFixedButton: true,
                  header: Column(children: [
                    widget.isReadministrationUnSuccessful
                        ? const BackNavigationHelpHeaderWidget(
                            showBackNavigation: false,
                          )
                        : const BackNavigationHelpHeaderWidget(),
                  ]),
                  footer: DigitCard(
                    margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                    padding:
                        const EdgeInsets.fromLTRB(kPadding, 0, kPadding, 0),
                    child: ValueListenableBuilder(
                      valueListenable: clickedStatus,
                      builder: (context, bool isClicked, _) {
                        return DigitElevatedButton(
                          onPressed: isClicked
                              ? null
                              : () {
                                  if (form.control(_referralReason).value ==
                                      null) {
                                    clickedStatus.value = false;
                                    form
                                        .control(_referralReason)
                                        .setErrors({'': true});
                                  }
                                  form.markAllAsTouched();

                                  if (!form.valid) {
                                    return;
                                  } else {
                                    clickedStatus.value = true;
                                    final recipient = form
                                        .control(_referredToKey)
                                        .value as FacilityModel;
                                    final reason = form
                                        .control(_referralReason)
                                        .value as KeyValue;
                                    final recipientType = recipient.id == 'APS'
                                        ? 'STAFF'
                                        : 'FACILITY';
                                    final recipientId = recipient.id == 'APS'
                                        ? context.loggedInUserUuid
                                        : recipient.id;
                                    final referralComment =
                                        form.control(_referralComments).value;

                                    final referralCode =
                                        form.control(_referralCode).value;

                                    final event = context.read<ReferralBloc>();
                                    event.add(ReferralSubmitEvent(
                                      ReferralModel(
                                        clientReferenceId: IdGen.i.identifier,
                                        projectId: context.projectId,
                                        projectBeneficiaryClientReferenceId:
                                            widget
                                                .projectBeneficiaryClientRefId,
                                        referrerId: context.loggedInUserUuid,
                                        recipientId: recipientId,
                                        recipientType: recipientType,
                                        reasons: [reason.key],
                                        tenantId: envConfig.variables.tenantId,
                                        rowVersion: 1,
                                        auditDetails: AuditDetails(
                                          createdBy: context.loggedInUserUuid,
                                          createdTime:
                                              context.millisecondsSinceEpoch(),
                                          lastModifiedBy:
                                              context.loggedInUserUuid,
                                          lastModifiedTime:
                                              context.millisecondsSinceEpoch(),
                                        ),
                                        clientAuditDetails: ClientAuditDetails(
                                          createdBy: context.loggedInUserUuid,
                                          createdTime:
                                              context.millisecondsSinceEpoch(),
                                          lastModifiedBy:
                                              context.loggedInUserUuid,
                                          lastModifiedTime:
                                              context.millisecondsSinceEpoch(),
                                        ),
                                        additionalFields:
                                            ReferralAdditionalFields(
                                          version: 1,
                                          fields: [
                                            if (referralComment != null &&
                                                referralComment
                                                    .toString()
                                                    .trim()
                                                    .isNotEmpty)
                                              AdditionalField(
                                                AdditionalFieldsType
                                                    .referralComments
                                                    .toValue(),
                                                referralComment,
                                              ),
                                            if (referralCode != null &&
                                                referralCode
                                                    .toString()
                                                    .trim()
                                                    .isNotEmpty)
                                              AdditionalField(
                                                _referralCode,
                                                referralCode,
                                              ),
                                          ],
                                        ),
                                      ),
                                      false,
                                    ));

                                    final clientReferenceId =
                                        IdGen.i.identifier;
                                    context.read<DeliverInterventionBloc>().add(
                                          DeliverInterventionSubmitEvent(
                                            [
                                              TaskModel(
                                                projectBeneficiaryClientReferenceId:
                                                    widget
                                                        .projectBeneficiaryClientRefId,
                                                clientReferenceId:
                                                    clientReferenceId,
                                                tenantId: envConfig
                                                    .variables.tenantId,
                                                rowVersion: 1,
                                                auditDetails: AuditDetails(
                                                  createdBy:
                                                      context.loggedInUserUuid,
                                                  createdTime: context
                                                      .millisecondsSinceEpoch(),
                                                ),
                                                projectId: context.projectId,
                                                status: Status
                                                    .beneficiaryReferred
                                                    .toValue(),
                                                clientAuditDetails:
                                                    ClientAuditDetails(
                                                  createdBy:
                                                      context.loggedInUserUuid,
                                                  createdTime: context
                                                      .millisecondsSinceEpoch(),
                                                  lastModifiedBy:
                                                      context.loggedInUserUuid,
                                                  lastModifiedTime: context
                                                      .millisecondsSinceEpoch(),
                                                ),
                                                additionalFields:
                                                    TaskAdditionalFields(
                                                  version: 1,
                                                  fields: [
                                                    AdditionalField(
                                                      'taskStatus',
                                                      Status.beneficiaryReferred
                                                          .toValue(),
                                                    ),
                                                    if (widget
                                                        .isReadministrationUnSuccessful)
                                                      AdditionalField(
                                                        'quantityWasted',
                                                        widget.quantityWasted
                                                                    .toString()
                                                                    .length ==
                                                                1
                                                            ? "0${widget.quantityWasted}"
                                                            : widget
                                                                .quantityWasted
                                                                .toString(),
                                                      ),
                                                    if (widget
                                                        .isReadministrationUnSuccessful)
                                                      const AdditionalField(
                                                        'unsuccessfullDelivery',
                                                        'true',
                                                      ),
                                                    if (widget
                                                            .productVariantId !=
                                                        null)
                                                      AdditionalField(
                                                        'productVariantId',
                                                        widget.productVariantId,
                                                      ),
                                                  ],
                                                ),
                                                address: widget
                                                    .individual.address?.first
                                                    .copyWith(
                                                  relatedClientReferenceId:
                                                      clientReferenceId,
                                                  id: null,
                                                ),
                                              ),
                                            ],
                                            false,
                                            context.boundary,
                                          ),
                                        );

                                    final reloadState =
                                        context.read<HouseholdOverviewBloc>();

                                    Future.delayed(
                                      const Duration(milliseconds: 500),
                                      () {
                                        reloadState
                                            .add(HouseholdOverviewReloadEvent(
                                          projectId: context.projectId,
                                          projectBeneficiaryType:
                                              context.beneficiaryType,
                                        ));
                                      },
                                    ).then(
                                      (value) => context.router.popAndPush(
                                        HouseholdAcknowledgementRoute(
                                          enableViewHousehold: true,
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: Center(
                            child: Text(
                              localizations
                                  .translate(i18.common.coreCommonSubmit),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  children: [
                    DigitCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  localizations.translate(
                                    i18.referBeneficiary.referralDetails,
                                  ),
                                  style: theme.textTheme.displayMedium,
                                ),
                              ),
                            ],
                          ),
                          Column(children: [
                            DigitDateFormPicker(
                              isEnabled: false,
                              formControlName: _dateOfReferralKey,
                              label: localizations.translate(
                                i18.referBeneficiary.dateOfReferralLabel,
                              ),
                              isRequired: false,
                              initialDate: DateTime.now(),
                              cancelText: localizations
                                  .translate(i18.common.coreCommonCancel),
                              confirmText: localizations
                                  .translate(i18.common.coreCommonOk),
                            ),
                            DigitTextFormField(
                              formControlName: _administrativeUnitKey,
                              label: localizations.translate(
                                i18.referBeneficiary.organizationUnitFormLabel,
                              ),
                              isRequired: true,
                              readOnly: true,
                            ),
                            DigitTextFormField(
                              formControlName: _referredByKey,
                              readOnly: true,
                              label: localizations.translate(
                                i18.referBeneficiary.referredByLabel,
                              ),
                              validationMessages: {
                                'required': (_) => localizations.translate(
                                      i18.common.corecommonRequired,
                                    ),
                              },
                              isRequired: true,
                            ),
                            DigitTextFormField(
                              valueAccessor: FacilityValueAccessor(
                                facilities,
                              ),
                              label: localizations.translate(
                                i18.referBeneficiary.referredToLabel,
                              ),
                              isRequired: true,
                              suffix: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.search),
                              ),
                              formControlName: _referredToKey,
                              readOnly: false,
                              validationMessages: {
                                'required': (_) => localizations.translate(
                                      i18.referBeneficiary
                                          .facilityValidationMessage,
                                    ),
                              },
                              onTap: () async {
                                final parent =
                                    context.router.parent() as StackRouter;
                                final facility =
                                    await parent.push<FacilityModel>(
                                  FacilitySelectionRoute(
                                    facilities: facilities,
                                  ),
                                );

                                if (facility == null) return;
                                form.control(_referredToKey).value = facility;
                              },
                            ),
                            BlocBuilder<AppInitializationBloc,
                                AppInitializationState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () => const Offstage(),
                                  initialized: (appConfiguration, _) {
                                    final List<KeyValue> reasons =
                                        (appConfiguration.referralReasons ?? [])
                                            .map(
                                              (e) => KeyValue(e.code, e.code),
                                            )
                                            .toList();

                                    return DigitRadioButtonList<KeyValue>(
                                      labelStyle: DigitTheme.instance
                                          .mobileTheme.textTheme.bodyLarge,
                                      formControlName: _referralReason,
                                      valueMapper: (val) =>
                                          localizations.translate(val.label),
                                      options: reasons,
                                      labelText: localizations.translate(
                                        i18.referBeneficiary.reasonForReferral,
                                      ),
                                      isRequired: true,
                                      errorMessage: localizations.translate(
                                        i18.common.corecommonRequired,
                                      ),
                                      onValueChange: (val) {
                                        form.control(_referralReason).value =
                                            val;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            DigitTextFormField(
                              formControlName: _referralCode,
                              isRequired: true,
                              label: localizations.translate(
                                i18.referBeneficiary.referralCodeLabel,
                              ),
                              validationMessages: {
                                'required': (_) => localizations.translate(
                                      i18.common.corecommonRequired,
                                    ),
                              },
                            ),
                            DigitTextFormField(
                              formControlName: _referralComments,
                              label: localizations.translate(
                                i18.referBeneficiary.referralComments,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  FormGroup buildForm() {
    return fb.group(<String, Object>{
      _dateOfReferralKey: FormControl<DateTime>(value: DateTime.now()),
      _administrativeUnitKey: FormControl<String>(value: context.boundary.name),
      _referredByKey: FormControl<String>(
        value: context.loggedInUser.userName,
        validators: [Validators.required],
      ),
      _referredToKey:
          FormControl<FacilityModel>(validators: [Validators.required]),
      _referralReason: FormControl<KeyValue>(value: null),
      _referralComments: FormControl<String>(value: null),
      _referralCode: FormControl<String>(validators: [Validators.required]),
    });
  }

  Future<bool> _onBackPressed(
    BuildContext context,
    bool isReadministrationUnSuccessful,
  ) async {
    if (!isReadministrationUnSuccessful) {
      return true;
    }
    if (clickedStatus.value) {
      return false;
    }
    bool? shouldNavigateBack = await showDialog<bool>(
      context: context,
      builder: (context) => DigitDialog(
        options: DigitDialogOptions(
          titleText: localizations.translate(
            i18.referBeneficiary.referAlertDialogTitle,
          ),
          content: Text(localizations.translate(
            i18.referBeneficiary.referAlertDialogContent,
          )),
          primaryAction: DigitDialogActions(
            label: localizations.translate(i18.common.coreCommonOk),
            action: (ctx) {
              Navigator.of(
                context,
                rootNavigator: false,
              ).pop(false);
            },
          ),
        ),
      ),
    );

    return shouldNavigateBack ?? false;
  }
}
