// Generated using mason. Do not modify by hand
import 'package:dart_mappable/dart_mappable.dart';
import 'package:drift/drift.dart';

import '../data_model.dart';
import '../../data/local_store/sql_store/sql_store.dart';

@MappableClass(ignoreNull: true)
class IdentifierSearchModel extends EntitySearchModel {
  final String? id;
  final String? identifierType;
  final String? identifierId;
  final String? tenantId;
  final bool? isDeleted;
  
  IdentifierSearchModel({
    this.id,
    this.identifierType,
    this.identifierId,
    this.tenantId,
    this.isDeleted,
    super.boundaryCode,
  }):  super();
}

@MappableClass(ignoreNull: true)
class IdentifierModel extends EntityModel {
  final String? id;
  final String? individualClientReferenceId;
  final String? identifierType;
  final String? identifierId;
  final String? tenantId;
  final bool? isDeleted;
  final int? rowVersion;
  

  IdentifierModel({
    this.id,
    this.individualClientReferenceId,
    this.identifierType,
    this.identifierId,
    this.tenantId,
    this.isDeleted,
    this.rowVersion,
    super.auditDetails,
  }):  super();

  IdentifierCompanion get companion {
    return IdentifierCompanion(
      id: Value(id),
      individualClientReferenceId: Value(individualClientReferenceId),
      identifierType: Value(identifierType),
      identifierId: Value(identifierId),
      tenantId: Value(tenantId),
      isDeleted: Value(isDeleted),
      rowVersion: Value(rowVersion),
      );
  }
}
