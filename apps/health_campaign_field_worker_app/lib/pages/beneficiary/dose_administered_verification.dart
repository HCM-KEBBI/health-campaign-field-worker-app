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
import '../../models/entities/identifier_types.dart';
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
                      ('${state.selectedIndividual?.name?.familyName ?? "-"}'
                              " "
                              '${state.selectedIndividual?.name?.givenName ?? "-"}')
                          .toString();

                  // todo verify quantityDistributed

                  var quantity = deliveryInterventionstate
                          .oldTask?.resources?.first.quantity ??
                      0;

                  var beneficiaryId = state.selectedIndividual?.identifiers
                          ?.lastWhere(
                            (e) =>
                                e.identifierType ==
                                IdentifierTypes.uniqueBeneficiaryID.toValue(),
                          )
                          .identifierId ??
                      localizations.translate(
                        i18.common.noResultsFound,
                      );

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
                                    {'{}': quantity.toString()},
                                    theme,
                                  ),
                                  _buildTextRow(
                                    ("2. ${localizations.translate(
                                      i18.deliverIntervention
                                          .infoWrittenInChildCard,
                                    )}"),
                                    {
                                      '()': beneficiaryName,
                                      '{}': beneficiaryId,
                                    },
                                    theme,
                                  ),
                                  _buildTextRow(
                                    "3. ${localizations.translate(
                                      i18.deliverIntervention
                                          .healthTalkGivenOnSPAQ,
                                    )}",
                                    {},
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

  Widget _buildTextRow(
    String text,
    Map<String, String> replacements,
    ThemeData theme,
  ) {
    List<TextSpan> textSpans = _createTextSpans(text, replacements, theme);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kPadding,
        kPadding * 2,
        kPadding,
        kPadding * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontStyle: theme.textTheme.bodyLarge!.fontStyle,
                      fontWeight: theme.textTheme.bodyLarge!.fontWeight,
                      letterSpacing: theme.textTheme.bodyLarge!.letterSpacing,
                      fontSize: 18,
                      color: theme.textTheme.bodyLarge!.color,
                    ),
                    children: textSpans,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<TextSpan> _createTextSpans(
    String text,
    Map<String, String> replacements,
    ThemeData theme,
  ) {
    final spans = <TextSpan>[];
    int start = 0;

    while (start < text.length) {
      int minIndex = text.length;
      String? foundPlaceholder;

      // Find the next placeholder in the text
      for (final placeholder in replacements.keys) {
        final index = text.indexOf(placeholder, start);
        if (index != -1 && index < minIndex) {
          minIndex = index;
          foundPlaceholder = placeholder;
        }
      }

      if (foundPlaceholder != null) {
        final placeholderIndex = text.indexOf(foundPlaceholder, start);

        // Add text before the placeholder
        if (placeholderIndex > start) {
          spans.add(TextSpan(text: text.substring(start, placeholderIndex)));
        }

        // Add the replacement text with styling
        spans.add(TextSpan(
          text: replacements[foundPlaceholder],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));

        // Update the start index
        start = placeholderIndex + foundPlaceholder.length;
      } else {
        // No more placeholders, add the rest of the text
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
    }

    return spans;
  }

  FormGroup buildForm(BuildContext context) {
    return fb.group(<String, Object>{});
  }
}
