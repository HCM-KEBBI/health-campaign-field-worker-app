import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/repositories/local/household.dart';
import '../../data/repositories/local/product_variant.dart';
import '../../data/repositories/local/task.dart';
import '../../models/data_model.dart';
import '../../models/performance_summary.dart';
import '../../utils/constants.dart';
import '../../utils/environment_config.dart';
import '../../utils/typedefs.dart';

part 'performance_summary_report.freezed.dart';

typedef PerformanceSummaryReportEmitter
    = Emitter<PerformanceSummaryReportState>;

class PerformannceSummaryReportBloc
    extends Bloc<PerformanceSummaryReportEvent, PerformanceSummaryReportState> {
  final IndividualDataRepository individualRepository;

  final HouseholdDataRepository householdRepository;

  final TaskDataRepository taskRepository;

  final ProductVariantDataRepository productVariantRepository;

  final StockDataRepository stockDataRepository;

  PerformannceSummaryReportBloc({
    required this.individualRepository,
    required this.householdRepository,
    required this.taskRepository,
    required this.productVariantRepository,
    required this.stockDataRepository,
  }) : super(const PerformanceSummaryReportEmptyState()) {
    on(_handleLoadDataEvent);
    on(_handleLoadingEvent);
  }

  Future<void> _handleLoadDataEvent(
    PerformanceSummaryReportLoadDataEvent event,
    PerformanceSummaryReportEmitter emit,
  ) async {
    var userId = event.userId;

    Map<String, List<HouseholdModel>> dayVsHouseholdListMap = {};
    Map<String, List<TaskModel>> dayVsTaskListMap = {};
    Map<String?, String> variantIdVsProduct = {};
    Set<String> availableDates = {};
    final householdList =
        await (householdRepository as HouseholdLocalRepository).search(
      HouseholdSearchModel(tenantId: envConfig.variables.tenantId),
      userId,
    );

// Fetching the stock reconciliation details
    final receivedStocks = (await stockDataRepository.search(
      StockSearchModel(
        transactionType: [TransactionType.received],
      ),
    ))
        .where(
          (element) =>
              element.clientAuditDetails != null &&
              element.clientAuditDetails?.createdBy == userId,
        )
        .toList();

    // Assuming each element has 'date' (String or DateTime) and 'quantity' (int or double)
    final Map<String, double> stockReceivedVsDate = {};

    for (var stock in receivedStocks) {
      var dateKey = DigitDateUtils.getDateFromTimestamp(
        stock.dateOfEntry ?? DateTime.now().millisecondsSinceEpoch,
      ); // Replace 'date' with the actual field name in your data model.
      final quantity = double.parse(stock.quantity ??
          '0'); // Replace 'quantity' with the actual field name.

      // Accumulate the quantity for the same date
      stockReceivedVsDate[dateKey] =
          (stockReceivedVsDate[dateKey] ?? 0) + quantity;
    }

    final productVariantList =
        await (productVariantRepository as ProductVariantLocalRepository)
            .search(
      ProductVariantSearchModel(tenantId: envConfig.variables.tenantId),
    );
    final taskList = await (taskRepository as TaskLocalRepository).search(
      TaskSearchModel(
        tenantId: envConfig.variables.tenantId,
        status: Status.administeredSuccess.toValue(),
      ),
      userId,
    );

    var albendazoleResourceId = productVariantList.first.id;

    for (var element in householdList) {
      if (element.additionalFields?.fields
              .firstWhereOrNull((h) => h.key == Constants.isConsentKey)
              ?.value ??
          true) {
        var dateKey = DigitDateUtils.getDateFromTimestamp(
          element.clientAuditDetails!.createdTime,
        );

        dayVsHouseholdListMap.putIfAbsent(dateKey, () => []).add(element);
      }
    }

    for (var element in taskList) {
      var dateKey = DigitDateUtils.getDateFromTimestamp(
        element.clientAuditDetails!.createdTime,
      );

      dayVsTaskListMap.putIfAbsent(dateKey, () => []).add(element);
    }
    availableDates.addAll(dayVsHouseholdListMap.keys.toSet());

    availableDates.addAll(dayVsTaskListMap.keys.toSet());

    Map<String, PerformanceSummary> dayVsDataCount = {};
    Map<String, Map<String?, dynamic>> dayVsDrugsQuantityMap = {};

    for (var entry in dayVsTaskListMap.entries) {
      var date = entry.key;
      var taskListForADate = entry.value;
      getDrugsVsQuantityMap(
        event.projectCode,
        taskListForADate,
        date,
        dayVsDrugsQuantityMap,
      );
    }

    for (var date in availableDates) {
      int totatlHouseholdForADay = 0;
      int totalTaskForADay = 0;

      if (dayVsHouseholdListMap.containsKey(date) &&
          dayVsHouseholdListMap[date] != null) {
        for (var entry in dayVsHouseholdListMap[date]!.toList()) {
          totatlHouseholdForADay++;
        }
      }
      if (dayVsTaskListMap.containsKey(date) &&
          dayVsTaskListMap[date] != null) {
        totalTaskForADay += dayVsTaskListMap[date]!.length;
      }

      // denominator is fixed here
      // assumption here is aztUsed  AZT used
      double aztReceived = 0;
      double aztUsed = 0;
      if (dayVsDrugsQuantityMap.containsKey(date) &&
          dayVsDrugsQuantityMap[date] != null &&
          dayVsDrugsQuantityMap[date]!.containsKey(
            albendazoleResourceId,
          )) {
        aztUsed = dayVsDrugsQuantityMap[date]![albendazoleResourceId] ?? 0;
      }

      if (stockReceivedVsDate.containsKey(date) &&
          stockReceivedVsDate[date] != null) {
        aztReceived = stockReceivedVsDate[date] ?? 0;
      }

      final treatedPercentage =
          (totalTaskForADay / Constants.dailyTarget) * 100;

      //Rounded treatedPercentage to 2 degree
      PerformanceSummary summary = PerformanceSummary(
        treatedPercentage: double.parse(treatedPercentage.toStringAsFixed(2)),
        householdCount: totatlHouseholdForADay,
        taskCount: totalTaskForADay,
        aztReceived: aztReceived * 30,
        aztUsed: aztUsed,
      );
      dayVsDataCount[date] = summary;
    }

    emit(PerformanceSummaryReportSummaryDataState(
      summaryData: SplayTreeMap<String, PerformanceSummary>.from(
        dayVsDataCount,
        (a, b) => b.compareTo(a),
      ),
    ));
  }

  void getDrugsVsQuantityMap(
    String projectCode,
    List<TaskModel> taskList,
    String date,
    Map<String, Map<String?, dynamic>> dayVsDrugsQuantityMap,
  ) {
    const quantityWastedKey = 'quantityWasted';
    Map<String?, double> resourceVsQuantity = {};
    List<TaskResourceModel> taskResourceList = [];

    for (var task in taskList) {
      if (task.resources == null) {
        continue;
      }
      taskResourceList.addAll(task.resources!.toList());
    }
    for (var resource in taskResourceList) {
      double quantityDistributed = 0;
      double quantityWasted = 0;

      //todo remove the double and int checks once , data type is finalized
      var resourceId = resource.productVariantId;
      quantityDistributed = quantityDistributed +
          (resource.quantity!.contains(".")
              ? double.parse(resource.quantity ?? "0.0").toInt()
              : int.parse(resource.quantity ?? "0"));
      if (resource.additionalFields != null) {
        var value = resource.additionalFields!.fields
            .firstWhere((element) => element.key == quantityWastedKey)
            .value;
        quantityWasted = quantityWasted +
            (value == null || value == "null"
                ? 0
                : (value.toString().contains(".")
                    ? double.parse(value.toString()).toInt()
                    : int.parse(value.toString())));
      }
      final quantityUsed = quantityDistributed + quantityWasted;

      resourceVsQuantity.update(
        resourceId,
        (existingValue) => existingValue + quantityUsed,
        ifAbsent: () => quantityUsed,
      );
    }
    dayVsDrugsQuantityMap[date] = resourceVsQuantity;
  }

  Future<void> _handleLoadingEvent(
    PerformanceSummaryReportLoadingEvent event,
    PerformanceSummaryReportEmitter emit,
  ) async {
    emit(const PerformanceSummaryReportLoadingState());
  }
}

@freezed
class PerformanceSummaryReportEvent with _$PerformanceSummaryReportEvent {
  const factory PerformanceSummaryReportEvent.loadData({
    required String userId,
    required String projectCode,
  }) = PerformanceSummaryReportLoadDataEvent;

  const factory PerformanceSummaryReportEvent.loading() =
      PerformanceSummaryReportLoadingEvent;
}

@freezed
class PerformanceSummaryReportState with _$PerformanceSummaryReportState {
  const factory PerformanceSummaryReportState.loading() =
      PerformanceSummaryReportLoadingState;
  const factory PerformanceSummaryReportState.empty() =
      PerformanceSummaryReportEmptyState;

  const factory PerformanceSummaryReportState.summaryData({
    @Default({}) Map<String, PerformanceSummary> summaryData,
  }) = PerformanceSummaryReportSummaryDataState;
}
