import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/beneficiary_registration/beneficiary_registration.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/search_households/search_households.dart';
import '../../models/entities/household.dart';
import '../../models/entities/household_member.dart';
import '../../models/entities/individual.dart';
import '../../models/entities/project_beneficiary.dart';
import '../../models/entities/referral.dart';
import '../../models/entities/side_effect.dart';
import '../../models/entities/task.dart';
import '../../utils/extensions/extensions.dart';
import '../../utils/registration_delivery_singleton.dart';

class BeneficiaryRegistrationWrapperPage extends StatelessWidget
    implements AutoRouteWrapper {
  final BeneficiaryRegistrationState initialState;

  const BeneficiaryRegistrationWrapperPage({
    super.key,
    required this.initialState,
  });

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    final beneficiaryType = RegistrationDeliverySingleton().beneficiaryType;
    final individual =
        context.repository<IndividualModel, IndividualSearchModel>();

    final household =
        context.repository<HouseholdModel, HouseholdSearchModel>();

    final householdMember =
        context.repository<HouseholdMemberModel, HouseholdMemberSearchModel>();

    final projectBeneficiary = context
        .repository<ProjectBeneficiaryModel, ProjectBeneficiarySearchModel>();
    final task = context.repository<TaskModel, TaskSearchModel>();
    final sideEffect =
        context.repository<SideEffectModel, SideEffectSearchModel>();
    final referral = context.repository<ReferralModel, ReferralSearchModel>();

    return BlocProvider(
      create: (_) => HouseholdOverviewBloc(
        HouseholdOverviewState(
          householdMemberWrapper: HouseholdMemberWrapper(
            household: initialState.householdModel!,
            headOfHousehold: initialState.maybeWhen(
                orElse: () => null,
                editHousehold: (addressModel,
                        householdModel,
                        individualModel,
                        registrationDate,
                        projectBeneficiaryModel,
                        loading,
                        headOfHousehold) =>
                    headOfHousehold!),
            members: initialState.maybeWhen(
              orElse: () => null,
              editHousehold: (addressModel,
                      householdModel,
                      individualModel,
                      registrationDate,
                      projectBeneficiaryModel,
                      loading,
                      headOfHousehold) =>
                  individualModel,
            ),
            projectBeneficiaries: initialState.maybeWhen(
              orElse: () => null,
              editHousehold: (addressModel,
                      householdModel,
                      individualModel,
                      registrationDate,
                      projectBeneficiaryModel,
                      loading,
                      headOfHousehold) =>
                  projectBeneficiaryModel != null
                      ? [projectBeneficiaryModel]
                      : [],
            ),
          ),
        ),
        individualRepository: individual,
        householdRepository: household,
        householdMemberRepository: householdMember,
        projectBeneficiaryRepository: projectBeneficiary,
        beneficiaryType: RegistrationDeliverySingleton().beneficiaryType!,
        taskDataRepository: task,
        sideEffectDataRepository: sideEffect,
        referralDataRepository: referral,
      )..add(HouseholdOverviewReloadEvent(
          projectId: RegistrationDeliverySingleton().selectedProject!.id,
          projectBeneficiaryType:
              RegistrationDeliverySingleton().beneficiaryType!,
        )),
      child: BlocProvider(
        create: (context) => BeneficiaryRegistrationBloc(
          initialState,
          individualRepository: individual,
          householdRepository: household,
          householdMemberRepository: householdMember,
          projectBeneficiaryRepository: projectBeneficiary,
          taskDataRepository: task,
          beneficiaryType: beneficiaryType!,
        ),
        child: this,
      ),
    );
  }
}
