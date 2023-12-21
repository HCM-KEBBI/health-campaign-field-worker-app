import 'dart:async';

import 'package:drift/drift.dart';

import '../../../models/data_model.dart';
import '../../../utils/utils.dart';
import '../../data_repository.dart';

class DownsyncLocalRepository
    extends LocalRepository<DownsyncModel, DownsyncSearchModel> {
  DownsyncLocalRepository(super.sql, super.opLogManager);

  @override
  FutureOr<void> create(
    DownsyncModel entity, {
    bool createOpLog = false,
    DataOperation dataOperation = DataOperation.create,
  }) async {
    final downSyncCompanion = entity.companion;
    await sql.batch((batch) {
      batch.insert(
        sql.downsync,
        downSyncCompanion,
        mode: InsertMode.insertOrReplace,
      );
    });
    await super.create(entity, createOpLog: false);
  }

  @override
  FutureOr<void> update(
    DownsyncModel entity, {
    bool createOpLog = false,
  }) async {
    final downSyncCompanion = entity.companion;

    await sql.batch((batch) async {
      batch.update(
        sql.downsync,
        downSyncCompanion,
        where: (table) => table.locality.equals(
          entity.locality,
        ),
      );
    });

    await super.update(entity, createOpLog: false);
  }

  @override
  DataModelType get type => DataModelType.project;

  @override
  FutureOr<List<DownsyncModel>> search(
    DownsyncSearchModel query,
  ) async {
    final selectQuery = sql.select(sql.downsync).join([]);

    final results = await (selectQuery
          ..where(
            buildAnd([
              if (query.locality != null)
                sql.downsync.locality.equals(query.locality),
            ]),
          ))
        .get();

    return results.map((e) {
      final data = e.readTable(sql.downsync);

      return DownsyncModel(
        locality: data.locality,
        offset: data.offset,
        limit: data.offset,
        boundaryName: data.boundaryName,
        lastSyncedTime: data.lastSyncedTime,
        totalCount: data.totalCount,
        tenantId: data.tenantId,
        rowVersion: data.rowVersion,
      );
    }).toList();
  }

  @override
  // TODO: implement table
  TableInfo<Table, dynamic> get table => throw UnimplementedError();
}
