// Generated using mason. Do not modify by hand
import 'package:dart_mappable/dart_mappable.dart';
import 'package:drift/drift.dart';

import '../data_model.dart';
import '../../data/local_store/sql_store/sql_store.dart';

@MappableClass(ignoreNull: true)
class StockSearchModel extends EntitySearchModel {
  final String? id;
  final String? tenantId;
  final String? facilityId;
  final String? productVariantId;
  final String? referenceId;
  final String? referenceIdType;
  final String? transactionType;
  final String? transactionReason;
  final String? transactingPartyId;
  final String? transactingPartyType;
  final List<String>? clientReferenceId;
  final bool? isDeleted;
  
  StockSearchModel({
    this.id,
    this.tenantId,
    this.facilityId,
    this.productVariantId,
    this.referenceId,
    this.referenceIdType,
    this.transactionType,
    this.transactionReason,
    this.transactingPartyId,
    this.transactingPartyType,
    this.clientReferenceId,
    this.isDeleted,
    super.boundaryCode,
  }):  super();
}

@MappableClass(ignoreNull: true)
class StockModel extends EntityModel {
  final String? id;
  final String? tenantId;
  final String? facilityId;
  final String? productVariantId;
  final String? referenceId;
  final String? referenceIdType;
  final String? transactionType;
  final String? transactionReason;
  final String? transactingPartyId;
  final String? transactingPartyType;
  final String? quantity;
  final String? waybillNumber;
  final String clientReferenceId;
  final bool? isDeleted;
  final int? rowVersion;
  

  StockModel({
    this.id,
    this.tenantId,
    this.facilityId,
    this.productVariantId,
    this.referenceId,
    this.referenceIdType,
    this.transactionType,
    this.transactionReason,
    this.transactingPartyId,
    this.transactingPartyType,
    this.quantity,
    this.waybillNumber,
    required this.clientReferenceId,
    this.isDeleted,
    this.rowVersion,
    super.auditDetails,
  }):  super();

  StockCompanion get companion {
    return StockCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      facilityId: Value(facilityId),
      productVariantId: Value(productVariantId),
      referenceId: Value(referenceId),
      referenceIdType: Value(referenceIdType),
      transactionType: Value(transactionType),
      transactionReason: Value(transactionReason),
      transactingPartyId: Value(transactingPartyId),
      transactingPartyType: Value(transactingPartyType),
      quantity: Value(quantity),
      waybillNumber: Value(waybillNumber),
      clientReferenceId: Value(clientReferenceId),
      isDeleted: Value(isDeleted),
      rowVersion: Value(rowVersion),
      );
  }
}