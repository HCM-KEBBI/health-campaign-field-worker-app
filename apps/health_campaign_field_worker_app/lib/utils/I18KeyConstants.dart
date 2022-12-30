class i18 {
  static Common common = const Common();
  static Login login = const Login();
  static ForgotPassword forgotPassword = const ForgotPassword();
  static Home home = const Home();
  static SearchBeneficiary searchBeneficiary = const SearchBeneficiary();
}

class Common {
  const Common();
  String get coreCommonContinue => 'CORE_COMMON_CONTINUE';
  String get coreCommonAge => 'CORE_COMMON_AGE';
  String get coreCommonGender => 'CORE_COMMON_GENDER';
}

class Login {
  const Login();
  String get labelText => 'LOGIN_LABEL_TEXT';
  String get userIdPlaceholder => 'USER_ID_PLACEHOLDER';
  String get passwordPlaceholder => 'PASSWORD_PLACEHOLDER';
  String get actionLabel => 'LOGIN_ACTION_LABEL';
}

class ForgotPassword {
  const ForgotPassword();
  String get labelText => 'FORGOT_PASSWORD_LABEL_TEXT';
  String get contentText => 'FORGOT_PASSWORD_CONTENT_TEXT';
  String get primaryActionLabel => 'PRIMARY_ACTION_LABEL';
  String get actionLabel => 'FORGOT_PASSWORD_ACTION_LABEL';
}

class Home {
  const Home();
  String get beneficiaryLabel => 'HOME_BENEFICIARY_LABEL';
  String get viewReportsLabel => 'HOME_VIEW_REPORTS_LABEL';
  String get syncDataLabel => 'HOME_SYNC_DATA_LABEL';
  String get callbackLabel => 'HOME_CALL_BACK_LABEL';
  String get fileComplaint => 'HOME_FILE_COMPLAINT';
}

class SearchBeneficiary {
  const SearchBeneficiary();
  String get statisticsLabelText => 'BENEFICIARY_STATISTICS_LABEL_TEXT';
  String get noOfHouseholdsRegistered => 'NO_OF_HOUSEHOLDS_REGISTERED';
  String get noOfBednetsDelivered => 'NO_OF_BEDNETS_DELIVERED';
  String get beneficiarySearchHintText => 'BENEFICIARY_SEARCH_HINT_TEXT';
  String get beneficiaryInfoDescription => 'BENEFICIARY_INFO_DESCRIPTION';
  String get beneficiaryInfoTitle => 'BENEFICIARY_INFO_TITLE';
  String get beneficiaryAddActionLabel => 'BENEFICIARY_ADD_ACTION_LABEL';
  String get iconLabel => 'ICON_LABEL';
}
