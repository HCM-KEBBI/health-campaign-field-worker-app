// Generated using mason. Do not modify by hand
import 'package:dart_mappable/dart_mappable.dart';
import 'package:drift/drift.dart';

import '../data_model.dart';
import '../../data/local_store/sql_store/sql_store.dart';

@MappableClass(ignoreNull: true)
class TargetSearchModel extends EntitySearchModel {
  final List<String>? clientReferenceId;
  final String? tenantId;
  final bool? isDeleted;
  
  TargetSearchModel({
    this.clientReferenceId,
    this.tenantId,
    this.isDeleted,
    super.boundaryCode,
  }):  super();
}

@MappableClass(ignoreNull: true)
class TargetModel extends EntityModel {
  final String? id;
  final String? beneficiaryType;
  final String? baseline;
  final String? target;
  final String clientReferenceId;
  final String tenantId;
  final bool? isDeleted;
  final int rowVersion;
  

  TargetModel({
    this.id,
    this.beneficiaryType,
    this.baseline,
    this.target,
    required this.clientReferenceId,
    required this.tenantId,
    this.isDeleted,
    required this.rowVersion,
    super.auditDetails,
  }):  super();

  TargetCompanion get companion {
    return TargetCompanion(
      id: Value(id),
      beneficiaryType: Value(beneficiaryType),
      baseline: Value(baseline),
      target: Value(target),
      clientReferenceId: Value(clientReferenceId),
      tenantId: Value(tenantId),
      isDeleted: Value(isDeleted),
      rowVersion: Value(rowVersion),
      );
  }
}
