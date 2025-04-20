// Generated using mason. Do not modify by hand
import 'package:dart_mappable/dart_mappable.dart';
import 'package:drift/drift.dart';

import '../data_model.dart';
import '../../data/local_store/sql_store/sql_store.dart';

part 'project_type.mapper.dart';

@MappableClass(ignoreNull: true, discriminatorValue: MappableClass.useAsDefault)
class ProjectTypeSearchModel extends EntitySearchModel
    with ProjectTypeSearchModelMappable {
  final List<String>? clientReferenceId;
  final String? tenantId;

  ProjectTypeSearchModel({
    this.clientReferenceId,
    this.tenantId,
    super.boundaryCode,
    super.isDeleted,
  }) : super();

  @MappableConstructor()
  ProjectTypeSearchModel.ignoreDeleted({
    this.clientReferenceId,
    this.tenantId,
    super.boundaryCode,
  }) : super(isDeleted: false);
}

@MappableClass(ignoreNull: true, discriminatorValue: MappableClass.useAsDefault)
class ProjectTypeModel extends EntityModel with ProjectTypeModelMappable {
  static const schemaName = 'ProjectType';

  final String? id;
  final int? validMinAge;
  final int? validMaxAge;
  final String? name;
  final String? code;
  final String? group;
  final String? beneficiaryType;
  final List<String>? eligibilityCriteria;
  final List<String>? taskProcedure;
  final List<ProjectCycle>? cycles;
  final bool? nonRecoverableError;
  final String clientReferenceId;
  final String? tenantId;
  final int? rowVersion;
  final List<ProjectProductVariantModel>? resources;
  final ProjectTypeAdditionalFields? additionalFields;

  ProjectTypeModel({
    this.additionalFields,
    this.id,
    this.validMinAge,
    this.validMaxAge,
    this.name,
    this.code,
    this.group,
    this.beneficiaryType,
    this.eligibilityCriteria,
    this.taskProcedure,
    this.cycles,
    this.nonRecoverableError = false,
    required this.clientReferenceId,
    this.tenantId,
    this.rowVersion,
    this.resources,
    super.auditDetails,
    super.clientAuditDetails,
    super.isDeleted = false,
  }) : super();

  ProjectTypeCompanion get companion {
    return ProjectTypeCompanion(
      auditCreatedBy: Value(auditDetails?.createdBy),
      auditCreatedTime: Value(auditDetails?.createdTime),
      auditModifiedBy: Value(auditDetails?.lastModifiedBy),
      clientCreatedTime: Value(clientAuditDetails?.createdTime),
      clientModifiedTime: Value(clientAuditDetails?.lastModifiedTime),
      clientCreatedBy: Value(clientAuditDetails?.createdBy),
      clientModifiedBy: Value(clientAuditDetails?.lastModifiedBy),
      auditModifiedTime: Value(auditDetails?.lastModifiedTime),
      additionalFields: Value(additionalFields?.toJson()),
      isDeleted: Value(isDeleted),
      id: Value(id),
      name: Value(name),
      code: Value(code),
      group: Value(group),
      beneficiaryType: Value(beneficiaryType),
      eligibilityCriteria: Value(eligibilityCriteria?.toString()),
      taskProcedure: Value(taskProcedure?.toString()),
      nonRecoverableError: Value(nonRecoverableError),
      clientReferenceId: Value(clientReferenceId),
      tenantId: Value(tenantId),
      rowVersion: Value(rowVersion),
    );
  }
}

@MappableClass(ignoreNull: true, discriminatorValue: MappableClass.useAsDefault)
class ProjectTypeAdditionalFields extends AdditionalFields
    with ProjectTypeAdditionalFieldsMappable {
  ProjectTypeAdditionalFields({
    super.schema = 'ProjectType',
    required super.version,
    super.fields,
  });
}

@MappableClass(ignoreNull: true, discriminatorValue: MappableClass.useAsDefault)
class ProjectCycle with ProjectCycleMappable {
  final int id;
  final int startDate;
  final int endDate;
  final int? mandatoryWaitSinceLastCycleInDays;
  final List<ProjectCycleDelivery>? deliveries;
  ProjectCycle(
      {required this.id,
      required this.startDate,
      required this.endDate,
      this.deliveries,
      this.mandatoryWaitSinceLastCycleInDays});
}

@MappableClass(ignoreNull: true, discriminatorValue: MappableClass.useAsDefault)
class ProjectCycleDelivery with ProjectCycleDeliveryMappable {
  final int id;
  final String deliveryStrategy;
  final List<DeliveryDoseCriteria>? doseCriteria;
  final int? mandatoryWaitSinceLastDeliveryInDays;
  ProjectCycleDelivery(
      {required this.id,
      required this.deliveryStrategy,
      this.doseCriteria,
      this.mandatoryWaitSinceLastDeliveryInDays});
}

@MappableClass(ignoreNull: true, discriminatorValue: MappableClass.useAsDefault)
class DeliveryDoseCriteria with DeliveryDoseCriteriaMappable {
  final String? condition;
  @MappableField(key: 'ProductVariants')
  final List<DeliveryProductVariant>? productVariants;
  final int? mandatoryWaitSinceLastDeliveryInDays;
  DeliveryDoseCriteria(
      {this.condition,
      this.productVariants,
      this.mandatoryWaitSinceLastDeliveryInDays});
}

@MappableClass(ignoreNull: true, discriminatorValue: MappableClass.useAsDefault)
class DeliveryProductVariant with DeliveryProductVariantMappable {
  final int? quantity;
  final String productVariantId;
  DeliveryProductVariant({
    this.quantity,
    required this.productVariantId,
  });
}
