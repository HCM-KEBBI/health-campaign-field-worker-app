import 'package:flutter/material.dart';

import 'data_model.dart';

class PerformanceSummary extends EntityModel {
  double treatedPercentage;
  int householdCount;
  
  int taskCount;
  dynamic aztUsed;
  dynamic aztReceived;

  PerformanceSummary({
    required this.treatedPercentage,
    required this.householdCount,
    
    required this.taskCount,
    required this.aztUsed,
    required this.aztReceived,
  }) : super();

  @override
  // TODO: implement copyWith
  EntityModelCopyWith<EntityModel, EntityModel, EntityModel> get copyWith =>
      throw UnimplementedError();

  @override
  String toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
