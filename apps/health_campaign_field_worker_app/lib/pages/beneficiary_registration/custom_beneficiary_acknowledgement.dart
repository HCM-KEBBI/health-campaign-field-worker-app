import 'package:auto_route/auto_route.dart';
import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/widgets/localized.dart';
import 'package:registration_delivery/blocs/search_households/search_bloc_common_wrapper.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';

import '../../router/app_router.dart';

@RoutePage()
class CustomBeneficiaryAcknowledgementPage extends LocalizedStatefulWidget {
  final bool? enableViewHousehold;

  const CustomBeneficiaryAcknowledgementPage({
    super.key,
    super.appLocalizations,
    this.enableViewHousehold,
  });

  @override
  State<CustomBeneficiaryAcknowledgementPage> createState() =>
      CustomBeneficiaryAcknowledgementPageState();
}

class CustomBeneficiaryAcknowledgementPageState
    extends LocalizedState<CustomBeneficiaryAcknowledgementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DigitAcknowledgement.success(
        action: () {
          context.router.maybePop();
        },
        secondaryAction: () {
          final bloc = context.read<SearchBlocWrapper>();

          context.router.popAndPush(
            CustomHouseholdWrapperRoute(
              wrapper: bloc.state.householdMembers.first,
            ),
          );
        },
        enableViewHousehold: widget.enableViewHousehold ?? false,
        secondaryLabel: localizations.translate(
          i18.householdDetails.viewHouseHoldDetailsAction,
        ),
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
}
