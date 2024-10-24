import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';

import '../../../utils/i18_key_constants.dart' as i18;
import '../../blocs/record_stock/record_stock.dart';
import '../../router/app_router.dart';
import '../../utils/extensions/extensions.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';

class ManageStocksPage extends LocalizedStatefulWidget {
  const ManageStocksPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<ManageStocksPage> createState() => _ManageStocksPageState();
}

class _ManageStocksPageState extends LocalizedState<ManageStocksPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDistributor = context.isDistributor;

    return Scaffold(
      body: ScrollableContent(
        header: const Column(children: [
          BackNavigationHelpHeaderWidget(),
        ]),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    kPadding * 2, kPadding, kPadding * 2, kPadding),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    localizations.translate(i18.manageStock.label),
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Column(children: [
                DigitListView(
                  title: localizations
                      .translate(i18.manageStock.recordStockReceiptLabel),
                  description: localizations.translate(
                    isDistributor
                        ? i18.manageStock
                            .recordStockReceiptDistributorDescription
                        : i18.manageStock.recordStockReceiptDescription,
                  ),
                  prefixIcon: Icons.file_download_outlined,
                  sufixIcon: Icons.arrow_circle_right,
                  onPressed: () => context.router.push(
                    RecordStockWrapperRoute(
                      type: StockRecordEntryType.receipt,
                    ),
                  ),
                ),
                DigitListView(
                  title: localizations.translate(isDistributor
                      ? i18.manageStock.recordStockReturnedToLabel
                      : i18.manageStock.recordStockIssuedLabel),
                  description: localizations.translate(
                    isDistributor
                        ? i18.manageStock.recordStockReturnedToDescription
                        : i18.manageStock.recordStockIssuedDescription,
                  ),
                  prefixIcon: Icons.file_upload_outlined,
                  sufixIcon: Icons.arrow_circle_right,
                  onPressed: () => context.router.push(
                    RecordStockWrapperRoute(
                      type: StockRecordEntryType.dispatch,
                    ),
                  ),
                ),
                if (!isDistributor)
                  DigitListView(
                    title: localizations
                        .translate(i18.manageStock.recordStockReturnedLabel),
                    description: localizations.translate(
                      i18.manageStock.recordStockReturnedDescription,
                    ),
                    prefixIcon: Icons.settings_backup_restore,
                    sufixIcon: Icons.arrow_circle_right,
                    onPressed: () => context.router.push(
                      RecordStockWrapperRoute(
                        type: StockRecordEntryType.returned,
                      ),
                    ),
                  ),
              ]),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
