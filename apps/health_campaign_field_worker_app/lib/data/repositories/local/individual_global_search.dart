import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:health_campaign_field_worker_app/data/local_store/sql_store/sql_store.dart';

import '../../../models/data_model.dart';
import '../../../utils/global_search_parameters.dart';
import '../../../utils/utils.dart';
import '../../data_repository.dart';

import 'package:drift/src/dsl/dsl.dart' as dsl;
// import 'package:registration_delivery/utils/global_search_parameters.dart';

class IndividualGlobalSearchRepository extends LocalRepository {
  IndividualGlobalSearchRepository(super.sql, super.opLogManager);

  @override
  FutureOr<List<EntityModel>> search(EntitySearchModel query) {
    throw UnimplementedError();
  }

  @override
  DataModelType get type => throw UnimplementedError();

  individualGlobalSearch(GlobalSearchParameters params) async {
    dynamic selectQuery;
    late int? count = params.totalCount == 0 ? 0 : params.totalCount;

    var beneficiarySelectQuery =
        await _beneficiaryIdSearch(selectQuery, params, super.sql);

    // Return empty list if no results found
    if (beneficiarySelectQuery == null) {
      return [];
    } else {
      // Get total count if offset is zero and filters are applied
      if (params.offset == 0) {
        count = await _getTotalCount(beneficiarySelectQuery, params, super.sql);
      }
      await beneficiarySelectQuery.limit(
        params.limit ?? 50,
        offset: params.offset ?? 0,
      );

      final results = await beneficiarySelectQuery.get();

      return _returnIndividualModel(results, count);
    }
  }

  // Function to perform BeneficiaryId search based on provided parameters
  _beneficiaryIdSearch(
    selectQuery,
    GlobalSearchParameters params,
    LocalSqlDataStore sql,
  ) async {
    if (params.beneficiaryId == null || params.beneficiaryId!.isEmpty) {
      return selectQuery;
    } else if (params.beneficiaryId != null ||
        params.beneficiaryId!.isNotEmpty && selectQuery == null) {
      selectQuery = super.sql.individual.select().join(
        [joinName(sql), joinIdentifier(sql), joinIndividualAddress(sql)],
      );
      await _searchByBeneficiaryId(selectQuery, params, sql);
      selectQuery = selectQuery.join([
        leftOuterJoin(
          sql.householdMember,
          sql.householdMember.individualClientReferenceId.equalsExp(
            sql.individual.clientReferenceId,
          ),
        ),
      ]);
      selectQuery.join([
        leftOuterJoin(
          sql.household,
          sql.household.clientReferenceId
              .equalsExp(sql.householdMember.householdClientReferenceId),
        ),
        leftOuterJoin(
          sql.projectBeneficiary,
          sql.projectBeneficiary.beneficiaryClientReferenceId
              .equalsExp(sql.individual.clientReferenceId),
        ),
      ]);
    } else if (params.beneficiaryId != null &&
        params.beneficiaryId!.isNotEmpty &&
        selectQuery != null) {
      selectQuery = selectQuery.join([joinName(sql), joinIdentifier(sql)]);
      selectQuery = _searchByBeneficiaryId(selectQuery, params, sql);
    }

    return selectQuery;
  }

  _searchByBeneficiaryId(
    selectQuery,
    GlobalSearchParameters params,
    LocalSqlDataStore sql,
  ) {
    return selectQuery.where(buildAnd([
      if (params.beneficiaryId != null)
        buildOr([
          sql.identifier.identifierId.contains(
            params.beneficiaryId!,
          ),
          buildOr([
            sql.identifier.identifierId.contains(
              params.beneficiaryId!,
            ),
          ]),
        ]),
    ]));
  }

  joinName(LocalSqlDataStore sql) {
    return leftOuterJoin(
      sql.name,
      sql.name.individualClientReferenceId.equalsExp(
        sql.individual.clientReferenceId,
      ),
    );
  }

  joinIdentifier(LocalSqlDataStore sql) {
    return leftOuterJoin(
      sql.identifier,
      sql.identifier.clientReferenceId.equalsExp(
        sql.individual.clientReferenceId,
      ),
    );
  }

  joinIndividualAddress(LocalSqlDataStore sql) {
    return leftOuterJoin(
      sql.address,
      sql.address.relatedClientReferenceId.equalsExp(
        sql.individual.clientReferenceId,
      ),
    );
  }

  // Executing custom select query on top of filterSelectQuery to get count
  _getTotalCount(filterSelectQuery, GlobalSearchParameters params,
      LocalSqlDataStore sql) async {
    JoinedSelectStatement selectQuery = filterSelectQuery;
    var query =
        selectQuery.constructQuery().buffer.toString().replaceAll(';', '');
    var variables = selectQuery.constructQuery().introducedVariables;
    var indexesLength = selectQuery.constructQuery().variableIndices;

    var totalCount;

    try {
      totalCount = await sql
          .customSelect('SELECT COUNT(*) AS total_count FROM ($query)',
              variables: indexesLength.isNotEmpty
                  ? variables.map((e) => Variable(e.value)).toList()
                  : [])
          .get();
    } catch (e) {
      debugPrint('Error in total $e');
    }
    return totalCount == null ? 0 : totalCount.first.data['total_count'];
  }

  _returnIndividualModel(results, int? count) {
    var data = results
        .map((e) {
          final individual = e.readTableOrNull(sql.individual);
          final address = e.readTableOrNull(sql.address);
          final name = e.readTableOrNull(sql.name);
          final identifier = e.readTableOrNull(sql.identifier);

          return IndividualModel(
            id: individual.id,
            tenantId: individual.tenantId,
            individualId: individual.individualId,
            clientReferenceId: individual.clientReferenceId,
            dateOfBirth: individual.dateOfBirth,
            mobileNumber: individual.mobileNumber,
            isDeleted: individual.isDeleted,
            rowVersion: individual.rowVersion,
            clientAuditDetails: (individual.clientCreatedBy != null &&
                    individual.clientCreatedTime != null)
                ? ClientAuditDetails(
                    createdBy: individual.clientCreatedBy!,
                    createdTime: individual.clientCreatedTime!,
                    lastModifiedBy: individual.clientModifiedBy,
                    lastModifiedTime: individual.clientModifiedTime,
                  )
                : null,
            auditDetails: (individual.auditCreatedBy != null &&
                    individual.auditCreatedTime != null)
                ? AuditDetails(
                    createdBy: individual.auditCreatedBy!,
                    createdTime: individual.auditCreatedTime!,
                    lastModifiedBy: individual.auditModifiedBy,
                    lastModifiedTime: individual.auditModifiedTime,
                  )
                : null,
            name: name == null
                ? null
                : NameModel(
                    id: name.id,
                    individualClientReferenceId: individual.clientReferenceId,
                    familyName: name.familyName,
                    givenName: name.givenName,
                    otherNames: name.otherNames,
                    rowVersion: name.rowVersion,
                    tenantId: name.tenantId,
                    auditDetails: (name.auditCreatedBy != null &&
                            name.auditCreatedTime != null)
                        ? AuditDetails(
                            createdBy: name.auditCreatedBy!,
                            createdTime: name.auditCreatedTime!,
                            lastModifiedBy: name.auditModifiedBy,
                            lastModifiedTime: name.auditModifiedTime,
                          )
                        : null,
                    clientAuditDetails: (name.clientCreatedBy != null &&
                            name.clientCreatedTime != null)
                        ? ClientAuditDetails(
                            createdBy: name.clientCreatedBy!,
                            createdTime: name.clientCreatedTime!,
                            lastModifiedBy: name.clientModifiedBy,
                            lastModifiedTime: name.clientModifiedTime,
                          )
                        : null,
                  ),
            bloodGroup: individual.bloodGroup,
            address: [
              address == null
                  ? null
                  : AddressModel(
                      id: address.id,
                      relatedClientReferenceId: individual.clientReferenceId,
                      tenantId: address.tenantId,
                      doorNo: address.doorNo,
                      latitude: address.latitude,
                      longitude: address.longitude,
                      landmark: address.landmark,
                      locationAccuracy: address.locationAccuracy,
                      addressLine1: address.addressLine1,
                      addressLine2: address.addressLine2,
                      city: address.city,
                      pincode: address.pincode,
                      type: address.type,
                      locality: address.localityBoundaryCode != null
                          ? LocalityModel(
                              code: address.localityBoundaryCode!,
                              name: address.localityBoundaryName,
                            )
                          : null,
                      rowVersion: address.rowVersion,
                      auditDetails: (address.auditCreatedBy != null &&
                              address.auditCreatedTime != null)
                          ? AuditDetails(
                              createdBy: address.auditCreatedBy!,
                              createdTime: address.auditCreatedTime!,
                              lastModifiedBy: address.auditModifiedBy,
                              lastModifiedTime: address.auditModifiedTime,
                            )
                          : null,
                      clientAuditDetails: (address.clientCreatedBy != null &&
                              address.clientCreatedTime != null)
                          ? ClientAuditDetails(
                              createdBy: address.clientCreatedBy!,
                              createdTime: address.clientCreatedTime!,
                              lastModifiedBy: address.clientModifiedBy,
                              lastModifiedTime: address.clientModifiedTime,
                            )
                          : null,
                    ),
            ].whereNotNull().toList(),
            gender: individual.gender,
            identifiers: [
              if (identifier != null)
                IdentifierModel(
                  id: identifier.id,
                  clientReferenceId: individual.clientReferenceId,
                  identifierType: identifier.identifierType,
                  identifierId: identifier.identifierId,
                  rowVersion: identifier.rowVersion,
                  tenantId: identifier.tenantId,
                  auditDetails: AuditDetails(
                    createdBy: identifier.auditCreatedBy!,
                    createdTime: identifier.auditCreatedTime!,
                    lastModifiedBy: identifier.auditModifiedBy,
                    lastModifiedTime: identifier.auditModifiedTime,
                  ),
                ),
            ],
            additionalFields: individual.additionalFields == null
                ? null
                : IndividualAdditionalFieldsMapper.fromJson(
                    individual.additionalFields!,
                  ),
          );
        })
        .where((element) => element.isDeleted != true)
        .toList();

    return {'total_count': count, 'data': data};
  }

  @override
  // TODO: implement table
  TableInfo<dsl.Table, dynamic> get table => throw UnimplementedError();
}
