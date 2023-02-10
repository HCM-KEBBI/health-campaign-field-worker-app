// Generated using mason. Do not modify by hand
import 'package:dart_mappable/dart_mappable.dart';
import 'package:drift/drift.dart';

import '../data/local_store/sql_store/sql_store.dart';
import 'data_model.dart';

@MappableClass(ignoreNull: true)
class IdentifierSearchModel extends EntitySearchModel {
  final String? type;
  final String? id;
  final String? clientReferenceId;
  
  IdentifierSearchModel({
    this.type,
    this.id,
    this.clientReferenceId,
    super.boundaryCode,
  }):  super();
}

@MappableClass(ignoreNull: true)
class IdentifierModel extends EntityModel implements IdentifierSearchModel {
  
  @override
  final String? type;
  
  @override
  final String? id;
  
  @override
  final String clientReferenceId;
  

  IdentifierModel({
    this.type,
    this.id,
    required this.clientReferenceId,
    super.auditDetails,
  }):  super();

  IdentifierCompanion get companion {
    return IdentifierCompanion(
      type: Value(type),
      id: Value(id),
      clientReferenceId: Value(clientReferenceId),
      );
  }
}
