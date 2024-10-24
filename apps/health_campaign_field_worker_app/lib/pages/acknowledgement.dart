import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';

import '../router/app_router.dart';
import '../utils/i18_key_constants.dart' as i18;
import '../widgets/localized.dart';

class AcknowledgementPage extends LocalizedStatefulWidget {
  bool isDataRecordSuccess;
  String? label;
  String? description;
  bool? isStock;
  Map<String, dynamic>? descriptionTableData;
  AcknowledgementPage({
    super.key,
    super.appLocalizations,
    this.isDataRecordSuccess = false,
    this.isStock = false,
    this.label,
    this.description,
    this.descriptionTableData,
  });

  @override
  State<AcknowledgementPage> createState() => _AcknowledgementPageState();
}

class _AcknowledgementPageState extends LocalizedState<AcknowledgementPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DigitAcknowledgement.success(
        description: widget.description ??
            localizations.translate(
              i18.acknowledgementSuccess.acknowledgementDescriptionText,
            ),
        descriptionWidget: widget.isDataRecordSuccess
            ? DigitTableCard(
                element: widget.descriptionTableData ?? {},
              )
            : null,
        label: widget.label ??
            localizations.translate(
              i18.acknowledgementSuccess.acknowledgementLabelText,
            ),
        action: () {
          widget.isStock!
              ? context.router.popUntilRouteWithName(HomeRoute.name)
              : context.router.pop();
        },
        enableBackToSearch: widget.isDataRecordSuccess ? false : true,
        actionLabel: widget.isStock!
            ? localizations
                .translate(i18.inventoryReportDetails.backToHomeButtonLabel)
            : localizations
                .translate(i18.acknowledgementSuccess.actionLabelText),
      ),
      bottomNavigationBar: Offstage(
        offstage: !widget.isDataRecordSuccess,
        // Show the bottom navigation bar if `isDataRecordSuccess` is true
        child: SizedBox(
          height: 150,
          child: DigitCard(
            margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
            padding: const EdgeInsets.fromLTRB(kPadding, 0, kPadding, 0),
            child: Column(
              children: [
                DigitElevatedButton(
                  child: Text(localizations
                      .translate(i18.acknowledgementSuccess.goToHome)),
                  onPressed: () {
                    context.router.popUntilRouteWithName(HomeRoute.name);
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                DigitOutLineButton(
                  onPressed: () {
                    context.router.popAndPush(BoundarySelectionRoute());
                  },
                  label: localizations
                      .translate(i18.acknowledgementSuccess.downloadmoredata),
                  buttonStyle: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      width: 1.0,
                      color: theme.colorScheme.secondary,
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
