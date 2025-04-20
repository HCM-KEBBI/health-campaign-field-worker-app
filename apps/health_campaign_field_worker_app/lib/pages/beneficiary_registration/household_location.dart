import 'package:auto_route/auto_route.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/digit_sync_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../router/app_router.dart';
import '../../../utils/extensions/extensions.dart' as contextLocal;
import '../../../utils/i18_key_constants.dart' as i18;

import '../../blocs/beneficiary_registration/beneficiary_registration.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../models/data_model.dart';
import '../../models/entities/address_type.dart';
import '../../utils/digit_components_utils.dart';
import '../../utils/registration_delivery_singleton.dart';
import '../../widgets/components/text_block.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';
import '../../widgets/widgets/showcase/household_location.dart';

final householdLocationShowcaseData = HouseholdLocationShowcaseData();

class HouseholdLocationPage extends LocalizedStatefulWidget {
  const HouseholdLocationPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<HouseholdLocationPage> createState() => _HouseholdLocationPageState();
}

class _HouseholdLocationPageState
    extends LocalizedState<HouseholdLocationPage> {
  static const _administrationAreaKey = 'administrationArea';
  static const _latKey = 'lat';
  static const _lngKey = 'lng';
  static const _accuracyKey = 'accuracy';
  static const maxLength = 64;

  @override
  void initState() {
    final regState = context.read<BeneficiaryRegistrationBloc>().state;
    context.read<LocationBloc>().add(const LoadLocationEvent());
    final router = context.router;
    final state = context.read<HouseholdOverviewBloc>().state;

    regState.maybeMap(
      orElse: () => false,
      editHousehold: (value) => false,
      create: (value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Show the dialog after the first frame is built
          DigitComponentsUtils().showLocationCapturingDialog(
            context,
            localizations.translate(i18.common.locationCapturing),
            DigitSyncDialogType.inProgress,
          );
        });
        return true;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final router = context.router;

    return Scaffold(
      body: BlocBuilder<BeneficiaryRegistrationBloc,
          BeneficiaryRegistrationState>(builder: (context, registrationState) {
        return ReactiveFormBuilder(
          form: () => buildForm(bloc.state),
          builder: (_, form, __) => BlocListener<LocationBloc, LocationState>(
            listener: (context, locationState) {
              registrationState.maybeMap(
                  orElse: () => false,
                  create: (value) {
                    if (locationState.accuracy != null) {
                      Future.delayed(const Duration(seconds: 1), () {
                        DigitComponentsUtils().hideDialog(context);
                      });
                    }
                  });
              if (locationState.accuracy != null) {
                final lat = locationState.latitude;
                final lng = locationState.longitude;
                final accuracy = locationState.accuracy;

                form.control(_latKey).value ??= lat;
                form.control(_lngKey).value ??= lng;
                form.control(_accuracyKey).value ??= accuracy;
              }
            },
            listenWhen: (previous, current) {
              final lat = form.control(_latKey).value;
              final lng = form.control(_lngKey).value;
              final accuracy = form.control(_accuracyKey).value;

              return lat != null || lng != null || accuracy != null
                  ? false
                  : true;
            },
            child: ScrollableContent(
              enableFixedButton: true,
              header: const Column(
                children: [
                  BackNavigationHelpHeaderWidget(
                    showHelp: false,
                  ),
                ],
              ),
              footer: DigitCard(
                margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                padding: const EdgeInsets.fromLTRB(kPadding, 0, kPadding, 0),
                child: BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, locationState) {
                    return DigitElevatedButton(
                      onPressed: () {
                        form.markAllAsTouched();
                        if (!form.valid) return;

                        registrationState.maybeWhen(
                          orElse: () {
                            return;
                          },
                          create: (
                            addressModel,
                            householdModel,
                            individualModel,
                            projectBeneficiaryModel,
                            registrationDate,
                            searchQuery,
                            loading,
                            isHeadOfHousehold,
                          ) {
                            var addressModel = AddressModel(
                              type: AddressType.correspondence,
                              latitude: form.control(_latKey).value ??
                                  locationState.latitude,
                              longitude: form.control(_lngKey).value ??
                                  locationState.longitude,
                              locationAccuracy:
                                  form.control(_accuracyKey).value ??
                                      locationState.accuracy,
                              locality: LocalityModel(
                                code: RegistrationDeliverySingleton()
                                    .boundary!
                                    .code!,
                                name: RegistrationDeliverySingleton()
                                    .boundary!
                                    .name,
                              ),
                              tenantId:
                                  RegistrationDeliverySingleton().tenantId,
                              rowVersion: 1,
                              auditDetails: AuditDetails(
                                createdBy: RegistrationDeliverySingleton()
                                    .loggedInUserUuid!,
                                createdTime: context.millisecondsSinceEpoch(),
                              ),
                              clientAuditDetails: ClientAuditDetails(
                                createdBy: RegistrationDeliverySingleton()
                                    .loggedInUserUuid!,
                                createdTime: context.millisecondsSinceEpoch(),
                                lastModifiedBy: RegistrationDeliverySingleton()
                                    .loggedInUserUuid,
                                lastModifiedTime:
                                    context.millisecondsSinceEpoch(),
                              ),
                            );

                            bloc.add(
                              BeneficiaryRegistrationSaveAddressEvent(
                                addressModel,
                              ),
                            );

                            router
                                .push(HouseHoldDetailsRoute(isEligible: false));
                          },
                          editHousehold: (
                            address,
                            householdModel,
                            individuals,
                            registrationDate,
                            projectBeneficiaryModel,
                            loading,
                            headOfHousehold,
                          ) {
                            var addressModel = address.copyWith(
                              type: AddressType.correspondence,
                              latitude: form.control(_latKey).value,
                              longitude: form.control(_lngKey).value,
                              locationAccuracy:
                                  form.control(_accuracyKey).value,
                            );
                            // TODO [Linking of Voucher for Household based project  need to be handled]

                            bloc.add(
                              BeneficiaryRegistrationSaveAddressEvent(
                                addressModel,
                              ),
                            );
                            router
                                .push(HouseHoldDetailsRoute(isEligible: false));
                          },
                        );
                      },
                      child: Center(
                        child: Text(
                          localizations.translate(
                            i18.householdLocation.actionLabel,
                          ),
                        ),
                      ),
                    );
                  },
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
                              i18.householdLocation.householdLocationLabelText,
                            ),
                            headingStyle: theme.textTheme.displayMedium,
                            body: localizations.translate(
                              i18.householdLocation
                                  .householdLocationDescriptionText,
                            )),
                        Column(children: [
                          householdLocationShowcaseData.administrativeArea
                              .buildWith(
                            child: DigitTextFormField(
                              formControlName: _administrationAreaKey,
                              label: localizations.translate(
                                i18.householdLocation
                                    .administrationAreaFormLabel,
                              ),
                              readOnly: true,
                              isRequired: true,
                              validationMessages: {
                                'required': (_) => localizations.translate(
                                      i18.householdLocation
                                          .administrationAreaRequiredValidation,
                                    ),
                              },
                            ),
                          ),
                          householdLocationShowcaseData.gpsAccuracy.buildWith(
                            child: DigitTextFormField(
                              // suffixString: localizations.translate(
                              //   i18.common.metersLabel,
                              // ),
                              readOnly: true,
                              formControlName: _accuracyKey,
                              label: localizations.translate(
                                  i18.householdLocation.gpsAccuracyLabel),
                              // colorCondition: (value) =>
                              //     value != null && value > 5,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  FormGroup buildForm(BeneficiaryRegistrationState state) {
    final addressModel = state.mapOrNull(
      editHousehold: (value) => value.addressModel,
    );

    return fb.group(<String, Object>{
      _administrationAreaKey: FormControl<String>(
        value: localizations.translate(
            RegistrationDeliverySingleton().boundary!.code.toString()),
        validators: [Validators.required],
      ),
      _latKey: FormControl<double>(value: addressModel?.latitude, validators: [
        CustomValidator.requiredMin,
      ]),
      _lngKey: FormControl<double>(
        value: addressModel?.longitude,
      ),
      _accuracyKey: FormControl<double>(
        value: addressModel?.locationAccuracy,
      ),
    });
  }
}
