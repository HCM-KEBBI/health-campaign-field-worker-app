// Generated using mason. Do not modify by hand

import 'package:drift/drift.dart';

import 'project_product_variant.dart';

class ProjectResource extends Table {
  TextColumn get id => text().nullable()();
  TextColumn get projectId => text().nullable()();
  TextColumn get clientReferenceId => text()();
  TextColumn get tenantId => text().nullable()();
  BoolColumn get isDeleted => boolean().nullable()();
  IntColumn get rowVersion => integer().nullable()();
  
  TextColumn get resources => text().references(ProjectProductVariant, #clientReferenceId)();

  @override
  Set<Column> get primaryKey => { clientReferenceId,  };
}