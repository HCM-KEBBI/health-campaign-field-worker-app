import '../../../utils/i18_key_constants.dart' as i18;
import 'showcase_wrapper.dart';

class HouseholdLocationShowcaseData {
  static final HouseholdLocationShowcaseData _instance =
      HouseholdLocationShowcaseData._();

  HouseholdLocationShowcaseData._();

  factory HouseholdLocationShowcaseData() => _instance;

  List<ShowcaseItemBuilder> get showcaseData => [
        administrativeArea,
        gpsAccuracy,
        addressLine1,
        addressLine2,
        landmark,
        postalCode,
      ];

  final administrativeArea = ShowcaseItemBuilder(
    messageLocalizationKey: i18.householdLocationShowcase.administrativeArea,
  );

  final gpsAccuracy = ShowcaseItemBuilder(
    messageLocalizationKey: i18.householdLocationShowcase.gpsAccuracy,
  );

  final landmark = ShowcaseItemBuilder(
    messageLocalizationKey: i18.householdLocationShowcase.landmark,
  );

  final addressLine1 = ShowcaseItemBuilder(
    messageLocalizationKey: i18.householdLocationShowcase.address,
  );
  final addressLine2 = ShowcaseItemBuilder(
    messageLocalizationKey: i18.householdLocationShowcase.address,
  );

  final postalCode = ShowcaseItemBuilder(
    messageLocalizationKey: i18.householdLocationShowcase.postalCode,
  );
}
