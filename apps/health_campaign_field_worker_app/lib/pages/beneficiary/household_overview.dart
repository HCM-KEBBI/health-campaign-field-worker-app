import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/beneficiary_registration/beneficiary_registration.dart';
import '../../blocs/delivery_intervention/deliver_intervention.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/product_variant/product_variant.dart';
import '../../blocs/project/project.dart';
import '../../blocs/search_households/search_households.dart';
import '../../models/data_model.dart';
import '../../models/project_type/project_type_model.dart';
import '../../router/app_router.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/utils.dart';
import '../../widgets/action_card/action_card.dart';
import '../../widgets/component_wrapper/product_variant_bloc_wrapper.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';
import '../../widgets/member_card/member_card.dart';

class HouseholdOverviewPage extends LocalizedStatefulWidget {
  const HouseholdOverviewPage({super.key, super.appLocalizations});

  @override
  State<HouseholdOverviewPage> createState() => _HouseholdOverviewPageState();
}

class _HouseholdOverviewPageState
    extends LocalizedState<HouseholdOverviewPage> {
  @override
  void initState() {
    // final bloc = context.read<HouseholdOverviewBloc>();
    // bloc.add(
    //   HouseholdOverviewReloadEvent(
    //     projectId: context.projectId,
    //     projectBeneficiaryType: context.beneficiaryType,
    //   ),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final beneficiaryType = context.beneficiaryType;

    return ProductVariantBlocWrapper(
      child: BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
        builder: (ctx, state) {
          return Scaffold(
            body: state.loading
                ? const Center(child: CircularProgressIndicator())
                : BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
                    builder: (ctx, state) {
                      if (state.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ScrollableContent(
                        header: const BackNavigationHelpHeaderWidget(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 1.25,
                            child: SingleChildScrollView(
                              child: DigitCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            localizations.translate(
                                              i18.householdOverView
                                                  .householdOverViewLabel,
                                            ),
                                            style:
                                                theme.textTheme.displayMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    BlocBuilder<DeliverInterventionBloc,
                                        DeliverInterventionState>(
                                      builder: (ctx, state) => Offstage(
                                        offstage: beneficiaryType ==
                                            BeneficiaryType.individual,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: DigitIconButton(
                                            icon: state.tasks?.first.status ==
                                                    Status.administeredSuccess
                                                        .toValue()
                                                ? Icons.check_circle
                                                : Icons.info_rounded,
                                            iconText: localizations.translate(
                                              state.tasks?.first.status ==
                                                      Status.administeredSuccess
                                                          .toValue()
                                                  ? i18.householdOverView
                                                      .householdOverViewDeliveredIconLabel
                                                  : i18.householdOverView
                                                      .householdOverViewNotDeliveredIconLabel,
                                            ),
                                            iconTextColor: state
                                                        .tasks?.first.status ==
                                                    Status.administeredSuccess
                                                        .toValue()
                                                ? DigitTheme
                                                    .instance
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                : DigitTheme
                                                    .instance.colorScheme.error,
                                            iconColor: state
                                                        .tasks?.first.status ==
                                                    Status.administeredSuccess
                                                        .toValue()
                                                ? DigitTheme
                                                    .instance
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                : DigitTheme
                                                    .instance.colorScheme.error,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //     left: kPadding,
                                    //     right: kPadding,
                                    //   ),
                                    //   child: Text(
                                    //     localizations.translate(i18
                                    //         .householdOverView
                                    //         .householdOverViewLabel),
                                    //     style: theme.textTheme.displayMedium,
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: kPadding,
                                        right: kPadding,
                                      ),
                                      child: DigitTableCard(
                                        element: {
                                          localizations.translate(i18
                                              .householdOverView
                                              .householdOverViewHouseholdHeadNameLabel): [
                                            state
                                                .householdMemberWrapper
                                                .headOfHousehold
                                                .name
                                                ?.givenName,
                                            state
                                                .householdMemberWrapper
                                                .headOfHousehold
                                                .name
                                                ?.familyName,
                                          ].whereNotNull().join(' '),
                                          localizations.translate(
                                            i18.householdLocation
                                                .administrationAreaFormLabel,
                                          ): state.householdMemberWrapper
                                              .household.address?.addressLine1,
                                          localizations.translate(
                                            i18.deliverIntervention
                                                .memberCountText,
                                          ): state.householdMemberWrapper
                                              .household.memberCount,
                                        },
                                      ),
                                    ),
                                    Column(
                                      children: state
                                          .householdMemberWrapper.members
                                          .map(
                                        (e) {
                                          final isHead = state
                                                  .householdMemberWrapper
                                                  .headOfHousehold
                                                  .clientReferenceId ==
                                              e.clientReferenceId;
                                          final projectBeneficiaryId = state
                                              .householdMemberWrapper
                                              .projectBeneficiaries
                                              .firstWhereOrNull((b) =>
                                                  b.beneficiaryClientReferenceId ==
                                                  e.clientReferenceId)
                                              ?.clientReferenceId;

                                          return BlocBuilder<ProductVariantBloc,
                                              ProductVariantState>(
                                            builder: (context, productState) {
                                              return productState.maybeWhen(
                                                orElse: () => const Offstage(),
                                                fetched:
                                                    (productVariantsvalue) {
                                                  final variant =
                                                      productState.whenOrNull(
                                                    fetched: (productVariants) {
                                                      return productVariants;
                                                    },
                                                  );

                                                  return BlocBuilder<
                                                      ProjectBloc,
                                                      ProjectState>(
                                                    builder: (context,
                                                        projectState) {
                                                      final projectBeneficiary =
                                                          beneficiaryType !=
                                                                  BeneficiaryType
                                                                      .individual
                                                              ? [
                                                                  state
                                                                      .householdMemberWrapper
                                                                      .projectBeneficiaries
                                                                      .first,
                                                                ]
                                                              : state
                                                                  .householdMemberWrapper
                                                                  .projectBeneficiaries
                                                                  .where(
                                                                    (element) =>
                                                                        element
                                                                            .beneficiaryClientReferenceId ==
                                                                        e.clientReferenceId,
                                                                  )
                                                                  .toList();

                                                      final taskdata = state
                                                          .householdMemberWrapper
                                                          .tasks
                                                          ?.where((element) =>
                                                              element
                                                                  .projectBeneficiaryClientReferenceId ==
                                                              projectBeneficiary
                                                                  .first
                                                                  .clientReferenceId)
                                                          .toList();
                                                      final referralData = state
                                                          .householdMemberWrapper
                                                          .referrals
                                                          ?.where((element) =>
                                                              element
                                                                  .projectBeneficiaryClientReferenceId ==
                                                              projectBeneficiary
                                                                  .first
                                                                  .clientReferenceId)
                                                          .toList();
                                                      final sideEffectData = taskdata !=
                                                                  null &&
                                                              taskdata
                                                                  .isNotEmpty
                                                          ? state
                                                              .householdMemberWrapper
                                                              .sideEffects
                                                              ?.where((element) =>
                                                                  element
                                                                      .taskClientReferenceId ==
                                                                  taskdata.last
                                                                      .clientReferenceId)
                                                              .toList()
                                                          : null;
                                                      final ageInYears =
                                                          DigitDateUtils
                                                              .calculateAge(
                                                        DigitDateUtils
                                                                .getFormattedDateToDateTime(
                                                              e.dateOfBirth!,
                                                            ) ??
                                                            DateTime.now(),
                                                      ).years;
                                                      final ageInMonths =
                                                          DigitDateUtils
                                                              .calculateAge(
                                                        DigitDateUtils
                                                                .getFormattedDateToDateTime(
                                                              e.dateOfBirth!,
                                                            ) ??
                                                            DateTime.now(),
                                                      ).months;
                                                      final currentCycle =
                                                          projectState
                                                              .projectType
                                                              ?.cycles
                                                              ?.firstWhereOrNull(
                                                        (e) =>
                                                            (e.startDate!) <
                                                                DateTime.now()
                                                                    .millisecondsSinceEpoch &&
                                                            (e.endDate!) >
                                                                DateTime.now()
                                                                    .millisecondsSinceEpoch,
                                                        // Return null when no matching cycle is found
                                                      );

                                                      final isBeneficiaryRefused =
                                                          checkIfBeneficiaryRefused(
                                                        taskdata,
                                                      );

                                                      final isBeneficiaryIneligible =
                                                          checkIfBeneficiaryIneligible(
                                                        taskdata,
                                                      );

                                                      final isBeneficiaryReferred =
                                                          checkIfBeneficiaryReferred(
                                                        taskdata,
                                                      );

                                                      return MemberCard(
                                                        variant: variant ?? [],
                                                        isHead: isHead,
                                                        individual: e,
                                                        tasks: taskdata,
                                                        sideEffects:
                                                            sideEffectData,
                                                        editMemberAction:
                                                            () async {
                                                          final bloc = ctx.read<
                                                              HouseholdOverviewBloc>();

                                                          Navigator.of(
                                                            context,
                                                            rootNavigator: true,
                                                          ).pop();

                                                          final address =
                                                              e.address;
                                                          if (address == null ||
                                                              address.isEmpty) {
                                                            return;
                                                          }

                                                          final projectId =
                                                              context.projectId;

                                                          await context
                                                              .router.root
                                                              .push(
                                                            BeneficiaryRegistrationWrapperRoute(
                                                              initialState:
                                                                  BeneficiaryRegistrationEditIndividualState(
                                                                individualModel:
                                                                    e,
                                                                householdModel: state
                                                                    .householdMemberWrapper
                                                                    .household,
                                                                addressModel:
                                                                    address
                                                                        .first,
                                                              ),
                                                              children: [
                                                                IndividualDetailsRoute(
                                                                  isHeadOfHousehold:
                                                                      isHead,
                                                                ),
                                                              ],
                                                            ),
                                                          );

                                                          bloc.add(
                                                            HouseholdOverviewReloadEvent(
                                                              projectId:
                                                                  projectId,
                                                              projectBeneficiaryType:
                                                                  beneficiaryType,
                                                            ),
                                                          );
                                                        },
                                                        setAsHeadAction: () {
                                                          ctx
                                                              .read<
                                                                  HouseholdOverviewBloc>()
                                                              .add(
                                                                HouseholdOverviewSetAsHeadEvent(
                                                                  individualModel:
                                                                      e,
                                                                  projectId: ctx
                                                                      .projectId,
                                                                  householdModel: state
                                                                      .householdMemberWrapper
                                                                      .household,
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
                                                            options:
                                                                DigitDialogOptions(
                                                              titlePadding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                kPadding * 2,
                                                                kPadding * 2,
                                                                kPadding * 2,
                                                                kPadding / 2,
                                                              ),
                                                              titleText: localizations
                                                                  .translate(i18
                                                                      .householdOverView
                                                                      .householdOverViewActionCardTitle),
                                                              primaryAction:
                                                                  DigitDialogActions(
                                                                label: localizations
                                                                    .translate(i18
                                                                        .householdOverView
                                                                        .householdOverViewPrimaryActionLabel),
                                                                action: (ctx) {
                                                                  Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true,
                                                                  )
                                                                    ..pop()
                                                                    ..pop();
                                                                  context
                                                                      .read<
                                                                          HouseholdOverviewBloc>()
                                                                      .add(
                                                                        HouseholdOverviewEvent
                                                                            .selectedIndividual(
                                                                          individualModel:
                                                                              e,
                                                                        ),
                                                                      );

                                                                  context.router
                                                                      .popUntilRouteWithName(
                                                                    SearchBeneficiaryRoute
                                                                        .name,
                                                                  );
                                                                  context.router
                                                                      .push(
                                                                    ReasonForDeletionRoute(
                                                                      isHousholdDelete:
                                                                          false,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              secondaryAction:
                                                                  DigitDialogActions(
                                                                label: localizations
                                                                    .translate(i18
                                                                        .householdOverView
                                                                        .householdOverViewSecondaryActionLabel),
                                                                action:
                                                                    (context) {
                                                                  Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true,
                                                                  ).pop();
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        isNotEligible: projectState
                                                                    .projectType
                                                                    ?.cycles !=
                                                                null
                                                            ? !checkEligibilityForAgeAndSideEffect(
                                                                DigitDOBAge(
                                                                  years:
                                                                      ageInYears,
                                                                  months:
                                                                      ageInMonths,
                                                                ),
                                                                projectState
                                                                    .projectType,
                                                                (taskdata ?? [])
                                                                        .isNotEmpty
                                                                    ? taskdata
                                                                        ?.last
                                                                    : null,
                                                                sideEffectData,
                                                              )
                                                            : false,
                                                        name:
                                                            '${e.name?.givenName ?? ' - '} ${e.name?.familyName ?? ' - '}',
                                                        years: (e.dateOfBirth ==
                                                                    null
                                                                ? null
                                                                : DigitDateUtils
                                                                    .calculateAge(
                                                                    DigitDateUtils
                                                                            .getFormattedDateToDateTime(
                                                                          e.dateOfBirth!,
                                                                        ) ??
                                                                        DateTime
                                                                            .now(),
                                                                  ).years) ??
                                                            0,
                                                        months: (e.dateOfBirth ==
                                                                    null
                                                                ? null
                                                                : DigitDateUtils
                                                                    .calculateAge(
                                                                    DigitDateUtils
                                                                            .getFormattedDateToDateTime(
                                                                          e.dateOfBirth!,
                                                                        ) ??
                                                                        DateTime
                                                                            .now(),
                                                                  ).months) ??
                                                            0,
                                                        gender: e.gender?.name,
                                                        isBeneficiaryRefused:
                                                            isBeneficiaryRefused &&
                                                                !checkStatus(
                                                                  taskdata,
                                                                  currentCycle,
                                                                ),
                                                        isBeneficiaryIneligible:
                                                            isBeneficiaryIneligible &&
                                                                !checkStatus(
                                                                  taskdata,
                                                                  currentCycle,
                                                                ),
                                                        isBeneficiaryReferred:
                                                            isBeneficiaryReferred,
                                                        isDelivered: taskdata ==
                                                                null
                                                            ? false
                                                            : taskdata.isNotEmpty &&
                                                                    !checkStatus(
                                                                      taskdata,
                                                                      currentCycle,
                                                                    )
                                                                // TODO Need to pass the cycle
                                                                ? true
                                                                : false,
                                                        localizations:
                                                            localizations,
                                                        projectBeneficiaryClientReferenceId:
                                                            projectBeneficiaryId,
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ).toList(),
                                    ),
                                    Center(
                                      child: DigitIconButton(
                                        onPressed: () async {
                                          final spaq1 = context.spaq1;
                                          final spaq2 = context.spaq2;

                                          if (spaq1 > 0 || spaq2 > 0) {
                                            final bloc = context
                                                .read<HouseholdOverviewBloc>();
                                            final searchBloc = context
                                                .read<SearchHouseholdsBloc>();

                                            final wrapper =
                                                state.householdMemberWrapper;
                                            final address =
                                                wrapper.household.address;

                                            if (address == null) return;

                                            final projectId = context.projectId;

                                            await context.router.push(
                                              BeneficiaryRegistrationWrapperRoute(
                                                initialState:
                                                    BeneficiaryRegistrationAddMemberState(
                                                  addressModel: address,
                                                  householdModel:
                                                      wrapper.household,
                                                ),
                                                children: [
                                                  IndividualDetailsRoute(),
                                                ],
                                              ),
                                            );
                                            bloc.add(
                                              HouseholdOverviewReloadEvent(
                                                projectId: projectId,
                                                projectBeneficiaryType:
                                                    beneficiaryType,
                                              ),
                                            );

                                            searchBloc.add(
                                              SearchHouseholdsByHouseholdsEvent(
                                                householdModel:
                                                    wrapper.household,
                                                projectId: projectId,
                                                isProximityEnabled: false,
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
                                                      .insufficientStockMessageAddMember,
                                                ),
                                                primaryAction:
                                                    DigitDialogActions(
                                                  label: localizations
                                                      .translate(i18
                                                          .beneficiaryDetails
                                                          .backToHome),
                                                  action: (ctx) {
                                                    Navigator.of(
                                                      ctx,
                                                      rootNavigator: true,
                                                    ).pop();
                                                    context.router.replaceAll([
                                                      HomeRoute(),
                                                    ]);
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        },
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
                          ),
                        ],
                      );
                    },
                  ),
            bottomNavigationBar: Offstage(
              offstage: beneficiaryType == BeneficiaryType.individual,
              child: BlocBuilder<DeliverInterventionBloc,
                  DeliverInterventionState>(
                builder: (ctx, state) => DigitCard(
                  margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                  padding: const EdgeInsets.fromLTRB(kPadding, 0, kPadding, 0),
                  child: state.tasks?.first.status ==
                          Status.administeredSuccess.toValue()
                      ? DigitOutLineButton(
                          label: localizations.translate(
                            i18.memberCard.deliverDetailsUpdateLabel,
                          ),
                          onPressed: () async {
                            await context.router
                                .push(BeneficiaryDetailsRoute());
                          },
                        )
                      : DigitElevatedButton(
                          onPressed: () async {
                            final bloc = ctx.read<HouseholdOverviewBloc>();

                            final projectId = context.projectId;

                            bloc.add(
                              HouseholdOverviewReloadEvent(
                                projectId: projectId,
                                projectBeneficiaryType: beneficiaryType,
                              ),
                            );

                            await context.router
                                .push(BeneficiaryDetailsRoute());
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
          );
        },
      ),
    );
  }
}
