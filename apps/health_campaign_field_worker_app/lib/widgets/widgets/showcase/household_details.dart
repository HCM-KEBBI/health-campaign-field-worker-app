import 'showcase_wrapper.dart';
import '../../../utils/i18_key_constants.dart' as i18;

class HouseholdDetailsShowcaseData {
  static final HouseholdDetailsShowcaseData _instance =
      HouseholdDetailsShowcaseData._();

  HouseholdDetailsShowcaseData._();

  factory HouseholdDetailsShowcaseData() => _instance;

  List<ShowcaseItemBuilder> get showcaseData => [
        dateOfRegistration,
        numberOfMembersLivingInHousehold,
        numberOfPregnantWomenInHousehold,
        numberOfChildrenBelow5InHousehold,
      ];

  final dateOfRegistration = ShowcaseItemBuilder(
    messageLocalizationKey: i18.householdDetailsShowcase.dateOfRegistration,
  );

  final numberOfMembersLivingInHousehold = ShowcaseItemBuilder(
    messageLocalizationKey:
        i18.householdDetailsShowcase.numberOfMembersLivingInHousehold,
  );

  final numberOfPregnantWomenInHousehold = ShowcaseItemBuilder(
    messageLocalizationKey:
        i18.householdDetailsShowcase.numberOfPregnantWomenInHousehold,
  );
  final numberOfChildrenBelow5InHousehold = ShowcaseItemBuilder(
    messageLocalizationKey:
        i18.householdDetailsShowcase.numberOfChildrenBelow5InHousehold,
  );
}
