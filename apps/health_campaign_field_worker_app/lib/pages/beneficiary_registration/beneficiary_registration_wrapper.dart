import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/beneficiary_registration/beneficiary_registration.dart';
import '../../models/data_model.dart';
import '../../utils/extensions/extensions.dart';
import '../../utils/typedefs.dart';
import '../../widgets/boundary_selection_wrapper.dart';

class BeneficiaryRegistrationWrapperPage extends StatelessWidget
    with AutoRouteWrapper {
  final BeneficiaryRegistrationState initialState;

  const BeneficiaryRegistrationWrapperPage({
    Key? key,
    required this.initialState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BoundarySelectionWrapper(child: AutoRouter());
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    final beneficiaryType = context.beneficiaryType;
    final individual =
        context.repository<IndividualModel, IndividualSearchModel>();

    final household =
        context.repository<HouseholdModel, HouseholdSearchModel>();

    final householdMember =
        context.repository<HouseholdMemberModel, HouseholdMemberSearchModel>();

    final projectBeneficiary = context
        .repository<ProjectBeneficiaryModel, ProjectBeneficiarySearchModel>();

    final taskDataRepository = context.repository<TaskModel, TaskSearchModel>();

    return BlocProvider(
      create: (context) => BeneficiaryRegistrationBloc(
        initialState,
        individualRepository: individual,
        householdRepository: household,
        householdMemberRepository: householdMember,
        projectBeneficiaryRepository: projectBeneficiary,
        beneficiaryType: beneficiaryType,
        taskDataRepository: taskDataRepository,
      ),
      child: this,
    );
  }
}
