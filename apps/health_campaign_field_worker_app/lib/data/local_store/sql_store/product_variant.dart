import 'package:drift/drift.dart';

class ProductVariantTable extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get productId => text()();
  TextColumn get sku => text()();
  TextColumn get variation => text()();
  IntColumn get rowVersion => integer()();
  

  @override
  Set<Column>? get primaryKey => {  };
}