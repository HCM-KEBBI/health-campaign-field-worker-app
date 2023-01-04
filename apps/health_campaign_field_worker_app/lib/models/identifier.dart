// Generated using mason. Do not modify by hand
import 'package:dart_mappable/dart_mappable.dart';

import 'data_model.dart';

@MappableClass()
class IdentifierRequestModel extends DataModel {
  final String? type;
  final String? id;
  
  IdentifierRequestModel({
    this.type,
    this.id,
    super.boundaryCode,
  }):  super();
}

@MappableClass()
class IdentifierModel extends DataModel implements IdentifierRequestModel {
  
  @override
  final String type;
  
  @override
  final String id;
  final String clientReferenceId;
  

  IdentifierModel({
    required this.type,
    required this.id,
    required this.clientReferenceId,
    super.auditDetails,
  }):  super();
}
