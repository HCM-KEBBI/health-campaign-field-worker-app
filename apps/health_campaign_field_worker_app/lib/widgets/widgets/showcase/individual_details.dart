import '../../../utils/i18_key_constants.dart' as i18;
import 'showcase_wrapper.dart';

class IndividualDetailsShowcaseData {
  static final IndividualDetailsShowcaseData _instance =
      IndividualDetailsShowcaseData._();

  IndividualDetailsShowcaseData._();

  factory IndividualDetailsShowcaseData() => _instance;

  bool hidedata = true;
  List<ShowcaseItemBuilder> get showcaseData {
    List<ShowcaseItemBuilder> data = [
      nameOfIndividual,
      headOfHousehold,
      idType,
      dateOfBirth,
      gender,
      mobile,
    ];

    // if (!hidedata) {
    //   data.insert(data.indexOf(nameOfIndividual) + 1, headOfHousehold);
    // }

    return data;
  }

  final nameOfIndividual = ShowcaseItemBuilder(
    messageLocalizationKey: i18.individualDetailsShowcase.firstNameOfIndividual,
  );

  final lastNameOfIndividual = ShowcaseItemBuilder(
    messageLocalizationKey: i18.individualDetailsShowcase.lastNameOfIndividual,
  );

  final headOfHousehold = ShowcaseItemBuilder(
    messageLocalizationKey: i18.individualDetailsShowcase.headOfHousehold,
  );

  final age = ShowcaseItemBuilder(
    messageLocalizationKey: i18.individualDetailsShowcase.age,
  );

  final dateOfBirth = ShowcaseItemBuilder(
    messageLocalizationKey: i18.individualDetailsShowcase.dateOfBirth,
  );

  final gender = ShowcaseItemBuilder(
    messageLocalizationKey: i18.individualDetailsShowcase.gender,
  );

  final mobile = ShowcaseItemBuilder(
    messageLocalizationKey: i18.individualDetailsShowcase.mobile,
  );

  final idType = ShowcaseItemBuilder(
    messageLocalizationKey: i18.individualDetailsShowcase.idType,
  );
}
