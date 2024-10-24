import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:digit_components/widgets/atoms/digit_checkbox.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:digit_components/widgets/digit_dob_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../utils/validations.dart' as validation;
import '../../blocs/app_initialization/app_initialization.dart';
import '../../blocs/beneficiary_registration/beneficiary_registration.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/search_households/search_households.dart';
import '../../data/local_store/no_sql/schema/app_configuration.dart';
import '../../models/data_model.dart';
import '../../models/entities/identifier_types.dart';
import '../../router/app_router.dart';
import '../../utils/environment_config.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/utils.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';

class IndividualDetailsPage extends LocalizedStatefulWidget {
  final bool isHeadOfHousehold;

  const IndividualDetailsPage({
    super.key,
    super.appLocalizations,
    this.isHeadOfHousehold = false,
  });

  @override
  State<IndividualDetailsPage> createState() => _IndividualDetailsPageState();
}

class _IndividualDetailsPageState
    extends LocalizedState<IndividualDetailsPage> {
  static const _individualNameKey = 'individualName';
  static const _individualLastNameKey = 'individualLastName';
  static const _dobKey = 'dob';
  static const _genderKey = 'gender';
  static const _mobileNumberKey = 'mobileNumber';
  DateTime now = DateTime.now();

  bool isHeadAgeValid = true;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final router = context.router;
    final theme = Theme.of(context);
    DateTime before150Years = DateTime(now.year - 150, now.month, now.day);

    return Scaffold(
      body: ReactiveFormBuilder(
        form: () => buildForm(bloc.state),
        builder: (context, form, child) => BlocConsumer<
            BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
          listener: (context, state) {
            state.mapOrNull(
              persisted: (value) {
                if (value.navigateToRoot) {
                  (router.parent() as StackRouter).pop();
                } else {
                  Future.delayed(
                    const Duration(
                      milliseconds: 200,
                    ),
                    () {
                      (router.parent() as StackRouter).pop();
                      context.read<SearchHouseholdsBloc>().add(
                            SearchHouseholdsByHouseholdsEvent(
                              householdModel: value.householdModel,
                              projectId: context.projectId,
                              isProximityEnabled: false,
                            ),
                          );
                    },
                  ).then((value) => {
                        router.push(BeneficiaryAcknowledgementRoute(
                          enableViewHousehold: true,
                        )),
                      });
                }
              },
            );
          },
          builder: (context, state) {
            return ScrollableContent(
              enableFixedButton: true,
              header: const Column(children: [
                BackNavigationHelpHeaderWidget(),
              ]),
              footer: DigitCard(
                margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
                child: DigitElevatedButton(
                  onPressed: () async {
                    if (form.control(_dobKey).value == null) {
                      form.control(_dobKey).setErrors({'': true});
                    }
                    if (widget.isHeadOfHousehold) {
                      final value = form.control(_dobKey).value;
                      DigitDOBAge age = DigitDateUtils.calculateAge(value);
                      isHeadAgeValid = age.years >= 18;
                    }

                    if (!isHeadAgeValid) {
                      await DigitToast.show(
                        context,
                        options: DigitToastOptions(
                          localizations.translate(
                            i18.individualDetails.headAgeValidError,
                          ),
                          true,
                          theme,
                        ),
                      );

                      return;
                    }
                    final userId = context.loggedInUserUuid;
                    final projectId = context.projectId;
                    form.markAllAsTouched();
                    if (!form.valid) return;
                    FocusManager.instance.primaryFocus?.unfocus();

                    state.maybeWhen(
                      orElse: () {
                        return;
                      },
                      create: (
                        addressModel,
                        householdModel,
                        individualModel,
                        registrationDate,
                        searchQuery,
                        loading,
                        isHeadOfHousehold,
                      ) async {
                        final individual = _getIndividualModel(
                          context,
                          form: form,
                          oldIndividual: null,
                        );

                        final locationBloc = context.read<LocationBloc>();
                        final locationInitialState = locationBloc.state;
                        final initialLat = locationInitialState.latitude;
                        final initialLng = locationInitialState.longitude;
                        final initialAccuracy = locationInitialState.accuracy;
                        if (addressModel != null &&
                            (addressModel.latitude == null ||
                                addressModel.longitude == null ||
                                addressModel.locationAccuracy == null)) {
                          bloc.add(
                            BeneficiaryRegistrationSaveAddressEvent(
                              addressModel.copyWith(
                                latitude:
                                    initialLat ?? addressModel.locationAccuracy,
                                longitude:
                                    initialLng ?? addressModel.locationAccuracy,
                                locationAccuracy: initialAccuracy ??
                                    addressModel.locationAccuracy,
                              ),
                            ),
                          );
                        }

                        final boundary = context.boundary;

                        bloc.add(
                          BeneficiaryRegistrationSaveIndividualDetailsEvent(
                            model: individual,
                            isHeadOfHousehold: widget.isHeadOfHousehold,
                          ),
                        );

                        final submit = await DigitDialog.show<bool>(
                          context,
                          options: DigitDialogOptions(
                            titleText: localizations.translate(
                              i18.deliverIntervention.dialogTitle,
                            ),
                            contentText: localizations.translate(
                              i18.deliverIntervention.dialogContent,
                            ),
                            primaryAction: DigitDialogActions(
                              label: localizations.translate(
                                i18.common.coreCommonSubmit,
                              ),
                              action: (context) {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(true);
                              },
                            ),
                            secondaryAction: DigitDialogActions(
                              label: localizations.translate(
                                i18.common.coreCommonCancel,
                              ),
                              action: (context) => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop(false),
                            ),
                          ),
                        );

                        if (submit ?? false) {
                          bloc.add(
                            BeneficiaryRegistrationCreateEvent(
                              projectId: projectId,
                              userUuid: userId,
                              boundary: boundary,
                            ),
                          );
                        }
                      },
                      editIndividual: (
                        householdModel,
                        individualModel,
                        addressModel,
                        loading,
                      ) {
                        final individual = _getIndividualModel(
                          context,
                          form: form,
                          oldIndividual: individualModel,
                        );

                        bloc.add(
                          BeneficiaryRegistrationUpdateIndividualDetailsEvent(
                            addressModel: addressModel,
                            model: individual.copyWith(
                              clientAuditDetails: (individual
                                              .clientAuditDetails?.createdBy !=
                                          null &&
                                      individual.clientAuditDetails
                                              ?.createdTime !=
                                          null)
                                  ? ClientAuditDetails(
                                      createdBy: individual
                                          .clientAuditDetails!.createdBy,
                                      createdTime: individual
                                          .clientAuditDetails!.createdTime,
                                      lastModifiedBy: context.loggedInUserUuid,
                                      lastModifiedTime:
                                          context.millisecondsSinceEpoch(),
                                    )
                                  : null,
                              auditDetails: (individual
                                              .auditDetails?.createdBy !=
                                          null &&
                                      individual.auditDetails?.createdTime !=
                                          null)
                                  ? AuditDetails(
                                      createdBy:
                                          individual.auditDetails!.createdBy,
                                      createdTime:
                                          individual.auditDetails!.createdTime,
                                      lastModifiedBy: context.loggedInUserUuid,
                                      lastModifiedTime:
                                          context.millisecondsSinceEpoch(),
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                      addMember: (
                        addressModel,
                        householdModel,
                        loading,
                      ) {
                        final individual = _getIndividualModel(
                          context,
                          form: form,
                        );

                        bloc.add(
                          BeneficiaryRegistrationAddMemberEvent(
                            beneficiaryType: context.beneficiaryType,
                            householdModel: householdModel,
                            individualModel: individual,
                            addressModel: addressModel,
                            userUuid: userId,
                            projectId: context.projectId,
                          ),
                        );
                      },
                    );
                  },
                  child: Center(
                    child: Text(
                      state.mapOrNull(
                            editIndividual: (value) => localizations
                                .translate(i18.common.coreCommonSave),
                          ) ??
                          localizations.translate(i18.common.coreCommonSubmit),
                    ),
                  ),
                ),
              ),
              children: [
                DigitCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.translate(
                          widget.isHeadOfHousehold
                              ? i18.individualDetails
                                  .headHouseholdDetailsLabelText
                              : i18.individualDetails
                                  .childIndividualsDetailsLabelText,
                        ),
                        style: theme.textTheme.displayMedium,
                      ),
                      Column(
                        children: [
                          DigitTextFormField(
                            formControlName: _individualNameKey,
                            label: localizations.translate(
                              widget.isHeadOfHousehold
                                  ? i18.individualDetails.firstNameHeadLabelText
                                  : i18.individualDetails
                                      .childFirstNameLabelText,
                            ),
                            maxLength: 200,
                            isRequired: true,
                            validationMessages: {
                              'required': (object) => localizations.translate(
                                    i18.individualDetails
                                        .firstNameIsRequiredError,
                                  ),
                              'minLength': (object) => localizations.translate(
                                    i18.individualDetails.firstNameLengthError,
                                  ),
                              'maxLength': (object) => localizations.translate(
                                    i18.individualDetails.firstNameLengthError,
                                  ),
                              "min3": (object) => localizations.translate(
                                    i18.common.min3CharsRequired,
                                  ),
                            },
                          ),
                          DigitTextFormField(
                            formControlName: _individualLastNameKey,
                            label: localizations.translate(
                              widget.isHeadOfHousehold
                                  ? i18.individualDetails.lastNameHeadLabelText
                                  : i18
                                      .individualDetails.childLastNameLabelText,
                            ),
                            maxLength: 200,
                            isRequired: true,
                            validationMessages: {
                              'required': (object) => localizations.translate(
                                    i18.individualDetails
                                        .lastNameIsRequiredError,
                                  ),
                              'minLength': (object) => localizations.translate(
                                    i18.individualDetails.lastNameLengthError,
                                  ),
                              'maxLength': (object) => localizations.translate(
                                    i18.individualDetails.lastNameLengthError,
                                  ),
                              "min3": (object) => localizations.translate(
                                    i18.common.min3CharsRequired,
                                  ),
                            },
                          ),
                          Offstage(
                            offstage: !widget.isHeadOfHousehold,
                            child: DigitCheckbox(
                              label: localizations.translate(
                                i18.individualDetails.checkboxLabelText,
                              ),
                              value: widget.isHeadOfHousehold,
                            ),
                          ),
                          DigitDobPicker(
                            datePickerFormControl: _dobKey,
                            datePickerLabel: localizations.translate(
                              i18.individualDetails.dobLabelText,
                            ),
                            ageFieldLabel: localizations.translate(
                              i18.individualDetails.ageLabelText,
                            ),
                            yearsHintLabel: localizations.translate(
                              i18.individualDetails.yearsHintText,
                            ),
                            monthsHintLabel: localizations.translate(
                              i18.individualDetails.monthsHintText,
                            ),
                            separatorLabel: localizations.translate(
                              i18.individualDetails.separatorLabelText,
                            ),
                            yearsAndMonthsErrMsg: localizations.translate(
                              i18.individualDetails.yearsAndMonthsErrorText,
                            ),
                            initialDate: before150Years,
                            confirmText: localizations.translate(
                              i18.common.coreCommonOk,
                            ),
                            cancelText: localizations.translate(
                              i18.common.coreCommonCancel,
                            ),
                            onChangeOfFormControl: (formControl) {
                              // Handle changes to the control's value here
                              final value = formControl.value;
                              if (value == null) {
                                formControl.setErrors({'': true});
                              } else {
                                DigitDOBAge age =
                                    DigitDateUtils.calculateAge(value);
                                if ((age.years == 0 && age.months == 0) ||
                                    age.months > 11 ||
                                    (age.years > 150 ||
                                        (age.years == 150 && age.months > 0))) {
                                  formControl.setErrors({'': true});
                                } else {
                                  formControl.removeError('');
                                }
                              }
                            },
                          ),
                          BlocBuilder<AppInitializationBloc,
                              AppInitializationState>(
                            builder: (context, state) => state.maybeWhen(
                              orElse: () => const Offstage(),
                              initialized: (appConfiguration, _) {
                                final genderOptions =
                                    appConfiguration.genderOptions ??
                                        <GenderOptions>[];

                                return DigitDropdown<String>(
                                  label: localizations.translate(
                                    i18.individualDetails.genderLabelText,
                                  ),
                                  valueMapper: (value) =>
                                      localizations.translate(value),
                                  initialValue: genderOptions.firstOrNull?.name,
                                  menuItems: genderOptions
                                      .map(
                                        (e) => e.name,
                                      )
                                      .toList(),
                                  formControlName: _genderKey,
                                  isRequired: true,
                                  validationMessages: {
                                    'required': (object) =>
                                        localizations.translate(
                                          i18.common.corecommonRequired,
                                        ),
                                  },
                                );
                              },
                            ),
                          ),
                          Offstage(
                            offstage: !widget.isHeadOfHousehold,
                            child: DigitTextFormField(
                              keyboardType: TextInputType.number,
                              formControlName: _mobileNumberKey,
                              label: localizations.translate(
                                i18.individualDetails.mobileNumberLabelText,
                              ),
                              maxLength: 11,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]"),
                                ),
                              ],
                              validationMessages: {
                                'mobileNumber': (object) =>
                                    localizations.translate(i18
                                        .individualDetails
                                        .mobileNumberInvalidFormatValidationMessage),
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  IndividualModel _getIndividualModel(
    BuildContext context, {
    required FormGroup form,
    IndividualModel? oldIndividual,
  }) {
    final dob = form.control(_dobKey).value as DateTime?;
    String? dobString;
    if (dob != null) {
      dobString = DateFormat('dd/MM/yyyy').format(dob);
    }

    var individual = oldIndividual;
    individual ??= IndividualModel(
      clientReferenceId: IdGen.i.identifier,
      tenantId: envConfig.variables.tenantId,
      rowVersion: 1,
      auditDetails: AuditDetails(
        createdBy: context.loggedInUserUuid,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: context.loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
      clientAuditDetails: ClientAuditDetails(
        createdBy: context.loggedInUserUuid,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: context.loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
    );

    var name = individual.name;
    name ??= NameModel(
      individualClientReferenceId: individual.clientReferenceId,
      tenantId: envConfig.variables.tenantId,
      rowVersion: 1,
      auditDetails: AuditDetails(
        createdBy: context.loggedInUserUuid,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: context.loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
      clientAuditDetails: ClientAuditDetails(
        createdBy: context.loggedInUserUuid,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: context.loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
    );

    var identifier = (individual.identifiers?.isNotEmpty ?? false)
        ? individual.identifiers!.first
        : null;

    identifier ??= IdentifierModel(
      clientReferenceId: IdGen.i.identifier,
      tenantId: envConfig.variables.tenantId,
      rowVersion: 1,
      auditDetails: AuditDetails(
        createdBy: context.loggedInUserUuid,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: context.loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
      clientAuditDetails: ClientAuditDetails(
        createdBy: context.loggedInUserUuid,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: context.loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
    );
    // String? individualName = form.control(_individualNameKey).value as String?;

    individual = individual.copyWith(
      name: name.copyWith(
        givenName: form.control(_individualNameKey).value,
        familyName:
            (form.control(_individualLastNameKey).value as String).trim(),
      ),
      gender: form.control(_genderKey).value == null
          ? null
          : Gender.values
              .byName(form.control(_genderKey).value.toString().toLowerCase()),
      mobileNumber: form.control(_mobileNumberKey).value,
      dateOfBirth: dobString,
      identifiers: [
        identifier.copyWith(
          identifierId: context.loggedInUserUuid,
          identifierType: IdentifierTypes.defaultID.toValue(),
        ),
      ],
    );
    final cycleIndex =
        context.selectedCycle.id == 0 ? "" : "0${context.selectedCycle.id}";

    final projectTypeId = context.selectedProjectType == null
        ? ""
        : context.selectedProjectType!.id;
    individual = individual.copyWith(
      additionalFields: individual.additionalFields == null
          ? IndividualAdditionalFields(
              version: 1,
              fields: [
                AdditionalField(
                  "projectId",
                  context.projectId,
                ),
                if (cycleIndex.isNotEmpty)
                  AdditionalField(
                    "cycleIndex",
                    cycleIndex,
                  ),
                if (projectTypeId.isNotEmpty)
                  AdditionalField(
                    "projectTypeId",
                    projectTypeId,
                  ),
              ],
            )
          : individual.additionalFields!.copyWith(
              fields: [
                ...individual.additionalFields!.fields,
                AdditionalField(
                  "projectId",
                  context.projectId,
                ),
                if (cycleIndex.isNotEmpty)
                  AdditionalField(
                    "cycleIndex",
                    cycleIndex,
                  ),
                if (projectTypeId.isNotEmpty)
                  AdditionalField(
                    "projectTypeId",
                    projectTypeId,
                  ),
              ],
            ),
    );

    return individual;
  }

  FormGroup buildForm(BeneficiaryRegistrationState state) {
    final individual = state.mapOrNull<IndividualModel>(
      editIndividual: (value) {
        return value.individualModel;
      },
    );

    final searchQuery = state.mapOrNull<String>(
      create: (value) {
        return value.searchQuery;
      },
    );

    return fb.group(<String, Object>{
      _individualNameKey: FormControl<String>(
        validators: [
          Validators.required,
          CustomValidator.requiredMin3,
          Validators.maxLength(validation.individual.nameMaxLength),
        ],
        value: individual?.name?.givenName ?? searchQuery?.trim(),
      ),
      _individualLastNameKey: FormControl<String>(
        validators: [
          Validators.required,
          CustomValidator.requiredMin3,
          Validators.maxLength(validation.individual.nameMaxLength),
        ],
        value: individual?.name?.familyName ?? '',
      ),
      _dobKey: FormControl<DateTime>(
        value: individual?.dateOfBirth != null
            ? DateFormat('dd/MM/yyyy').parse(
                individual!.dateOfBirth!,
              )
            : null,
      ),
      _genderKey: FormControl<String>(
        validators: [
          Validators.required,
        ],
        value: context.read<AppInitializationBloc>().state.maybeWhen(
              orElse: () => null,
              initialized: (appConfiguration, serviceRegistryList) {
                final options =
                    appConfiguration.genderOptions ?? <GenderOptions>[];

                return options.map((e) => e.code).firstWhereOrNull(
                      (element) =>
                          element.toLowerCase() == individual?.gender?.name,
                    );
              },
            ),
      ),
      _mobileNumberKey:
          FormControl<String>(value: individual?.mobileNumber, validators: [
        CustomValidator.validMobileNumber,
      ]),
    });
  }
}
