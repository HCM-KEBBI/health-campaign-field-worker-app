// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'roles_type.dart';

class RolesTypeMapper extends EnumMapper<RolesType> {
  RolesTypeMapper._();

  static RolesTypeMapper? _instance;
  static RolesTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RolesTypeMapper._());
    }
    return _instance!;
  }

  static RolesType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  RolesType decode(dynamic value) {
    switch (value) {
      case "COMMUNITY_DISTRIBUTOR":
        return RolesType.communityDistributor;
      case "HEALTH_FACILITY_SUPERVISOR":
        return RolesType.healthFacilitySupervisor;
      case "COMMUNITY_SUPERVISOR":
        return RolesType.communitySupervisor;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(RolesType self) {
    switch (self) {
      case RolesType.communityDistributor:
        return "COMMUNITY_DISTRIBUTOR";
      case RolesType.healthFacilitySupervisor:
        return "HEALTH_FACILITY_SUPERVISOR";
      case RolesType.communitySupervisor:
        return "COMMUNITY_SUPERVISOR";
    }
  }
}

extension RolesTypeMapperExtension on RolesType {
  dynamic toValue() {
    RolesTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<RolesType>(this);
  }
}
