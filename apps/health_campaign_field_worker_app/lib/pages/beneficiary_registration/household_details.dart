import 'package:auto_route/auto_route.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../utils/i18_key_constants.dart' as i18;
import '../../../router/app_router.dart';
import '../../../widgets/localized.dart';
import 'package:collection/collection.dart';

import '../../blocs/beneficiary_registration/beneficiary_registration.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/search_households/search_households.dart';
import '../../models/data_model.dart';
import '../../models/entities/beneficiary_type.dart';
import '../../utils/extensions/extensions.dart';
import '../../utils/registration_delivery_singleton.dart';
import '../../utils/utils.dart';
import '../../widgets/components/text_block.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/widgets/showcase/household_details.dart';

final householdDetailsShowcaseData = HouseholdDetailsShowcaseData();

class HouseHoldDetailsPage extends LocalizedStatefulWidget {
  final bool isEligible;
  const HouseHoldDetailsPage({
    super.key,
    super.appLocalizations,
    required this.isEligible,
  });

  @override
  State<HouseHoldDetailsPage> createState() => HouseHoldDetailsPageState();
}

class HouseHoldDetailsPageState extends LocalizedState<HouseHoldDetailsPage> {
  static const _dateOfRegistrationKey = 'dateOfRegistration';
  static const _memberCountKey = 'memberCount';
  static const _pregnantWomenCountKey = 'pregnantWomenCount';
  static const _childrenCountKey = 'childrenCount';
  static const _menCountKey = 'menCount';
  static const _womenCountKey = 'womenCount';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final router = context.router;

    return Scaffold(
      body: ReactiveFormBuilder(
        form: () => buildForm(bloc.state),
        builder: (context, form, child) {
          int men =
              widget.isEligible ? form.control(_menCountKey).value as int : 0;
          int women =
              widget.isEligible ? form.control(_womenCountKey).value as int : 0;
          return BlocConsumer<BeneficiaryRegistrationBloc,
              BeneficiaryRegistrationState>(
            listener: (context, state) {
              if (state is BeneficiaryRegistrationPersistedState &&
                  state.isEdit) {
                final overviewBloc = context.read<HouseholdOverviewBloc>();

                HouseholdMemberWrapper memberWrapper =
                    overviewBloc.state.householdMemberWrapper;

                Future.delayed(
                  const Duration(
                    milliseconds: 300,
                  ),
                  () {
                    overviewBloc.add(
                      HouseholdOverviewReloadEvent(
                        projectId: RegistrationDeliverySingleton()
                            .projectId
                            .toString(),
                        projectBeneficiaryType:
                            RegistrationDeliverySingleton().beneficiaryType ??
                                BeneficiaryType.household,
                      ),
                    );
                    memberWrapper = overviewBloc.state.householdMemberWrapper;
                  },
                );
                final route = router.parent() as StackRouter;
                route.popUntilRouteWithName(SearchBeneficiaryRoute.name);

                route.push(BeneficiaryWrapperRoute(wrapper: memberWrapper));
              }
            },
            builder: (context, registrationState) {
              return ScrollableContent(
                header: const Column(children: [
                  BackNavigationHelpHeaderWidget(
                    showHelp: false,
                  ),
                ]),
                enableFixedButton: true,
                footer: DigitCard(
                  margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                  padding: const EdgeInsets.fromLTRB(kPadding, 0, kPadding, 0),
                  child: DigitElevatedButton(
                    onPressed: () async {
                      form.markAllAsTouched();
                      if (!form.valid) return;

                      final memberCount =
                          form.control(_memberCountKey).value as int;

                      final dateOfRegistration = form
                          .control(_dateOfRegistrationKey)
                          .value as DateTime;

                      //[TODO: Use pregnant women form value based on project config
                      final pregnantWomen = widget.isEligible
                          ? form.control(_pregnantWomenCountKey).value as int
                          : 0;
                      final children = widget.isEligible
                          ? form.control(_childrenCountKey).value as int
                          : 0;

                      final men = widget.isEligible
                          ? form.control(_menCountKey).value as int
                          : 0;
                      final women = widget.isEligible
                          ? form.control(_womenCountKey).value as int
                          : 0;

                      if (widget.isEligible && (memberCount < (men + women))) {
                        DigitToast.show(context,
                            options: DigitToastOptions(
                                localizations.translate(
                                    i18.householdDetails.memberCountError),
                                true,
                                theme));
                      } else {
                        if (memberCount > 10) {
                          final shouldSubmit = await DigitDialog.show<bool>(
                            context,
                            options: DigitDialogOptions(
                              titleText: localizations.translate(
                                i18.beneficiaryDetails.noOfMembersAlertTitle,
                              ),
                              contentText: localizations.translate(
                                i18.beneficiaryDetails.noOfMembersAlertContent,
                              ),
                              primaryAction: DigitDialogActions(
                                label: localizations.translate(
                                  i18.beneficiaryDetails.noOfMembersAlertYes,
                                ),
                                action: (ctx) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop(true);
                                },
                              ),
                              secondaryAction: DigitDialogActions(
                                label: localizations.translate(
                                  i18.beneficiaryDetails.noOfMembersAlertNo,
                                ),
                                action: (context) => Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(false),
                              ),
                            ),
                          );

                          if (!(shouldSubmit ?? false)) {
                            return;
                          }
                        }

                        registrationState.maybeWhen(orElse: () {
                          return;
                        }, create: (
                          addressModel,
                          householdModel,
                          individualModel,
                          projectBeneficiaryModel,
                          registrationDate,
                          searchQuery,
                          loading,
                          isHeadOfHousehold,
                        ) {
                          var household = householdModel;
                          household ??= HouseholdModel(
                            tenantId: RegistrationDeliverySingleton().tenantId,
                            clientReferenceId:
                                householdModel?.clientReferenceId ??
                                    IdGen.i.identifier,
                            rowVersion: 1,
                            clientAuditDetails: ClientAuditDetails(
                              createdBy: RegistrationDeliverySingleton()
                                  .loggedInUserUuid!,
                              createdTime: context.millisecondsSinceEpoch(),
                              lastModifiedBy: RegistrationDeliverySingleton()
                                  .loggedInUserUuid,
                              lastModifiedTime:
                                  context.millisecondsSinceEpoch(),
                            ),
                            auditDetails: AuditDetails(
                              createdBy: RegistrationDeliverySingleton()
                                  .loggedInUserUuid!,
                              createdTime: context.millisecondsSinceEpoch(),
                              lastModifiedBy: RegistrationDeliverySingleton()
                                  .loggedInUserUuid,
                              lastModifiedTime:
                                  context.millisecondsSinceEpoch(),
                            ),
                          );

                          household = household.copyWith(
                              rowVersion: 1,
                              tenantId:
                                  RegistrationDeliverySingleton().tenantId,
                              clientReferenceId:
                                  householdModel?.clientReferenceId ??
                                      IdGen.i.identifier,
                              memberCount: memberCount,
                              clientAuditDetails: ClientAuditDetails(
                                createdBy: RegistrationDeliverySingleton()
                                    .loggedInUserUuid
                                    .toString(),
                                createdTime: context.millisecondsSinceEpoch(),
                                lastModifiedBy: RegistrationDeliverySingleton()
                                    .loggedInUserUuid
                                    .toString(),
                                lastModifiedTime:
                                    context.millisecondsSinceEpoch(),
                              ),
                              auditDetails: AuditDetails(
                                createdBy: RegistrationDeliverySingleton()
                                    .loggedInUserUuid
                                    .toString(),
                                createdTime: context.millisecondsSinceEpoch(),
                                lastModifiedBy: RegistrationDeliverySingleton()
                                    .loggedInUserUuid
                                    .toString(),
                                lastModifiedTime:
                                    context.millisecondsSinceEpoch(),
                              ),
                              address: addressModel,
                              additionalFields: HouseholdAdditionalFields(
                                  version: 1,
                                  fields: [
                                    //[TODO: Use pregnant women form value based on project config
                                    ...?householdModel?.additionalFields?.fields
                                        .where((e) =>
                                            e.key !=
                                                AdditionalFieldsType
                                                    .pregnantWomen
                                                    .toValue() &&
                                            e.key !=
                                                AdditionalFieldsType.children
                                                    .toValue()),
                                    if (widget.isEligible)
                                      AdditionalField(
                                        AdditionalFieldsType.pregnantWomen
                                            .toValue(),
                                        pregnantWomen,
                                      ),
                                    if (widget.isEligible)
                                      AdditionalField(
                                        AdditionalFieldsType.children.toValue(),
                                        children,
                                      ),
                                    if (widget.isEligible)
                                      AdditionalField(
                                        _menCountKey,
                                        men,
                                      ),
                                    if (widget.isEligible)
                                      AdditionalField(
                                        _womenCountKey,
                                        women,
                                      )
                                  ]));

                          bloc.add(
                            BeneficiaryRegistrationSaveHouseholdDetailsEvent(
                              household: household,
                              registrationDate: dateOfRegistration,
                            ),
                          );

                          context.router.push(
                            IndividualDetailsRoute(
                              isHeadOfHousehold: true,
                            ),
                          );
                        }, editHousehold: (
                          addressModel,
                          householdModel,
                          individuals,
                          registrationDate,
                          projectBeneficiaryModel,
                          loading,
                          isHeadOfHousehold,
                        ) {
                          var household = householdModel.copyWith(
                              memberCount: memberCount,
                              address: addressModel,
                              clientAuditDetails: (householdModel
                                              .clientAuditDetails?.createdBy !=
                                          null &&
                                      householdModel.clientAuditDetails
                                              ?.createdTime !=
                                          null)
                                  ? ClientAuditDetails(
                                      createdBy: householdModel
                                          .clientAuditDetails!.createdBy,
                                      createdTime: householdModel
                                          .clientAuditDetails!.createdTime,
                                      lastModifiedBy:
                                          RegistrationDeliverySingleton()
                                              .loggedInUserUuid,
                                      lastModifiedTime:
                                          DateTime.now().millisecondsSinceEpoch,
                                    )
                                  : null,
                              rowVersion: householdModel.rowVersion,
                              additionalFields: HouseholdAdditionalFields(
                                  version: householdModel
                                          .additionalFields?.version ??
                                      1,
                                  fields: [
                                    //[TODO: Use pregnant women form value based on project config
                                    ...?householdModel.additionalFields?.fields
                                        .where((e) =>
                                            e.key !=
                                                AdditionalFieldsType
                                                    .pregnantWomen
                                                    .toValue() &&
                                            e.key !=
                                                AdditionalFieldsType.children
                                                    .toValue()),
                                    if (widget.isEligible)
                                      AdditionalField(
                                        AdditionalFieldsType.pregnantWomen
                                            .toValue(),
                                        pregnantWomen,
                                      ),
                                    if (widget.isEligible)
                                      AdditionalField(
                                        AdditionalFieldsType.children.toValue(),
                                        children,
                                      )
                                  ]));

                          bloc.add(
                            BeneficiaryRegistrationUpdateHouseholdDetailsEvent(
                              household: household.copyWith(
                                  clientAuditDetails: (addressModel
                                                  .clientAuditDetails
                                                  ?.createdBy !=
                                              null &&
                                          addressModel.clientAuditDetails
                                                  ?.createdTime !=
                                              null)
                                      ? ClientAuditDetails(
                                          createdBy: addressModel
                                              .clientAuditDetails!.createdBy,
                                          createdTime: addressModel
                                              .clientAuditDetails!.createdTime,
                                          lastModifiedBy:
                                              RegistrationDeliverySingleton()
                                                  .loggedInUserUuid,
                                          lastModifiedTime:
                                              context.millisecondsSinceEpoch(),
                                        )
                                      : null,
                                  additionalFields:
                                      household.additionalFields == null
                                          ? null
                                          : HouseholdAdditionalFields(
                                              version: household
                                                      .additionalFields
                                                      ?.version ??
                                                  1,
                                              fields: household
                                                  .additionalFields!.fields)),
                              addressModel: addressModel.copyWith(
                                clientAuditDetails: (addressModel
                                                .clientAuditDetails
                                                ?.createdBy !=
                                            null &&
                                        addressModel.clientAuditDetails
                                                ?.createdTime !=
                                            null)
                                    ? ClientAuditDetails(
                                        createdBy: addressModel
                                            .clientAuditDetails!.createdBy,
                                        createdTime: addressModel
                                            .clientAuditDetails!.createdTime,
                                        lastModifiedBy:
                                            RegistrationDeliverySingleton()
                                                .loggedInUserUuid,
                                        lastModifiedTime:
                                            context.millisecondsSinceEpoch(),
                                      )
                                    : null,
                              ),
                            ),
                          );
                          // final overviewBloc =
                          //     context.read<HouseholdOverviewBloc>();
                          // HouseholdMemberWrapper? memberWrapper =
                          //     overviewBloc.state.householdMemberWrapper;
                          // overviewBloc.add(
                          //   HouseholdOverviewReloadEvent(
                          //     projectId: RegistrationDeliverySingleton()
                          //         .projectId
                          //         .toString(),
                          //     projectBeneficiaryType:
                          //         RegistrationDeliverySingleton()
                          //                 .beneficiaryType ??
                          //             BeneficiaryType.household,
                          //   ),
                          // );

                          // final route = router.parent() as StackRouter;
                          // context.router.push(
                          //   CustomIndividualDetailsSMCRoute(
                          //     isHeadOfHousehold: true, //TOCHECK
                          //   ),
                          // );
                        });
                      }
                    },
                    child: Center(
                      child: Text(
                        registrationState.mapOrNull(
                              editHousehold: (value) => localizations
                                  .translate(i18.common.coreCommonSave),
                            ) ??
                            localizations
                                .translate(i18.householdDetails.actionLabel),
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
                          TextBlock(
                            padding: const EdgeInsets.only(top: kPadding),
                            heading: localizations.translate(
                              i18.householdDetails.householdDetailsLabel,
                            ),
                            headingStyle: theme.textTheme.displayMedium,
                            body: localizations.translate(
                              i18.householdDetails.householdDetailsDescription,
                            ),
                          ),
                          Column(children: [
                            householdDetailsShowcaseData.dateOfRegistration
                                .buildWith(
                              child: DigitDateFormPicker(
                                isEnabled: false,
                                formControlName: _dateOfRegistrationKey,
                                label: localizations.translate(
                                  i18.householdDetails.dateOfRegistrationLabel,
                                ),
                                isRequired: false,
                                confirmText: localizations.translate(
                                  i18.common.coreCommonOk,
                                ),
                                cancelText: localizations.translate(
                                  i18.common.coreCommonCancel,
                                ),
                              ),
                            ),
                            //[TODO: Use pregnant women form value based on project config
                            if (widget.isEligible)
                              householdDetailsShowcaseData
                                  .numberOfPregnantWomenInHousehold
                                  .buildWith(
                                child: DigitIntegerFormPicker(
                                  minimum: 0,
                                  maximum: 20,
                                  // onChange: () {
                                  //   int men = form.control(_menCountKey).value;
                                  //   int women =
                                  //       form.control(_womenCountKey).value;
                                  //   int memberCount =
                                  //       form.control(_memberCountKey).value;
                                  //   form.control(_memberCountKey).value =
                                  //       memberCount < (men + women)
                                  //           ? men + women
                                  //           : memberCount;
                                  // },
                                  form: form,
                                  formControlName: _pregnantWomenCountKey,
                                  label: localizations.translate(
                                    i18.householdDetails
                                        .noOfPregnantWomenCountLabel,
                                  ),
                                  incrementer: true,
                                ),
                              ),
                            if (widget.isEligible)
                              householdDetailsShowcaseData
                                  .numberOfChildrenBelow5InHousehold
                                  .buildWith(
                                child: DigitIntegerFormPicker(
                                  minimum: 0,
                                  maximum: 20,
                                  // onChange: () {
                                  //   int pregnantWomen = form
                                  //       .control(_pregnantWomenCountKey)
                                  //       .value;
                                  //   int children =
                                  //       form.control(_childrenCountKey).value;
                                  //   int memberCount =
                                  //       form.control(_memberCountKey).value;
                                  //   form.control(_memberCountKey).value =
                                  //       memberCount <=
                                  //               (children + pregnantWomen)
                                  //           ? children + pregnantWomen
                                  //           : memberCount;
                                  // },
                                  form: form,
                                  formControlName: _childrenCountKey,
                                  label: localizations.translate(
                                    i18.householdDetails
                                        .noOfChildrenBelow5YearsLabel,
                                  ),
                                  incrementer: true,
                                ),
                              ),

                            if (widget.isEligible)
                              DigitIntegerFormPicker(
                                minimum: 0,
                                maximum: 20,
                                onChange: () {
                                  int men = form.control(_menCountKey).value;
                                  int women =
                                      form.control(_womenCountKey).value;
                                  int memberCount =
                                      form.control(_memberCountKey).value;
                                  form.control(_memberCountKey).value =
                                      memberCount < (men + women)
                                          ? men + women
                                          : memberCount;
                                },
                                form: form,
                                formControlName: _menCountKey,
                                label: localizations.translate(
                                  i18.beneficiaryDetails.noOfMenCountLabel,
                                ),
                                incrementer: true,
                              ),
                            if (widget.isEligible)
                              DigitIntegerFormPicker(
                                minimum: 0,
                                maximum: 20,
                                onChange: () {
                                  int men = form.control(_menCountKey).value;
                                  int women =
                                      form.control(_womenCountKey).value;
                                  int memberCount =
                                      form.control(_memberCountKey).value;
                                  form.control(_memberCountKey).value =
                                      memberCount < (men + women)
                                          ? men + women
                                          : memberCount;
                                },
                                form: form,
                                formControlName: _womenCountKey,
                                label: localizations.translate(
                                  i18.beneficiaryDetails.noOfWomenCountLabel,
                                ),
                                incrementer: true,
                              ),
                            householdDetailsShowcaseData
                                .numberOfMembersLivingInHousehold
                                .buildWith(
                              child: DigitIntegerFormPicker(
                                minimum: men + women != 0 ? men + women : 1,
                                maximum: 20,
                                onChange: () {
                                  int men = form.control(_menCountKey).value;
                                  int women =
                                      form.control(_womenCountKey).value;
                                  int memberCount =
                                      form.control(_memberCountKey).value;
                                  if (memberCount <= men + women) {
                                    form.control(_memberCountKey).value =
                                        (men + women);
                                  }
                                },
                                form: form,
                                formControlName: _memberCountKey,
                                label: localizations.translate(
                                  i18.householdDetails.noOfMembersCountLabel,
                                ),
                                incrementer: true,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  FormGroup buildForm(BeneficiaryRegistrationState state) {
    final household = state.mapOrNull(editHousehold: (value) {
      return value.householdModel;
    }, create: (value) {
      return value.householdModel;
    });

    final registrationDate = state.mapOrNull(
      editHousehold: (value) {
        return value.registrationDate;
      },
      create: (value) => DateTime.now(),
    );

    return fb.group(<String, Object>{
      _dateOfRegistrationKey:
          FormControl<DateTime>(value: registrationDate, validators: []),
      _memberCountKey: FormControl<int>(
        value: household?.memberCount ?? 1,
        validators: [Validators.max<int>(20)],
      ),
      // if (widget.isEligible)
      _pregnantWomenCountKey: FormControl<int>(
        value: household?.additionalFields?.fields
                    .where((h) =>
                        h.key == AdditionalFieldsType.pregnantWomen.toValue())
                    .firstOrNull
                    ?.value !=
                null
            ? int.tryParse(household?.additionalFields?.fields
                    .where((h) =>
                        h.key == AdditionalFieldsType.pregnantWomen.toValue())
                    .firstOrNull
                    ?.value
                    .toString() ??
                '0')
            : 0,
        validators: [Validators.max<int>(20)],
      ),
      // if (widget.isEligible)
      _childrenCountKey: FormControl<int>(
        value: household?.additionalFields?.fields
                    .where(
                        (h) => h.key == AdditionalFieldsType.children.toValue())
                    .firstOrNull
                    ?.value !=
                null
            ? int.tryParse(household?.additionalFields?.fields
                    .where(
                        (h) => h.key == AdditionalFieldsType.children.toValue())
                    .firstOrNull
                    ?.value
                    .toString() ??
                '0')
            : 0,
        validators: [Validators.max<int>(20)],
      ),
      _menCountKey: FormControl<int>(
        value: household?.additionalFields?.fields
                    .where((h) => h.key == _menCountKey)
                    .firstOrNull
                    ?.value !=
                null
            ? int.tryParse(household?.additionalFields?.fields
                    .where((h) => h.key == _menCountKey)
                    .firstOrNull
                    ?.value
                    .toString() ??
                '0')
            : 0,
        validators: [Validators.max<int>(20)],
      ),
      // if (widget.isEligible)
      _womenCountKey: FormControl<int>(
        value: household?.additionalFields?.fields
                    .where((h) => h.key == _womenCountKey)
                    .firstOrNull
                    ?.value !=
                null
            ? int.tryParse(household?.additionalFields?.fields
                    .where((h) => h.key == _womenCountKey)
                    .firstOrNull
                    ?.value
                    .toString() ??
                '0')
            : 0,
        validators: [Validators.max<int>(20)],
      ),
    });
  }
}
