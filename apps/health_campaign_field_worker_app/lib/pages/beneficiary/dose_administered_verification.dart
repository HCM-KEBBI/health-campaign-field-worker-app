import 'package:digit_components/models/digit_table_model.dart';
import 'package:digit_components/theme/digit_theme.dart';
import 'package:digit_components/widgets/atoms/digit_radio_button_list.dart';
import 'package:digit_components/widgets/digit_card.dart';
import 'package:digit_components/widgets/digit_elevated_button.dart';
import 'package:digit_components/widgets/molecules/digit_table.dart';
import 'package:digit_components/widgets/molecules/digit_table_card.dart';
import 'package:digit_components/widgets/scrollable_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../utils/i18_key_constants.dart' as i18;
import '../../blocs/delivery_intervention/deliver_intervention.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/localization/app_localization.dart';
import '../../blocs/product_variant/product_variant.dart';
import '../../models/data_model.dart';
import '../../router/app_router.dart';
import '../../utils/environment_config.dart';
import '../../utils/utils.dart';
import '../../widgets/component_wrapper/product_variant_bloc_wrapper.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';

class DoseAdministeredVerificationPage extends LocalizedStatefulWidget {
  const DoseAdministeredVerificationPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<DoseAdministeredVerificationPage> createState() =>
      _DoseAdministeredVerificationPageState();
}

class _DoseAdministeredVerificationPageState
    extends LocalizedState<DoseAdministeredVerificationPage> {
  bool doseAdministered = true;
  bool formSubmitted = false;

  final clickedStatus = ValueNotifier<bool>(false);

  @override
  void dispose() {
    clickedStatus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final overViewBloc = context.read<HouseholdOverviewBloc>().state;
    // Define a list of TableHeader objects for the header of a table

    return ProductVariantBlocWrapper(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
            builder: (context, state) {
              return BlocBuilder<DeliverInterventionBloc,
                  DeliverInterventionState>(
                builder: (context, deliveryInterventionstate) {
                  var beneficiaryName =
                      state.selectedIndividual?.fatherName.toString() ?? "";
                  // todo add quantityDistributed

                  return ReactiveFormBuilder(
                    form: () => buildForm(context),
                    builder: (context, form, child) => ScrollableContent(
                      enableFixedButton: true,
                      header: const Column(children: [
                        BackNavigationHelpHeaderWidget(
                          showBackNavigation: false,
                          showHelp: false,
                        ),
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
                                      form.markAllAsTouched();

                                      if (!form.valid)
                                        return;
                                      else {
                                        clickedStatus.value = true;
                                        final bloc = context
                                            .read<DeliverInterventionBloc>()
                                            .state;
                                        final event = context
                                            .read<DeliverInterventionBloc>();

                                        final reloadState = context
                                            .read<HouseholdOverviewBloc>();

                                        Future.delayed(
                                          const Duration(milliseconds: 1000),
                                          () {
                                            reloadState.add(
                                              HouseholdOverviewReloadEvent(
                                                projectId: context.projectId,
                                                projectBeneficiaryType:
                                                    context.beneficiaryType,
                                              ),
                                            );
                                          },
                                        ).then((value) =>
                                            context.router.popAndPush(
                                              HouseholdAcknowledgementRoute(
                                                enableViewHousehold: true,
                                              ),
                                            ));
                                      }
                                    },
                              child: Center(
                                child: Text(
                                  localizations
                                      .translate(i18.common.coreCommonNext),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      children: [
                        DigitCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(kPadding),
                                child: Text(
                                  localizations.translate(
                                    i18.deliverIntervention
                                        .wasTheDoseAdministered,
                                  ),
                                  style: theme.textTheme.headlineLarge,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  _buildTextRow(
                                    "1. ${localizations.translate(
                                      i18.deliverIntervention
                                          .doseGivenCareGiver,
                                    )}",
                                    theme,
                                  ),
                                  _buildTextRow(
                                    ("2. ${localizations.translate(
                                      i18.deliverIntervention
                                          .infoWrittenInChildCard,
                                    )}")
                                        .replaceFirst('()', beneficiaryName),
                                    theme,
                                  ),
                                  _buildTextRow(
                                    "3. ${localizations.translate(
                                      i18.deliverIntervention
                                          .healthTalkGivenOnSPAQ,
                                    )}",
                                    theme,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextRow(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kPadding * 2,
        kPadding * 2,
        kPadding * 2,
        kPadding * 2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontStyle: theme.textTheme.bodyLarge!.fontStyle,
                fontWeight: theme.textTheme.bodyLarge!.fontWeight,
                letterSpacing: theme.textTheme.bodyLarge!.letterSpacing,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  FormGroup buildForm(BuildContext context) {
    return fb.group(<String, Object>{});
  }
}
