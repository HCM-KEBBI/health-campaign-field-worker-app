import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:registration_delivery/blocs/beneficiary_registration/beneficiary_registration.dart';
import 'package:registration_delivery/blocs/delivery_intervention/deliver_intervention.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:registration_delivery/blocs/search_households/search_bloc_common_wrapper.dart';
import 'package:registration_delivery/blocs/search_households/search_households.dart';
import 'package:registration_delivery/models/entities/household.dart';
import '../../models/entities/status.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/utils/utils.dart';
import '../../widgets/action_card/action_card.dart';
import 'package:registration_delivery/widgets/back_navigation_help_header.dart';
import 'package:registration_delivery/widgets/localized.dart';
import 'package:registration_delivery/widgets/member_card/member_card.dart';

@RoutePage()
class CustomHouseholdOverviewPage extends LocalizedStatefulWidget {
  const CustomHouseholdOverviewPage({super.key, super.appLocalizations});

  @override
  State<CustomHouseholdOverviewPage> createState() =>
      _CustomHouseholdOverviewPageState();
}

class _CustomHouseholdOverviewPageState
    extends LocalizedState<CustomHouseholdOverviewPage> {
  @override
  void initState() {
    final bloc = context.read<HouseholdOverviewBloc>();
    bloc.add(
      HouseholdOverviewReloadEvent(
        projectId: RegistrationDeliverySingleton().projectId!,
        projectBeneficiaryType:
            RegistrationDeliverySingleton().beneficiaryType!,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final beneficiaryType = RegistrationDeliverySingleton().beneficiaryType!;

    return PopScope(
      onPopInvoked: (didPop) async {
        context
            .read<SearchBlocWrapper>()
            .searchHouseholdsBloc
            .add(const SearchHouseholdsClearEvent());
        context.router.maybePop();
      },
      child: BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
        builder: (ctx, state) {
          return Scaffold(
            body: state.loading
                ? const Center(child: CircularProgressIndicator())
                : ScrollableContent(
                    header: BackNavigationHelpHeaderWidget(
                      handleBack: () {
                        context
                            .read<SearchBlocWrapper>()
                            .searchHouseholdsBloc
                            .add(const SearchHouseholdsClearEvent());
                      },
                    ),
                    enableFixedButton: true,
                    footer: Offstage(
                      offstage: beneficiaryType == BeneficiaryType.individual,
                      child: BlocBuilder<DeliverInterventionBloc,
                          DeliverInterventionState>(
                        builder: (ctx, deliverInterventionState) => DigitCard(
                          margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                          padding: const EdgeInsets.fromLTRB(
                              kPadding, 0, kPadding, 0),
                          child: deliverInterventionState.tasks?.first.status ==
                                  Status.administeredSuccess.toValue()
                              ? DigitOutLineButton(
                                  label: localizations.translate(
                                    i18.memberCard.deliverDetailsUpdateLabel,
                                  ),
                                  onPressed: () async {
                                    await context.router
                                        .push(BeneficiaryChecklistRoute());
                                  },
                                )
                              : DigitElevatedButton(
                                  onPressed: (state.householdMemberWrapper
                                                  .projectBeneficiaries ??
                                              [])
                                          .isEmpty
                                      ? null
                                      : () async {
                                          final bloc =
                                              ctx.read<HouseholdOverviewBloc>();

                                          final projectId =
                                              RegistrationDeliverySingleton()
                                                  .projectId!;

                                          bloc.add(
                                            HouseholdOverviewReloadEvent(
                                              projectId: projectId,
                                              projectBeneficiaryType:
                                                  beneficiaryType,
                                            ),
                                          );

                                          await context.router.push(
                                              BeneficiaryChecklistRoute());
                                        },
                                  child: Center(
                                    child: Text(
                                      localizations.translate(
                                        i18.householdOverView
                                            .householdOverViewActionText,
                                      ),
                                    ),
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
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: kPadding,
                                        right: kPadding,
                                      ),
                                      child: Text(
                                        localizations.translate(i18
                                            .householdOverView
                                            .householdOverViewLabel),
                                        style: theme.textTheme.displayMedium,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: DigitIconButton(
                                        onPressed: () {
                                          final projectId =
                                              RegistrationDeliverySingleton()
                                                  .projectId!;

                                          final bloc = context
                                              .read<HouseholdOverviewBloc>();
                                          bloc.add(
                                            HouseholdOverviewReloadEvent(
                                              projectId: projectId,
                                              projectBeneficiaryType:
                                                  beneficiaryType,
                                            ),
                                          );
                                          DigitActionDialog.show(
                                            context,
                                            widget: ActionCard(
                                              items: [
                                                ActionCardModel(
                                                  icon: Icons.edit,
                                                  label:
                                                      localizations.translate(
                                                    i18.householdOverView
                                                        .householdOverViewEditLabel,
                                                  ),
                                                  action: () async {
                                                    Navigator.of(
                                                      context,
                                                      rootNavigator: true,
                                                    ).pop();

                                                    HouseholdMemberWrapper
                                                        wrapper = state
                                                            .householdMemberWrapper;

                                                    final timestamp = wrapper
                                                        .headOfHousehold
                                                        ?.clientAuditDetails
                                                        ?.createdTime;
                                                    final date = DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                      timestamp ??
                                                          DateTime.now()
                                                              .millisecondsSinceEpoch,
                                                    );

                                                    final address = wrapper
                                                        .household?.address;

                                                    if (address == null) return;

                                                    final projectBeneficiary = state
                                                        .householdMemberWrapper
                                                        .projectBeneficiaries
                                                        ?.firstWhereOrNull(
                                                      (element) =>
                                                          element
                                                              .beneficiaryClientReferenceId ==
                                                          wrapper.household
                                                              ?.clientReferenceId,
                                                    );

                                                    await context.router.root
                                                        .push(
                                                      BeneficiaryRegistrationWrapperRoute(
                                                        initialState:
                                                            BeneficiaryRegistrationEditHouseholdState(
                                                          addressModel: address,
                                                          individualModel: state
                                                                  .householdMemberWrapper
                                                                  .members ??
                                                              [],
                                                          householdModel: state
                                                              .householdMemberWrapper
                                                              .household!,
                                                          registrationDate:
                                                              date,
                                                          projectBeneficiaryModel:
                                                              projectBeneficiary,
                                                        ),
                                                        children: [
                                                          HouseholdLocationRoute(),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        iconText: localizations.translate(
                                          i18.householdOverView
                                              .householdOverViewEditIconText,
                                        ),
                                        icon: Icons.edit,
                                      ),
                                    ),
                                  ]),
                              BlocBuilder<DeliverInterventionBloc,
                                  DeliverInterventionState>(
                                builder: (ctx, deliverInterventionState) =>
                                    Offstage(
                                  offstage: beneficiaryType ==
                                      BeneficiaryType.individual,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: DigitIconButton(
                                      icon: getStatusAttributes(state,
                                          deliverInterventionState)['icon'],
                                      iconText: localizations.translate(
                                        getStatusAttributes(state,
                                                deliverInterventionState)[
                                            'textLabel'],
                                      ), // [TODO: map task status accordingly based on projectBeneficiaries and tasks]
                                      iconTextColor: getStatusAttributes(state,
                                          deliverInterventionState)['color'],
                                      iconColor: getStatusAttributes(state,
                                          deliverInterventionState)['color'],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: kPadding,
                                  right: kPadding,
                                ),
                                child: DigitTableCard(
                                  element: {
                                    localizations.translate(i18
                                            .householdOverView
                                            .householdOverViewHouseholdHeadNameLabel):
                                        state.householdMemberWrapper
                                            .headOfHousehold?.name?.givenName,
                                    localizations.translate(
                                      i18.householdLocation
                                          .administrationAreaFormLabel,
                                    ): RegistrationDeliverySingleton()
                                        .boundary
                                        ?.name,
                                    localizations.translate(
                                      i18.deliverIntervention.memberCountText,
                                    ): state.householdMemberWrapper.household
                                        ?.memberCount,
                                  },
                                ),
                              ),
                              Column(
                                children:
                                    (state.householdMemberWrapper.members ?? [])
                                        .map(
                                  (e) {
                                    final isHead = state
                                            .householdMemberWrapper
                                            .headOfHousehold
                                            ?.clientReferenceId ==
                                        e.clientReferenceId;
                                    final projectBeneficiaryId = state
                                        .householdMemberWrapper
                                        .projectBeneficiaries
                                        ?.firstWhereOrNull((b) =>
                                            b.beneficiaryClientReferenceId ==
                                            e.clientReferenceId)
                                        ?.clientReferenceId;

                                    final projectBeneficiary =
                                        beneficiaryType !=
                                                BeneficiaryType.individual
                                            ? [
                                                state
                                                    .householdMemberWrapper
                                                    .projectBeneficiaries!
                                                    .first,
                                              ]
                                            : state.householdMemberWrapper
                                                .projectBeneficiaries
                                                ?.where(
                                                  (element) =>
                                                      element
                                                          .beneficiaryClientReferenceId ==
                                                      e.clientReferenceId,
                                                )
                                                .toList();

                                    final taskData = (projectBeneficiary ?? [])
                                            .isNotEmpty
                                        ? state.householdMemberWrapper.tasks
                                            ?.where((element) =>
                                                element
                                                    .projectBeneficiaryClientReferenceId ==
                                                projectBeneficiary
                                                    ?.first.clientReferenceId)
                                            .toList()
                                        : null;
                                    final referralData = (projectBeneficiary ??
                                                [])
                                            .isNotEmpty
                                        ? state.householdMemberWrapper.referrals
                                            ?.where((element) =>
                                                element
                                                    .projectBeneficiaryClientReferenceId ==
                                                projectBeneficiary
                                                    ?.first.clientReferenceId)
                                            .toList()
                                        : null;
                                    final sideEffectData = taskData != null &&
                                            taskData.isNotEmpty
                                        ? state
                                            .householdMemberWrapper.sideEffects
                                            ?.where((element) =>
                                                element.taskClientReferenceId ==
                                                taskData.last.clientReferenceId)
                                            .toList()
                                        : null;
                                    final ageInYears =
                                        DigitDateUtils.calculateAge(
                                      DigitDateUtils.getFormattedDateToDateTime(
                                            e.dateOfBirth!,
                                          ) ??
                                          DateTime.now(),
                                    ).years;
                                    final ageInMonths =
                                        DigitDateUtils.calculateAge(
                                      DigitDateUtils.getFormattedDateToDateTime(
                                            e.dateOfBirth!,
                                          ) ??
                                          DateTime.now(),
                                    ).months;
                                    final currentCycle =
                                        RegistrationDeliverySingleton()
                                            .projectType
                                            ?.cycles
                                            ?.firstWhereOrNull(
                                              (e) =>
                                                  (e.startDate) <
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch &&
                                                  (e.endDate) >
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch,
                                            );

                                    final isBeneficiaryRefused =
                                        checkIfBeneficiaryRefused(
                                      taskData,
                                    );
                                    final isBeneficiaryReferred =
                                        checkIfBeneficiaryReferred(
                                      referralData,
                                      currentCycle,
                                    );

                                    return MemberCard(
                                      isHead: isHead,
                                      individual: e,
                                      projectBeneficiaries:
                                          projectBeneficiary ?? [],
                                      tasks: taskData,
                                      sideEffects: sideEffectData,
                                      editMemberAction: () async {
                                        final bloc =
                                            ctx.read<HouseholdOverviewBloc>();

                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();

                                        final address = e.address;
                                        if (address == null ||
                                            address.isEmpty) {
                                          return;
                                        }

                                        final projectId =
                                            RegistrationDeliverySingleton()
                                                .projectId!;
                                        bloc.add(
                                          HouseholdOverviewReloadEvent(
                                            projectId: projectId,
                                            projectBeneficiaryType:
                                                beneficiaryType,
                                          ),
                                        );

                                        await context.router.root.push(
                                          BeneficiaryRegistrationWrapperRoute(
                                            initialState:
                                                BeneficiaryRegistrationEditIndividualState(
                                              individualModel: e,
                                              householdModel: state
                                                  .householdMemberWrapper
                                                  .household!,
                                              addressModel: address.first,
                                              projectBeneficiaryModel: state
                                                  .householdMemberWrapper
                                                  .projectBeneficiaries
                                                  ?.firstWhereOrNull(
                                                (element) =>
                                                    element
                                                        .beneficiaryClientReferenceId ==
                                                    (RegistrationDeliverySingleton()
                                                                .beneficiaryType ==
                                                            BeneficiaryType
                                                                .individual
                                                        ? e.clientReferenceId
                                                        : state
                                                            .householdMemberWrapper
                                                            .household
                                                            ?.clientReferenceId),
                                              ),
                                            ),
                                            children: [
                                              IndividualDetailsRoute(
                                                isHeadOfHousehold: isHead,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      setAsHeadAction: () {
                                        ctx.read<HouseholdOverviewBloc>().add(
                                              HouseholdOverviewSetAsHeadEvent(
                                                individualModel: e,
                                                projectId:
                                                    RegistrationDeliverySingleton()
                                                        .projectId!,
                                                householdModel: state
                                                    .householdMemberWrapper
                                                    .household!,
                                                projectBeneficiaryType:
                                                    beneficiaryType,
                                              ),
                                            );

                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();
                                      },
                                      deleteMemberAction: () {
                                        DigitDialog.show(
                                          context,
                                          options: DigitDialogOptions(
                                            titlePadding:
                                                const EdgeInsets.fromLTRB(
                                              kPadding * 2,
                                              kPadding * 2,
                                              kPadding * 2,
                                              kPadding / 2,
                                            ),
                                            titleText: localizations.translate(i18
                                                .householdOverView
                                                .householdOverViewActionCardTitle),
                                            primaryAction: DigitDialogActions(
                                              label: localizations.translate(i18
                                                  .householdOverView
                                                  .householdOverViewPrimaryActionLabel),
                                              action: (ctx) {
                                                Navigator.of(
                                                  context,
                                                  rootNavigator: true,
                                                )
                                                  ..pop()
                                                  ..pop();
                                                context
                                                    .read<
                                                        HouseholdOverviewBloc>()
                                                    .add(
                                                      HouseholdOverviewEvent
                                                          .selectedIndividual(
                                                        individualModel: e,
                                                      ),
                                                    );

                                                context.router
                                                    .popUntilRouteWithName(
                                                  SearchBeneficiaryRoute.name,
                                                );
                                                context.router.push(
                                                  ReasonForDeletionRoute(
                                                    isHousholdDelete: false,
                                                  ),
                                                );
                                              },
                                            ),
                                            secondaryAction: DigitDialogActions(
                                              label: localizations.translate(i18
                                                  .householdOverView
                                                  .householdOverViewSecondaryActionLabel),
                                              action: (context) {
                                                Navigator.of(
                                                  context,
                                                  rootNavigator: true,
                                                ).pop();
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      isNotEligible: RegistrationDeliverySingleton()
                                                  .projectType
                                                  ?.cycles !=
                                              null
                                          ? !checkEligibilityForAgeAndSideEffect(
                                              DigitDOBAge(
                                                years: ageInYears,
                                                months: ageInMonths,
                                              ),
                                              RegistrationDeliverySingleton()
                                                  .projectType,
                                              (taskData ?? []).isNotEmpty
                                                  ? taskData?.last
                                                  : null,
                                              sideEffectData,
                                            )
                                          : false,
                                      name: e.name?.givenName ?? ' - ',
                                      years: (e.dateOfBirth == null
                                              ? null
                                              : DigitDateUtils.calculateAge(
                                                  DigitDateUtils
                                                          .getFormattedDateToDateTime(
                                                        e.dateOfBirth!,
                                                      ) ??
                                                      DateTime.now(),
                                                ).years) ??
                                          0,
                                      months: (e.dateOfBirth == null
                                              ? null
                                              : DigitDateUtils.calculateAge(
                                                  DigitDateUtils
                                                          .getFormattedDateToDateTime(
                                                        e.dateOfBirth!,
                                                      ) ??
                                                      DateTime.now(),
                                                ).months) ??
                                          0,
                                      gender: e.gender?.name,
                                      isBeneficiaryRefused:
                                          isBeneficiaryRefused &&
                                              !checkStatus(
                                                taskData,
                                                currentCycle,
                                              ),
                                      isBeneficiaryReferred:
                                          isBeneficiaryReferred,
                                      isDelivered: taskData == null
                                          ? false
                                          : taskData.isNotEmpty &&
                                                  !checkStatus(
                                                    taskData,
                                                    currentCycle,
                                                  )
                                              ? true
                                              : false,
                                      localizations: localizations,
                                      projectBeneficiaryClientReferenceId:
                                          projectBeneficiaryId,
                                    );
                                  },
                                ).toList(),
                              ),
                              const SizedBox(
                                height: kPadding,
                              ),
                              Center(
                                child: DigitIconButton(
                                  onPressed: () => addIndividual(
                                    context,
                                    state.householdMemberWrapper.household!,
                                  ),
                                  iconText: localizations.translate(
                                    i18.householdOverView
                                        .householdOverViewAddActionText,
                                  ),
                                  icon: Icons.add_circle,
                                ),
                              ),
                              const SizedBox(
                                height: kPadding,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  addIndividual(BuildContext context, HouseholdModel household) async {
    final bloc = context.read<HouseholdOverviewBloc>();

    final address = household.address;

    if (address == null) return;
    bloc.add(
      HouseholdOverviewReloadEvent(
        projectId: RegistrationDeliverySingleton().projectId!,
        projectBeneficiaryType:
            RegistrationDeliverySingleton().beneficiaryType!,
      ),
    );
    await context.router.push(
      BeneficiaryRegistrationWrapperRoute(
        initialState: BeneficiaryRegistrationAddMemberState(
          addressModel: address,
          householdModel: household,
        ),
        children: [
          IndividualDetailsRoute(),
        ],
      ),
    );
  }

  getStatusAttributes(HouseholdOverviewState state,
      DeliverInterventionState deliverInterventionState) {
    var textLabel =
        i18.householdOverView.householdOverViewNotRegisteredIconLabel;
    var color = DigitTheme.instance.colorScheme.error;
    var icon = Icons.info_rounded;

    if ((state.householdMemberWrapper.projectBeneficiaries ?? []).isNotEmpty) {
      textLabel = deliverInterventionState.tasks?.isNotEmpty ?? false
          ? (deliverInterventionState.tasks?.first.status ==
                  Status.administeredSuccess.toValue()
              ? i18.householdOverView.householdOverViewDeliveredIconLabel
              : i18.householdOverView.householdOverViewNotDeliveredIconLabel)
          : i18.householdOverView.householdOverViewRegisteredIconLabel;

      color = deliverInterventionState.tasks?.isNotEmpty ?? false
          ? (deliverInterventionState.tasks?.first.status ==
                  Status.administeredSuccess.toValue()
              ? DigitTheme.instance.colorScheme.onSurfaceVariant
              : DigitTheme.instance.colorScheme.error)
          : DigitTheme.instance.colorScheme.onSurfaceVariant;

      icon = deliverInterventionState.tasks?.isNotEmpty ?? false
          ? (deliverInterventionState.tasks?.first.status ==
                  Status.administeredSuccess.toValue()
              ? Icons.check_circle
              : Icons.info_rounded)
          : Icons.check_circle;
    } else {
      textLabel = i18.householdOverView.householdOverViewNotRegisteredIconLabel;
      color = DigitTheme.instance.colorScheme.error;
      icon = Icons.info_rounded;
    }

    return {'textLabel': textLabel, 'color': color, 'icon': icon};
  }
}