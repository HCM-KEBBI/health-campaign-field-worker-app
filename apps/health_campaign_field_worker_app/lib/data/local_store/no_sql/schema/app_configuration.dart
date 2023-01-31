import 'package:isar/isar.dart';

part 'app_configuration.g.dart';

@Collection()
class AppConfiguration {
  Id id = Isar.autoIncrement;

  @Name("NETWORK_DETECTION")
  late String? networkDetection;

  @Name("PERSISTENCE_MODE")
  late String? persistenceMode;

  @Name("SYNC_METHOD")
  late String? syncMethod;

  @Name("SYNC_TRIGGER")
  late String? syncTrigger;

  @Name("LANGUAGES")
  late List<Languages>? languages;

  @Name("BACKEND_INTERFACE")
  late BackendInterface? backendInterface;

  @Name('GENDER_OPTIONS_POPULATOR')
  late List<GenderOptions>? genderOptions;

  @Name('HOUSEHOLD_DELETION_REASON_OPTIONS')
  late List<HouseholdDeletionReasonOptions>? householdDeletionReasonOptions;

  @Name('HOUSEHOLD_MEMBER_DELETION_REASON_OPTIONS')
  late List<HouseholdMemberDeletionReasonOptions>?
      householdMemberDeletionReasonOptions;

  @Name("TENANT_ID")
  late String? tenantId;
}

@embedded
class Languages {
  late String label;
  late String value;
}

@embedded
class BackendInterface {
  @Name("interfaces")
  late List<Interfaces> interfaces;
}

@embedded
class GenderOptions {
  late String name;
  late String code;
}

@embedded
class Interfaces {
  late String type;
  late String name;
  late Config confg;
}

@embedded
class Config {
  late int localStoreTTL;
}

@embedded
class HouseholdDeletionReasonOptions {
  late String name;
  late String code;
}

@embedded
class HouseholdMemberDeletionReasonOptions {
  late String name;
  late String code;
}
