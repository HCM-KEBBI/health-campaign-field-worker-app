import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/localization/app_localization.dart';
import '../../blocs/product_variant/product_variant.dart';
import '../../models/data_model.dart';
import '../../models/entities/identifier_types.dart';
import '../../models/project_type/project_type_model.dart';
import '../../router/app_router.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/utils.dart';
import '../action_card/action_card.dart';

class MemberCard extends StatelessWidget {
  final List<ProductVariantModel> variant;
  final String name;
  final String? gender;
  final int years;
  final int months;
  final bool isHead;
  final IndividualModel individual;
  final bool isDelivered;

  final VoidCallback setAsHeadAction;
  final VoidCallback editMemberAction;
  final VoidCallback deleteMemberAction;
  final AppLocalizations localizations;
  final List<TaskModel>? tasks;
  final List<SideEffectModel>? sideEffects;
  final bool isNotEligible;
  final bool isBeneficiaryRefused;
  final bool isBeneficiaryIneligible;
  final bool isBeneficiaryReferred;
  final String? projectBeneficiaryClientReferenceId;

  const MemberCard({
    super.key,
    required this.variant,
    required this.individual,
    required this.name,
    this.gender,
    required this.years,
    this.isHead = false,
    this.months = 0,
    required this.localizations,
    required this.isDelivered,
    required this.setAsHeadAction,
    required this.editMemberAction,
    required this.deleteMemberAction,
    this.tasks,
    this.isNotEligible = false,
    this.projectBeneficiaryClientReferenceId,
    this.isBeneficiaryRefused = false,
    this.isBeneficiaryIneligible = false,
    this.isBeneficiaryReferred = false,
    this.sideEffects,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final beneficiaryType = context.beneficiaryType;
    final doseStatus = checkStatus(tasks, context.selectedCycle);
    final redosePendingStatus = redosePending(tasks);

    return Container(
      decoration: BoxDecoration(
        color: DigitTheme.instance.colorScheme.background,
        border: Border.all(
          color: DigitTheme.instance.colorScheme.outline,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      margin: DigitTheme.instance.containerMargin,
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  individual.identifiers != null
                      ? Padding(
                          padding: const EdgeInsets.all(kPadding),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: DigitTheme.instance.colorScheme.primary,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(kPadding),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                kPadding,
                              ),
                              child: Text(
                                individual.identifiers!
                                        .lastWhere(
                                          (e) =>
                                              e.identifierType ==
                                              IdentifierTypes
                                                  .uniqueBeneficiaryID
                                                  .toValue(),
                                        )
                                        .identifierId ??
                                    localizations
                                        .translate(i18.common.noResultsFound),
                              ),
                            ),
                          ),
                        )
                      : const Offstage(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: kPadding,
                            top: kPadding,
                          ),
                          child: Text(
                            name,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              (tasks ?? [])
                          .where(
                            (element) =>
                                element.status ==
                                Status.administeredSuccess.toValue(),
                          )
                          .lastOrNull ==
                      null
                  ? Positioned(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: DigitIconButton(
                          onPressed: () => DigitActionDialog.show(
                            context,
                            widget: ActionCard(
                              items: [
                                ActionCardModel(
                                  icon: Icons.edit,
                                  label: localizations.translate(
                                    i18.memberCard.editIndividualDetails,
                                  ),
                                  action: editMemberAction,
                                ),
                              ],
                            ),
                          ),
                          iconText: localizations.translate(
                            i18.memberCard.editDetails,
                          ),
                          icon: Icons.edit,
                        ),
                      ),
                    )
                  : const Offstage(),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: DigitTheme.instance.containerMargin,
                  child: Text(
                    gender != null
                        ? localizations
                            .translate('CORE_COMMON_${gender?.toUpperCase()}')
                        : ' - ',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: Text(
                    " | $years ${localizations.translate(i18.memberCard.deliverDetailsYearText)} $months ${localizations.translate(i18.memberCard.deliverDetailsMonthsText)}",
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: kPadding / 2,
            ),
            child: Offstage(
              offstage: beneficiaryType != BeneficiaryType.individual,
              child: !isDelivered ||
                      isNotEligible ||
                      isBeneficiaryRefused ||
                      isBeneficiaryIneligible ||
                      isBeneficiaryReferred
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: DigitIconButton(
                        icon: Icons.info_rounded,
                        iconSize: 20,
                        iconText: localizations.translate(
                          isHead
                              ? i18.householdOverView
                                  .householdOverViewHouseholderHeadLabel
                              : (isNotEligible || isBeneficiaryIneligible)
                                  ? i18.householdOverView
                                      .householdOverViewNotEligibleIconLabel
                                  : isBeneficiaryReferred
                                      ? i18.householdOverView
                                          .householdOverViewBeneficiaryReferredLabel
                                      : isBeneficiaryRefused
                                          ? Status.beneficiaryRefused.toValue()
                                          : Status.notVisited.toValue(),
                        ),
                        iconTextColor: theme.colorScheme.error,
                        iconColor: theme.colorScheme.error,
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: DigitIconButton(
                        icon: Icons.check_circle,
                        iconText: localizations.translate(
                          i18.householdOverView
                              .householdOverViewDeliveredIconLabel,
                        ),
                        iconSize: 20,
                        iconTextColor:
                            DigitTheme.instance.colorScheme.onSurfaceVariant,
                        iconColor:
                            DigitTheme.instance.colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
          ),
          Offstage(
            offstage: beneficiaryType != BeneficiaryType.individual,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: isHead
                  ? const Column(
                      children: [],
                    )
                  : Column(
                      children: [
                        (isNotEligible ||
                                    isBeneficiaryIneligible ||
                                    isBeneficiaryReferred) &&
                                !doseStatus
                            ? const Offstage()
                            : !isNotEligible && redosePendingStatus
                                ? DigitElevatedButton(
                                    child: Center(
                                      child: Text(
                                        allDosesDelivered(
                                                  tasks,
                                                  context.selectedCycle,
                                                  sideEffects,
                                                  individual,
                                                ) &&
                                                !checkStatus(
                                                  tasks,
                                                  context.selectedCycle,
                                                )
                                            ? localizations.translate(
                                                i18.householdOverView
                                                    .viewDeliveryLabel,
                                              )
                                            : (tasks ?? []).isEmpty
                                                ? localizations.translate(
                                                    i18.householdOverView
                                                        .householdOverViewAssessmentActionText,
                                                  )
                                                : localizations.translate(
                                                    i18.householdOverView
                                                        .householdOverViewRedoseActionText,
                                                  ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final bloc =
                                          context.read<HouseholdOverviewBloc>();
                                      bloc.add(
                                        HouseholdOverviewReloadEvent(
                                          projectId: context.projectId,
                                          projectBeneficiaryType:
                                              beneficiaryType,
                                        ),
                                      );
                                      bloc.add(
                                        HouseholdOverviewEvent
                                            .selectedIndividual(
                                          individualModel: individual,
                                        ),
                                      );

                                      // todo: verify this

                                      if ((tasks ?? []).isEmpty) {
                                        context.router.push(
                                          EligibilityChecklistViewRoute(
                                            projectBeneficiaryClientReferenceId:
                                                projectBeneficiaryClientReferenceId,
                                            individual: individual,
                                          ),
                                        );
                                      } else {
                                        var successfulTask = tasks!
                                            .where(
                                              (element) =>
                                                  element.status ==
                                                  Status.administeredSuccess
                                                      .toValue(),
                                            )
                                            .lastOrNull;
                                        if (redosePendingStatus) {
                                          final spaq1 = context.spaq1;
                                          final spaq2 = context.spaq2;

                                          final value = variant
                                              .firstWhere(
                                                (element) =>
                                                    element.id ==
                                                    successfulTask!.resources!
                                                        .first.productVariantId,
                                              )
                                              .sku;

                                          if (value == null ||
                                              (value.contains(
                                                    Constants.spaq1String,
                                                  ) &&
                                                  spaq1 >= 2) ||
                                              (!value.contains(
                                                    Constants.spaq1String,
                                                  ) &&
                                                  spaq2 >= 2)) {
                                            context.router.push(
                                              RecordRedoseRoute(
                                                tasks: [successfulTask!],
                                              ),
                                            );
                                          } else {
                                            DigitDialog.show(
                                              context,
                                              options: DigitDialogOptions(
                                                titleText:
                                                    localizations.translate(
                                                  i18.beneficiaryDetails
                                                      .insufficientStockHeading,
                                                ),
                                                titleIcon: Icon(
                                                  Icons.warning,
                                                  color: DigitTheme.instance
                                                      .colorScheme.error,
                                                ),
                                                contentText:
                                                    localizations.translate(
                                                  i18.beneficiaryDetails
                                                      .insufficientStockMessageDelivery,
                                                ),
                                                primaryAction:
                                                    DigitDialogActions(
                                                  label: localizations
                                                      .translate(i18
                                                          .beneficiaryDetails
                                                          .backToHouseholdDetails),
                                                  action: (ctx) {
                                                    Navigator.of(
                                                      context,
                                                      rootNavigator: true,
                                                    ).pop();
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          context.router.push(
                                            BeneficiaryDetailsRoute(),
                                          );
                                        }
                                      }
                                    },
                                  )
                                : const Offstage(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
