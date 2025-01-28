import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/entities/household.dart';
import '../../../models/entities/stock.dart';
import '../../../models/entities/stock_reconciliation.dart';
import '../../../router/app_router.dart';
import '../../../widgets/localized.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../blocs/performanceSummaryReport/performance_summary_report.dart';
import '../../../models/entities/individual.dart';
import '../../../models/entities/product_variant.dart';
import '../../../models/entities/task.dart';
import '../../../utils/i18_key_constants.dart' as i18;
import '../../../utils/utils.dart';
import '../../../widgets/header/back_navigation_help_header.dart';
import '../../../widgets/reports/readonly_pluto_grid.dart';

class PerformamnceSummaryReportDetailsPage extends LocalizedStatefulWidget
    with AutoRouteWrapper {
  const PerformamnceSummaryReportDetailsPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<PerformamnceSummaryReportDetailsPage> createState() =>
      _PerformamnceSummaryReportDetailsPageState();

/* created a wrapper  Router which handles the BlocProvider 
and attached the event to load the data*/
  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return PerformannceSummaryReportBloc(
          individualRepository:
              context.repository<IndividualModel, IndividualSearchModel>(),
          householdRepository:
              context.repository<HouseholdModel, HouseholdSearchModel>(),
          taskRepository: context.repository<TaskModel, TaskSearchModel>(),
          productVariantRepository: context
              .repository<ProductVariantModel, ProductVariantSearchModel>(),
          stockDataRepository:
              context.repository<StockModel, StockSearchModel>(),
        );
      },
      child: this,
    );
  }
}

class _PerformamnceSummaryReportDetailsPageState
    extends LocalizedState<PerformamnceSummaryReportDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Load data when the page is initialized
    _loadData();
  }

  void _loadData() {
    final bloc = BlocProvider.of<PerformannceSummaryReportBloc>(context);
    bloc.add(PerformanceSummaryReportLoadDataEvent(
      userId: context.loggedInUserUuid,
      projectCode: context.selectedProjectType != null
          ? context.selectedProjectType!.code
          : '',
    ));
  }

  static const _householdKey = 'householdKey';
  static const _treatedPercentageKey = 'treatedPercentageKey';
  static const _treatedKey = 'treatedKey';
  static const _dateKey = 'dateKey';
  static const _aztReceived = 'aztReceived';
  static const _aztUsed = 'aztUsed';
  static const _title = "Summary Report";

  FormGroup _form() {
    return fb.group({});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PerformannceSummaryReportBloc,
          PerformanceSummaryReportState>(
        builder: (context, performanceSumamryReportState) {
          return ScrollableContent(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackNavigationHelpHeaderWidget(),
              Container(
                padding: const EdgeInsets.all(kPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _title,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),
              if (performanceSumamryReportState
                  is PerformanceSummaryReportSummaryDataState)
                ReactiveFormBuilder(
                  form: _form,
                  builder: (ctx, form, child) {
                    return SizedBox(
                      height: 400,
                      child: _ReportDetailsContent(
                        title: _title,
                        data: DigitGridData(
                          columns: [
                            DigitGridColumn(
                              label: localizations.translate(
                                i18.inventoryReportDetails.dateLabel,
                              ),
                              key: _dateKey,
                              width: 90,
                            ),
                            DigitGridColumn(
                              label: localizations.translate(
                                i18.summaryReport.houseHoldRegistered,
                              ),
                              key: _householdKey,
                              width: 170,
                            ),
                            DigitGridColumn(
                              label: localizations.translate(
                                i18.summaryReport.childrenTreated,
                              ),
                              key: _treatedKey,
                              width: 120,
                            ),
                            DigitGridColumn(
                              label: localizations.translate(
                                i18.summaryReport.childrenTreatedPercentage,
                              ),
                              key: _treatedPercentageKey,
                              width: 150,
                            ),
                            DigitGridColumn(
                              label: localizations.translate(
                                i18.summaryReport.aztReceived,
                              ),
                              key: _aztReceived,
                              width: 160,
                            ),
                            DigitGridColumn(
                              label: localizations.translate(
                                i18.summaryReport.aztConsumed,
                              ),
                              key: _aztUsed,
                              width: 160,
                            ),
                          ],
                          rows: [
                            for (final entry in performanceSumamryReportState
                                .summaryData.entries) ...[
                              DigitGridRow(
                                [
                                  DigitGridCell(
                                    key: _dateKey,
                                    value: entry.key,
                                  ),
                                  DigitGridCell(
                                    key: _householdKey,
                                    value:
                                        entry.value.householdCount.toString(),
                                  ),
                                  DigitGridCell(
                                    key: _treatedKey,
                                    value: entry.value.taskCount.toString(),
                                  ),
                                  DigitGridCell(
                                    key: _treatedPercentageKey,
                                    value: entry.value.treatedPercentage
                                        .toString(),
                                  ),
                                  DigitGridCell(
                                    key: _aztReceived,
                                    value: entry.value.aztReceived.toString(),
                                  ),
                                  DigitGridCell(
                                    key: _aztUsed,
                                    value: entry.value.aztUsed.toString(),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportDetailsContent extends StatelessWidget {
  final String title;
  final DigitGridData data;

  const _ReportDetailsContent({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: kPadding * 2),
          Flexible(
            child: ReadonlyDigitGrid(
              data: data,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoReportContent extends StatelessWidget {
  final String title;
  final String message;

  const _NoReportContent({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: kPadding * 2,
          width: double.maxFinite,
        ),
        Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.disabledColor,
            ),
          ),
        ),
      ],
    );
  }
}
