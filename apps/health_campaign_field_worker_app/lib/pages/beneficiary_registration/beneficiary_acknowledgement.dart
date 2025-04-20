import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/i18_key_constants.dart' as i18;

import '../../../router/app_router.dart';
import '../../../utils/environment_config.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/search_households/search_households.dart';
import '../../blocs/wrapper/search_bloc_wrapper.dart';
import '../../models/entities/beneficiary_type.dart';
import '../../models/entities/identifier_types.dart';
import '../../utils/registration_delivery_singleton.dart';
import '../../widgets/localized.dart';

class BeneficiaryAcknowledgementPage extends LocalizedStatefulWidget {
  final bool? enableViewHousehold;

  const BeneficiaryAcknowledgementPage({
    super.key,
    super.appLocalizations,
    this.enableViewHousehold,
  });

  @override
  State<BeneficiaryAcknowledgementPage> createState() =>
      BeneficiaryAcknowledgementPageState();
}

class BeneficiaryAcknowledgementPageState
    extends LocalizedState<BeneficiaryAcknowledgementPage> {
  late final HouseholdMemberWrapper? wrapper;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<SearchBlocWrapper>();
    final overviewBloc = context.read<HouseholdOverviewBloc>();
    wrapper = bloc.state.householdMembers.isEmpty
        ? overviewBloc.state.householdMemberWrapper
        : bloc.state.householdMembers.lastOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DigitAcknowledgement.success(
        action: () {
          final bloc = context.read<SearchBlocWrapper>();
          bloc.clearEvent();
          final parent = context.router.parent() as StackRouter;
          parent.popUntilRouteWithName(SearchBeneficiaryRoute.name);
        },
        secondaryAction: () {
          final parent = context.router.parent() as StackRouter;
          final searchBlocState = context.read<SearchBlocWrapper>().state;

          Future.delayed(
            const Duration(
              milliseconds: 0,
            ),
            () {
              final overviewBloc = context.read<HouseholdOverviewBloc>();

              HouseholdMemberWrapper? memberWrapper =
                  searchBlocState.householdMembers.isEmpty
                      ? null
                      : searchBlocState.householdMembers.first;
              overviewBloc.add(
                HouseholdOverviewReloadEvent(
                  projectId:
                      RegistrationDeliverySingleton().projectId.toString(),
                  projectBeneficiaryType:
                      RegistrationDeliverySingleton().beneficiaryType ??
                          BeneficiaryType.household,
                ),
              );
              memberWrapper = searchBlocState.householdMembers.isEmpty
                  ? overviewBloc.state.householdMemberWrapper
                  : searchBlocState.householdMembers.first;
            },
          ).then((value) {
            final overviewBloc = context.read<HouseholdOverviewBloc>();
            parent.popUntilRouteWithName(SearchBeneficiaryRoute.name);
            parent.push(
              BeneficiaryWrapperRoute(
                wrapper: searchBlocState.householdMembers.isEmpty
                    ? overviewBloc.state.householdMemberWrapper
                    : searchBlocState.householdMembers.first,
              ),
            );
          });
        },
        enableViewHousehold: widget.enableViewHousehold ?? false,
        secondaryLabel: localizations.translate(
          i18.householdDetails.viewHouseHoldDetailsAction,
        ),
        subLabel: getSubText(wrapper),
        actionLabel:
            localizations.translate(i18.acknowledgementSuccess.actionLabelText),
        description: localizations.translate(
          i18.acknowledgementSuccess.acknowledgementDescriptionText,
        ),
        label: localizations
            .translate(i18.acknowledgementSuccess.acknowledgementLabelText),
      ),
    );
  }

  getSubText(HouseholdMemberWrapper? wrapper) {
    return wrapper != null
        ? '${localizations.translate(i18.beneficiaryDetails.beneficiaryId)}\n'
            '${wrapper.members?.lastOrNull!.name!.givenName} - '
            '${wrapper.members?.lastOrNull!.identifiers!.lastWhereOrNull(
                  (e) =>
                      e.identifierType ==
                      IdentifierTypes.uniqueBeneficiaryID.toValue(),
                )!.identifierId ?? localizations.translate(i18.common.noResultsFound)}'
        : '';
  }
}
