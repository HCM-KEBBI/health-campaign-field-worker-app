library i18;

const common = Common();
const login = Login();
const forgotPassword = ForgotPassword();
const home = Home();
const searchBeneficiary = SearchBeneficiary();
const beneficiaryDetails = BeneficiaryDetails();
const householdLocation = HouseholdLocation();
const acknowledgementSuccess = AcknowledgementSuccess();
const householdDetails = HouseholdDetails();
const individualDetails = IndividualDetails();
const householdOverView = HouseholdOverView();
const memberCard = MemberCard();
const deliverIntervention = DeliverIntervention();
const adverseEvents = AdverseEvents();
const projectSelection = ProjectSelection();
const warehouseDetails = WarehouseDetails();
const stockDetails = StockDetails();
const checklist = Checklist();
const stockReconciliationDetails = StockReconciliationDetails();
const manageStock = ManageStock();
const complaints = Complaints();
const reasonForDeletion = ReasonForDeletion();
const inventoryReportSelection = InventoryReportSelection();
const inventoryReportDetails = InventoryReportDetails();
const syncDialog = SyncDialog();
const referBeneficiary = ReferBeneficiary();
const ineligibilityReasons = IneligibilityReasons();
const scanner = Scanner();

class Common {
  const Common();

  String get coreCommonContinue => 'CORE_COMMON_CONTINUE';

  String get coreCommonSyncInProgress => 'CORE_COMMON_SYNC_IN_PROGRESS';

  String get coreCommonAge => 'CORE_COMMON_AGE';

  String get coreCommonName => 'CORE_COMMON_NAME';

  String get coreCommonEmailId => 'CORE_COMMON_EMAIL_ID';

  String get coreCommonGender => 'CORE_COMMON_GENDER';

  String get coreCommonMobileNumber => 'CORE_COMMON_MOBILE_NUMBER';

  String get coreCommonSubmit => 'CORE_COMMON_SUBMIT';

  String get coreCommonSave => 'CORE_COMMON_SAVE';

  String get coreCommonCancel => 'CORE_COMMON_CANCEL';

  String get corecommonRequired => 'CORE_COMMON_REQUIRED';

  String get coreCommonReasonRequired => 'CORE_COMMON_REASON_REQUIRED';

  String get coreCommonOthersRequired => 'CORE_COMMON_OTHERS_REQUIRED';

  String get corecommonclose => 'CORE_COMMON_CLOSE';

  String get coreCommonOk => 'CORE_COMMON_OK';

  String get coreCommonNA => 'CORE_COMMON_NA';

  String get coreCommonProfile => 'CORE_COMMON_PROFILE';

  String get coreCommonLogout => 'CORE_COMMON_LOGOUT';

  String get coreCommonBack => 'CORE_COMMON_BACK';

  String get coreCommonHelp => 'CORE_COMMON_HELP';

  String get coreCommonHome => 'CORE_COMMON_HOME';

  String get coreCommonViewDownloadedData => 'CORE_COMMON_VIEW_DOWNLOADED_DATA';

  String get coreCommonlanguage => 'CORE_COMMON_LANGUAGE';

  String get coreCommonSyncProgress => 'CORE_COMMON_SYNC_PROGRESS';

  String get coreCommonDataSynced => 'CORE_COMMON_DATA_SYNCED';

  String get coreCommonDataSyncFailed => 'CORE_COMMON_DATA_SYNC_FAILED';

  String get coreCommonDataSyncRetry => 'CORE_COMMON_DATA_SYNC_RETRY';

  String get connectionLabel => 'CORE_COMMON_CONNECTION_LABEL';

  String get connectionContent => 'CORE_COMMON_CONNECTION_CONTENT';

  String get coreCommonSkip => 'CORE_COMMON_SKIP';

  String get coreCommonNext => 'CORE_COMMON_NEXT';

  String get coreCommonYes => 'CORE_COMMON_YES';

  String get coreCommonNo => 'CORE_COMMON_NO';
  String get coreCommonGoback => 'CORE_COMMON_GO_BACK';

  String get coreCommonRequiredItems => 'CORE_COMMON_REQUIRED_ITEMS';

  String get min2CharsRequired => 'MIN_2_CHARS_REQUIRED';

  String get maxCharsRequired => 'MAX_CHARS_ALLOWED';

  String get maxValue => 'MAX_VALUE_ALLOWED';

  String get noResultsFound => 'NO_RESULTS_FOUND';

  String get min3CharsRequired => 'MIN_REQUIRED_3';

  String get facilitySearchHeaderLabel => 'FACILITY_SEARCH_HEADER_LABEL';
  String get projectFacilitySearchHeaderLabel =>
      'PROJECT_FACILITY_SEARCH_HEADER_LABEL';

  String get coreCommonWarning => 'CORE_COMMON_WARNING';

  String get coreQuantityWasted => 'CORE_QUANTITY_WASTED';
  String get coreCommonDownload => 'CORE_COMMON_DOWNLOAD';
  String get coreCommonDownloadFailed => 'CORE_COMMON_DOWNLOAD_FAILED';
  String get noMatchFound => 'CORE_COMMON_NO_MATCH_FOUND';
  String get loading => 'CORE_COMMON_LOADING';
}

class AdverseEvents {
  const AdverseEvents();

  String get adverseEventsLabel => 'ADVERSE_EVENTS_LABEL';

  String get sideEffectsLabel => 'SIDE_EFFECTS_LABEL';

  String get selectSymptomsLabel => 'SELECT_SYMPTOMS_LABEL';

  String get resourceHeaderLabel => 'RESOURCE_HEADER_LABEL';

  String get resourceCountHeaderLabel => 'RESOURCE_COUNT_HEADER_LABEL';

  String get resourcesAdministeredLabel => 'RESOURCES_ADMINISTERED_LABEL';

  String get didYouReAdministerLabel => 'DID_YOU_RE_ADMINISTER';

  String get noOfTimesReAdministered => 'NO_OF_TIMES_RE_ADMINISTERED';

  String get sideEffectsAlertTitle => 'SIDE_EFFECTS_ALERT_TITLE';

  String get sideEffectsAlertContent => 'SIDE_EFFECTS_ALERT_CONTENT';
}

class Login {
  const Login();

  String get labelText => 'LOGIN_LABEL_TEXT';

  String get userIdPlaceholder => 'USER_ID_PLACEHOLDER';

  String get passwordPlaceholder => 'PASSWORD_PLACEHOLDER';

  String get actionLabel => 'LOGIN_ACTION_LABEL';

  String get loginError => 'LOGIN_ERROR';

  String get logOutWarningMsg => 'LOG_OUT_WARNING_MESSAGE';

  String get noInternetError => 'ERR_NOT_CONNECTED_TO_INTERNET';

  String get sessionExpired => 'CORE_SESSION_EXPIRED';

  String get pleaseLogout => 'PLEASE_LOGOUT_USER';
}

class Checklist {
  const Checklist();

  String get checklist => 'CHECKLIST';

  String get communityDistributorChecklist => 'COMMUNITY_DISTRIBUTOR_CHECKLIST';

  String get checklistlabel => 'CHECKLIST_LABEL';

  String get communityDistributorChecklistlabel =>
      'COMMUNITY_DISTRIBUTOR_CHECKLIST_LABEL';

  String get checklistCreateActionLabel => 'CHECKLIST_CREATE_ACTION_LABEL';

  String get checklistViewActionLabel => 'CHECKLIST_VIEW_ACTION_LABEL';

  String get checklistDetailLabel => 'CHECKLIST_DETAILS_LABEL';

  String get communityDistributorChecklistDetailLabel =>
      'COMMUNITY_DISTRIBUTOR_CHECKLIST_DETAILS_LABEL';

  String get checklistDialogLabel => 'CHECKLIST_DIALOG_LABEL';

  String get submitButtonDialogLabelText => 'CHECKLIST_DETAILS_SUBMIT';

  String get checklistDialogDescription => 'CHECKLIST_DIALOG_DESCRITPTION';

  String get checklistDialogDynamicDescription =>
      'CHECKLIST_DIALOG_DYNAMIC_DESCRIPTION';
  String get checklistDialogPrimaryAction => 'CHECKLIST_DIALOG_PRIMARY_ACTION';

  String get checklistDialogSecondaryAction =>
      'CHECKLIST_DIALOG_SECONDARY_ACTION';

  String get checklistdate => 'CHECKLIST_DATE';

  String get checklistReasonRequiredError => 'CHECKLIST_REASON_REQUIRED_ERROR';

  String get notSelectedKey => 'NOT_SELECTED';

  String get checklistBackDialogLabel => 'CHECKLIST_BACK_DIALOG_LABEL';

  String get checklistBackDialogDescription =>
      'CHECKLIST_BACK_DIALOG_DESCRITPTION';

  String get checklistBackDialogPrimaryAction =>
      'CHECKLIST_BACK_DIALOG_PRIMARY_ACTION';

  String get checklistBackDialogSecondaryAction =>
      'CHECKLIST_BACK_DIALOG_SECONDARY_ACTION';
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

  String get manageStockLabel => 'HOME_MANAGE_STOCK_LABEL';

  String get stockReconciliationLabel => 'HOME_STOCK_RECONCILIATION_LABEL';

  String get viewReportsLabel => 'HOME_VIEW_REPORTS_LABEL';

  String get syncDataLabel => 'HOME_SYNC_DATA_LABEL';

  String get callbackLabel => 'HOME_CALL_BACK_LABEL';

  String get fileComplaint => 'HOME_FILE_COMPLAINT';

  String get progressIndicatorTitle => 'PROGRESS_INDICATOR_TITLE';

  String get progressIndicatorHelp => 'PROGRESS_INDICATOR_HELP';

  String get progressIndicatorPrefixLabel => 'PROGRESS_INDICATOR_PREFIX_LABEL';

  String get dataSyncInfoLabel => 'DATA_SYNC_INFO_LABEL';

  String get dataSyncInfoContent => 'DATA_SYNC_INFO_CONTENT';

  String get myCheckList => 'MY_CHECK_LIST_LABEL';

  String get warehouseManagerCheckList => 'WAREHOUSE_MANAGER_CHECK_LIST_LABEL';

  String get healthFacilitySupervisorCheckList =>
      'HF_SUPERVISOR_CHECK_LIST_LABEL';

  String get communityDistributorChecklist =>
      'COMMUNITY_DISTRIBUTOR_CHECK_LIST_LABEL';
  String get deleteAllLabel => 'HOME_DELETE_ALL_LABEL';
  String get db => 'HOME_DB_LABEL';
  String get beneficiaryReferralLabel => 'HOME_BENEFICIARY_REFERRAL_LABEL';
  String get manageAttendanceLabel => 'HOME_MANAGE_ATTENDANCE_LABEL';
}

class SearchBeneficiary {
  const SearchBeneficiary();

  String get statisticsLabelText => 'BENEFICIARY_STATISTICS_LABEL_TEXT';

  String get searchIndividualLabelText =>
      'BENEFICIARY_STATISTICS_SEARCH_INDIVIDUAL_LABEL';

  String get noOfHouseholdsRegistered => 'NO_OF_HOUSEHOLDS_REGISTERED';

  String get noOfResourcesDelivered => 'NO_OF_RESOURCES_DELIVERED_SPAQ';

  String get beneficiarySearchHintText => 'BENEFICIARY_SEARCH_HINT_TEXT';

  String get beneficiaryInfoDescription => 'BENEFICIARY_INFO_DESCRIPTION';

  String get beneficiaryInfoTitle => 'BENEFICIARY_INFO_TITLE';

  String get beneficiaryAddActionLabel => 'BENEFICIARY_ADD_ACTION_LABEL';

  String get iconLabel => 'ICON_LABEL';

  String get yearsAbbr => 'YEARS_ABBR';

  String get monthsAbbr => 'MONTHS_ABBR';

  String get proximityLabel => 'PROXIMITY_LABEL';
}

class BeneficiaryDetails {
  const BeneficiaryDetails();

  String get beneficiarysDetailsLabelText => 'BENEFICIARY_DETAILS_LABEL_TEXT';
  String get beneficiarysDetailsEditIconLabelText =>
      'BENEFICIARY_DETAILS_EDIT_ICON_LABEL_TEXT';
  String get beneficiarysDetailsEditIconLabel =>
      'BENEFICIARY_DETAILS_EDIT_ICON_LABEL';
  String get beneficiarysDetailsDeleteIconLabel =>
      'BENEFICIARY_DETAILS_DELETE_ICON_LABEL';
  String get resourcesTobeDelivered => 'RESOURCES_TO_BE_DELIVERED';
  String get resourcesTobeProvided => 'RESOURCES_TO_BE_PROVIDED';

  String get beneficiaryAge => 'BENEFICIARY_AGE';
  String get beneficiaryId => 'BENEFICIARY_ID';
  String get ctaProceed => 'PROCEED';
  String get beneficiaryDoseNo => 'BENEFICIARY_DETAILS_DOSE_NO';
  String get beneficiaryDose => 'BENEFICIARY_DETAILS_DOSE';
  String get beneficiaryDoseText => 'DOSE';
  String get beneficiaryDeliveryText => 'DOSE';
  String get beneficiaryStatus => 'BENEFICIARY_DETAILS_STATUS';
  String get beneficiaryResources => 'BENEFICIARY_DETAILS_RESOURCES';
  String get beneficiaryQuantity => 'BENEFICIARY_DETAILS_QUANTITY';
  String get beneficiaryCompletedOn => 'BENEFICIARY_DETAILS_COMPLETED_ON';
  String get beneficiaryDeliveryStrategy =>
      'BENEFICIARY_DETAILS_DELIVERY_STRATEGY';
  String get beneficiaryCycle => 'BENEFICIARY_DETAILS_CYCLE';
  String get currentCycleLabel => 'BENEFICIARY_DETAILS_CURRENT_CYCLE_LABEL';
  String get fromCurrentLocation => 'FROM_CURRENT_LOCATION';
  String get beneficiary => 'BENEFICIARY';
  String get unableToScan => 'UNABLE_TO_SCAN';

  String get scanValidResource => 'SCAN_VALID_RESOURCE';

  String get scannedResourceCountMisMatch => 'SCANNED_RESOURCE_COUNT_MISMATCH';

  String get resourceAlreadyScanned => 'RESOURCE_ALREADY_SCANNED';

  String get scannerLabel => 'SCANNER_LABEL';

  String get noOfResourceScanned => 'NO_OF_RESOURCE_SCANNED';

  String get resourcesScanned => 'RESOURCES_SCANNED';

  String get saveScannedResource => 'SAVE_SCANNED_RESOURCE';

  String get flashOn => 'FLASH_ON';

  String get flashOff => 'FLASH_OFF';

  String get scannerDialogTitle => 'SCANNER_DIALOG_TITLE';

  String get scannerDialogContent => 'SCANNER_DIALOG_CONTENT';

  String get scannerDialogPrimaryAction => 'SCANNER_DIALOG_PRIMARY_ACTION';

  String get scannerDialogSecondaryAction => 'SCANNER_DIALOG_SECONDARY_ACTION';
  String get beneficiaryHeader => 'BENEFICIARY_HEADER';
  String get deliveryHeader => 'DELIVERY_TABLE_HEADER';

  String get proceedWithoutDownloading => 'PROCEED_WITHOUT_DOWNLOADING';
  String get unableToCheckDataInServer => 'FAILED_TO_CHECK_DATA_IN_SERVER';
  String get dataFound => 'DATA_FOUND';
  String get noDataFound => 'NO_DATA_FOUND';
  String get dataFoundContent => 'DATA_FOUND_CONTENT';
  String get noDataFoundContent => 'NO_DATA_FOUND_CONTENT';
  String get dataDownloadInProgress => 'DATA_DOWNLOAD_IN_PROGRESS';
  String get insufficientStorage => 'INSUFFICIENT_STORAGE_WARNING';
  String get downloadreport => 'DOWNLOAD_REPORT';
  String get boundary => 'BOUNDARY';
  String get status => 'STATUS';
  String get downloadedon => 'DOWNLOADED_ON';
  String get recordsdownload => 'RECORDS_DOWNLOAD';
  String get downloadcompleted => 'DOWNLOAD_COMPLETED';
  String get datadownloadreport => 'DATA_DOWNLOAD_REPORT';
  String get download => 'DOWNLOAD';
  String get partialdownloaded => 'PARTIAL_DOWNLOAD';
  String get downloadtime => 'DOWNLOAD_TIME';
  String get totalrecorddownload => 'TOTAL_RECORD_DOWNLOAD';
  String get insufficientStorageContent =>
      'INSUFFICIENT_STORAGE_WARNING_CONTENT';
}

class IndividualDetails {
  const IndividualDetails();

  String get individualsDetailsLabelText => 'INDIVIDUAL_LABEL_TEXT';

  String get headHouseholdDetailsLabelText => 'HOUSEHOLD_HEAD_LABEL_TEXT';

  String get childIndividualsDetailsLabelText => 'CHILD_INDIVIDUAL_LABEL_TEXT';

  String get nameLabelText => 'INDIVIDUAL_NAME_LABEL_TEXT';

  String get firstNameLabelText => 'INDIVIDUAL_FIRST_NAME_LABEL_TEXT';

  String get firstNameHeadLabelText => 'HEAD_HOUSEHOLD_FIRST_NAME_LABEL_TEXT';

  String get lastNameLabelText => 'INDIVIDUAL_LAST_NAME_LABEL_TEXT';

  String get lastNameHeadLabelText => 'HEAD_HOUSEHOLD_LAST_NAME_LABEL_TEXT';

  String get childFirstNameLabelText =>
      'CHILD_INDIVIDUAL_FIRST_NAME_LABEL_TEXT';

  String get childLastNameLabelText => 'CHILD_INDIVIDUAL_LAST_NAME_LABEL_TEXT';

  String get checkboxLabelText => 'HEAD_OF_HOUSEHOLD_LABEL_TEXT';

  String get idTypeLabelText => 'ID_TYPE_LABEL_TEXT';

  String get idNumberLabelText => 'ID_NUMBER_LABEL_TEXT';

  String get idNumberSuggestionText => 'ID_NUMBER_SUGGESTION_TEXT';

  String get dobLabelText => 'DOB_LABEL_TEXT';

  String get ageLabelText => 'AGE_LABEL_TEXT';

  String get separatorLabelText => 'SEPARATOR_LABEL_TEXT';

  String get genderLabelText => 'GENDER_LABEL_TEXT';

  String get dobErrorText => 'DOB_ERROR_MESSAGE';

  String get mobileNumberLabelText => 'MOBILE_NUMBER_LABEL_TEXT';

  String get heightLabelText => 'HEIGHT_LABEL_TEXT';

  String get submitButtonLabelText => 'INDIVIDUAL_DETAILS_SUBMIT';

  String get mobileNumberInvalidFormatValidationMessage =>
      'INDIVIDUAL_DETAILS_INVALID_MOBILE_NUMBER';

  String get yearsHintText => 'YEARS_HINT_TEXT';
  String get monthsHintText => 'MONTHS_HINT_TEXT';

  String get yearsErrorText => 'ERR_YEARS';

  String get monthsErrorText => 'ERR_MONTHS';

  String get yearsAndMonthsErrorText => 'ERR_YEARS_AND_MONTHS';

  String get firstNameIsRequiredError => 'FIRST_NAME_REQUIRED_ERROR_MESSAGE';

  String get firstNameLengthError => 'FIRST_NAME_LENGTH_ERROR_MESSAGE';

  String get lastNameLengthError => 'LAST_NAME_LENGTH_ERROR_MESSAGE';

  String get lastNameIsRequiredError => 'LAST_NAME_REQUIRED_ERROR_MESSAGE';
}

class HouseholdLocation {
  const HouseholdLocation();

  String get householdLocationLabelText => 'HOUSEHOLD_LOCATION_LABEL_TEXT';

  String get administrationAreaFormLabel => 'ADMINISTRATION_AREA_FORM_LABEL';

  String get administrationAreaRequiredValidation =>
      'HOUSEHOLD_LOCATION_ADMINISTRATION_AREA_REQUIRED_VALIDATION';

  String get householdAddressLine1LabelText =>
      'HOUSEHOLD_ADDRESS_LINE_1_FORM_LABEL';

  String get landmarkFormLabel => 'LANDMARK_FORM_LABEL';

  String get householdAddressLine2LabelText =>
      'HOUSEHOLD_ADDRESS_LINE_2_FORM_LABEL';

  String get postalCodeFormLabel => 'POSTAL_CODE_FORM_LABEL';

  String get actionLabel => 'HOUSEHOLD_LOCATION_ACTION_LABEL';
}

class AcknowledgementSuccess {
  const AcknowledgementSuccess();

  String get actionLabelText => 'ACKNOWLEDGEMENT_SUCCESS_ACTION_LABEL_TEXT';

  String get acknowledgementDescriptionText =>
      'ACKNOWLEDGEMENT_SUCCESS_DESCRIPTION_TEXT';

  String get acknowledgementLabelText => 'ACKNOWLEDGEMENT_SUCCESS_LABEL_TEXT';

  String get goToHome => 'GO_TO_HOME_SCREEN';
  String get downloadmoredata => 'DOWNLOAD_MORE_DATA';
  String get dataDownloadedSuccessLabel => 'DATA_DOWNLOADED_SUCCESS_LABEL';
}

class HouseholdDetails {
  const HouseholdDetails();

  String get householdDetailsLabel => 'HOUSEHOLD_DETAILS_LABEL';

  String get actionLabel => 'HOUSEHOLD_ACTION_LABEL';

  String get dateOfRegistrationLabel =>
      'HOUSEHOLD_DETAILS_DATE_OF_REGISTRATION_LABEL';

  String get noOfMembersCountLabel => 'NO_OF_MEMBERS_COUNT_LABEL';
  String get viewHouseHoldDetailsAction =>
      'VIEW_HOUSEHOLD_DETAILS_ACTION_LABEL';

  String get cardTitle => 'CONSENT_CARD_TITLE';
  String get validationForSelection => 'CONSENT_SUBMIT_VALIDATION';
  String get submitYes => 'SUBMIT_YES';
  String get submitNo => 'SUBMIT_NO';
  String get householdConsentLabel => 'HOUSEHOLD_CONSENT_LABEL';
}

class HouseholdOverView {
  const HouseholdOverView();

  String get householdOverViewLabel => 'HOUSEHOLD_OVER_VIEW_LABEL';

  String get householdOverViewEditLabel =>
      'HOUSEHOLD_OVER_VIEW_EDIT_ICON_LABEL';

  String get householdOverViewHouseholderHeadLabel =>
      'HOUSEHOLD_OVER_VIEW_HOUSEHOLDER_HEAD_LABEL';

  String get householdOverViewDeleteLabel =>
      'HOUSEHOLD_OVER_VIEW_DELETE_ICON_LABEL';

  String get householdOverViewEditIconText =>
      'HOUSEHOLD_OVER_VIEW_EDIT_ICON_LABEL_TEXT';

  String get householdOverViewActionCardTitle =>
      'HOUSEHOLD_OVER_VIEW_ACTION_CARD_TITLE';

  String get householdOverViewPrimaryActionLabel =>
      'HOUSEHOLD_OVER_VIEW_PRIMARY_ACTION_LABEL';

  String get householdOverViewSecondaryActionLabel =>
      'HOUSEHOLD_OVER_VIEW_SECONDARY_ACTION_LABEL';

  String get householdOverViewDeliveredIconLabel =>
      'HOUSEHOLD_OVER_VIEW_DELIVERED_ICON_LABEL';

  String get householdOverViewNotDeliveredIconLabel =>
      'HOUSEHOLD_OVER_VIEW_NOT_DELIVERED_ICON_LABEL';

  String get householdOverViewNotEligibleIconLabel =>
      'HOUSEHOLD_OVER_VIEW_NOT_ELIGIBLE_ICON_LABEL';

  String get householdOverViewBeneficiaryReferredLabel =>
      'HOUSEHOLD_OVER_VIEW_BENEFICIARY_REFERRED_LABEL';

  String get householdOverViewHouseholdHeadLabel =>
      'HOUSEHOLD_OVER_VIEW_HOUSEHOLD_HEAD_LABEL';

  String get householdOverViewHouseholdHeadNameLabel =>
      'HOUSEHOLD_OVER_VIEW_HOUSEHOLD_HEAD_NAME_LABEL';

  String get householdOverViewActionText =>
      'HOUSEHOLD_OVER_VIEW_ACTION_TEXT_SPAQ';

  String get householdOverViewAssessmentActionText =>
      'HOUSEHOLD_OVER_VIEW_ASSESSMENT_ACTION_TEXT';

  String get viewDeliveryLabel => 'VIEW_DELIVERY_DETAILS_LABEL';

  String get householdOverViewAddActionText =>
      'HOUSEHOLD_OVER_VIEW__ADD_ACTION_TEXT';
}

class MemberCard {
  const MemberCard();

  String get assignAsHouseholdhead => 'MEMBER_CARD_ASSIGN_AS_HEAD';

  String get editIndividualDetails => 'MEMBER_CARD_EDIT_INDIVIDUAL_DETAILS';

  String get deleteIndividualActionText =>
      'MEMBER_CARD_DELETE_INDIVIDUAL_ACTION_TEXT';

  String get deliverInterventionSubmitLabel =>
      'MEMBER_CARD_DELIVER_INTERVENTION_SUBMIT_LABEL';

  String get deliverDetailsUpdateLabel =>
      'MEMBER_CARD_DELIVER_DETAILS_UPDATE_LABEL';

  String get deliverDetailsYearText => 'MEMBER_CARD_DELIVER_DETAILS_YEAR_TEXT';

  String get editDetails => 'MEMBER_CARD_EDIT_DETAILS';

  String get heightLabel => 'HEIGHT_LABEL';

  String get deliverDetailsMonthsText =>
      'MEMBER_CARD_DELIVER_DETAILS_MONTHS_TEXT';

  String get unableToDeliverLabel => 'MEMBER_CARD_UNABLE_TO_DELIVER_LABEL';

  String get beneficiaryRefusedLabel => 'MEMBER_CARD_BENEFICIARY_REFUSED_LABEL';

  String get recordAdverseEventsLabel =>
      'MEMBER_CARD_RECORD_ADVERSE_EVENTS_LABEL';
  String get referBeneficiaryLabel => 'MEMBER_CARD_REFER_BENEFICIARY_LABEL';
  String get markIneligibleLabel => 'MEMBER_CARD_MARK_INELIGIBLE_LABEL';
  String get householdMemberText => "HOUSEHOLD_MEMBER_TEXT";
  String get householdMembersText => "HOUSEHOLD_MEMBERS_TEXT";
}

class DeliverIntervention {
  const DeliverIntervention();

  String get deliverInterventionLabel => 'DELIVER_INTERVENTION_LABEL';

  String get deliverInteventionAdministeredLabel =>
      'DELIVER_INTERVENTION_ADMINISTERED_LABEL';

  String get deliverInterventionResourceLabel =>
      'DELIVER_INTERVENTION_RESOURCE_LABEL';

  String get dateOfRegistrationLabel =>
      'DELIVER_INTERVENTION_DATE_OF_REGISTRATION_LABEL';

  String get resourceDeliveredLabel =>
      'DELIVER_INTERVENTION_RESOURCE_DELIVERED_LABEL_SPAQ';

  String get resourceDeliveredError =>
      'DELIVER_INTERVENTION_RESOURCE_DELIVERED_ERROR';

  String get quantityDistributedLabel =>
      'DELIVER_INTERVENTION_QUANTITY_DISTRIBUTED_LABEL_SPAQ';

  String get quantityWastedLabel =>
      'DELIVER_INTERVENTION_QUANTITY_WASTED_LABEL_SPAQ';

  String get deliveryCommentLabel =>
      'DELIVER_INTERVENTION_DELIVERY_COMMENT_LABEL';

  String get idTypeText => 'DELIVER_INTERVENTION_ID_TYPE_TEXT';

  String get idNumberText => 'DELIVER_INTERVENTION_ID_NUMBER_TEXT';

  String get memberCountText => 'DELIVER_INTERVENTION_MEMBER_COUNT_TEXT';

  String get noOfResourcesForDelivery =>
      'DELIVER_INTERVENTION_NO_OF_RESOURCES_FOR_DELIVERY_SPAQ';

  String get dialogTitle => 'DELIVER_INTERVENTION_DIALOG_TITLE';

  String get dialogContent => 'DELIVER_INTERVENTION_DIALOG_CONTENT';

  String get wastedDialogTitle => 'DELIVER_INTERVENTION_WASTED_DIALOG_TITLE';

  String get wastedDialogContent =>
      'DELIVER_INTERVENTION_WASTED_DIALOG_CONTENT';

  String get referDialogTitle => 'DELIVER_INTERVENTION_REFER_DIALOG_TITLE';

  String get referDialogContent => 'DELIVER_INTERVENTION_REFER_DIALOG_CONTENT';

  String get referDialogSubmit => 'DELIVER_INTERVENTION_REFER_DIALOG_SUBMIT';

  String get didYouObserveAdvEventsTitle =>
      'DID_YOU_OBSERVE_ADVERSE_EVENTS_TITLE';
  String get didYouObservePreviousAdvEventsTitle =>
      'DID_YOU_OBSERVE_PREVIOUS_ADVERSE_EVENTS_TITLE';

  String get heightLabelText => 'HEIGHT_LABEL_TEXT';
  String get resourceAddBeneficiary =>
      'DELIVER_INTERVENTION_RESOURCE_ADD_RESOURCE';
  String get resourceDeleteBeneficiary =>
      'DELIVER_INTERVENTION_RESOURCE_DELETE_RESOURCE';
  String get resourceDeleteBeneficiaryDialogTitle =>
      'DELIVER_INTERVENTION_RESOURCE_DIALOG_TITLE';
  String get resourceDeleteBeneficiaryPrimaryActionLabel =>
      'DELIVER_INTERVENTION_RESOURCE_DELETE_PRIMARY_ACTION_LABEL';
  String get wasTheDoseAdministered => 'WAS_THE_DOSE_ADMINISTERED_LABEL';
  String get dose => 'DELIVER_INTERVENTION_DOSE';
  String get hidePastCycles => 'DELIVER_INTERVENTION_HIDE_PAST_CYCLES';
  String get viewPastCycles => 'DELIVER_INTERVENTION_VIEW_PAST_CYCLES';
  String get currentCycle => 'DELIVER_INTERVENTION_CURRENT_CYCLE';
  String get cycle => 'DELIVERY_CYCLE';
  String get recordCycle => 'RECORD_CYCLE';
  String get recordPastDeliveryDeatils =>
      'DELIVER_INTERVENTION_PAST_DELIVERY_DETAILS';
  String get wasDosePastDeliveryDetails =>
      'DELIVER_INTERVENTION_PAST_DOSE_DELIVERY_DETAILS';
  String get doseAdministeredBy => 'DELIVER_INTERVENTION_DOSE_ADMINISTERED_BY';
  String get doseGivenCareGiver => 'DELIVER_INTERVENTION_DOSE_GIVEN_CARE_GIVER';
  String get infoWrittenInChildCard =>
      'DELIVER_INTERVENTION_DOSE_INFO_IN_CHILD_CARD_ADDED';
  String get healthTalkGivenOnSPAQ =>
      'DELIVER_INTERVENTION_DOSE_HEALTH_TALK_GIVEN_SPAQ';

  //[todo] need to change the 24
  String get wasDosePastRecordDeliveryDetails =>
      'DELIVER_INTERVENTION_PAST_RECORD_DOSE_DELIVERY_DETAILS';
  String get resourceCannotBeZero => 'RESOURCE_QUANTITY_CANNOT_BE_ZERO';

  String get resourceDeliveredValidation => 'RESOURCE_DELIVERED_VALIDATION';

  String get wastedCountValidation => 'WASTED_COUNT_VALIDATION';

  String get deliveryCommentRequired => 'DELIVERY_COMMENT_REQUIRED';

  // [new key added for record past delivery details]
  String get wasDosePastDeliveryDetailPart2 =>
      'DELIVER_INTERVENTION_PAST_DOSE_DELIVERY_DETAILS_2';
  String get wasDosePastDeliveryDetailPart3 =>
      'DELIVER_INTERVENTION_PAST_DOSE_DELIVERY_DETAILS_3';
}

class ProjectSelection {
  const ProjectSelection();

  String get projectDetailsLabelText => 'PROJECT_DETAILS_LABEL';

  String get syncInProgressTitleText => 'SYNC_IN_PROGRESS';

  String get syncCompleteTitleText => 'SYNC_COMPLETE';

  String get syncCompleteButtonText => 'CLOSE';

  String get syncFailedTitleText => 'SYNC_FAILED';

  String get retryButtonText => 'RETRY';

  String get dismissButtonText => 'DISMISS';

  String get noProjectsAssigned => 'NO_PROJECTS_ASSIGNED';

  String get contactSysAdmin => 'CONTACT_SYS_ADMIN';

  String get onProjectMapped => 'NO_PROJECT_MAPPED';
}

class WarehouseDetails {
  const WarehouseDetails();

  String get warehouseDetailsLabel => 'WAREHOUSE_DETAILS_LABEL';

  String get transactionDetailsLabel => 'TRANSACTION_DETAILS_LABEL';

  String get usDetails => 'US_DETAILS';

  String get dateOfReceipt => 'WAREHOUSE_DETAILS_DATE_OF_RECEIPT';

  String get dateOfIssue => 'WAREHOUSE_DETAILS_DATE_OF_ISSUE';

  String get dateOfReturn => 'WAREHOUSE_DETAILS_DATE_OF_RETURN';

  String get administrativeUnit => 'WAREHOUSE_DETAILS_ADMINISTRATIVE_UNIT';

  String get organizationUnit => 'WAREHOSUE_DETAILS_ORGANIZATION_UNIT';

  String get warehouseNameId => 'WAREHOSUE_DETAILS_WAREHOUSE_NAME_ID';

  String get usNameCommunitySupervisor => 'US_NAME_COMMUNITY_SUPERVISOR';
}

class StockDetails {
  const StockDetails();

  /// Page Title Keys
  String get receivedPageTitle => 'RECEIVED_STOCK_DETAILS';

  String get issuedPageTitle => 'ISSUED_STOCK_DETAILS';

  String get returnedPageTitle => 'RETURNED_STOCK_DETAILS';

  String get lostPageTitle => 'LOST_STOCK_DETAILS';

  String get damagedPageTitle => 'DAMAGED_STOCK_DETAILS';

  /// Select Product label
  String get selectProductLabel => 'STOCK_DETAILS_SELECT_PRODUCT';

  /// Select Transacting party label
  String get selectTransactingPartyReceived => 'STOCK_DETAILS_RECEIVED_FROM';

  String get selectTransactingPartyIssued => 'STOCK_DETAILS_ISSUED_TO';

  String get selectTransactingPartyReturned => 'STOCK_DETAILS_RETURNED_TO';

  String get selectTransactingPartyReceivedFromDamaged {
    return 'STOCK_DETAILS_RECEIVED_FROM_DAMAGED';
  }

  String get selectTransactingPartyReceivedFromLost {
    return 'STOCK_DETAILS_RECEIVED_FROM_LOST';
  }

  /// Quantity sent/received/lost/damaged label
  String get quantityReceivedLabel => 'STOCK_DETAILS_QUANTITY_RECEIVED_SPAQ';

  String get quantitySentLabel => 'STOCK_DETAILS_QUANTITY_SENT_SPAQ';

  String get quantityReturnedLabel => 'STOCK_DETAILS_QUANTITY_RETURNED_SPAQ';

  String get quantityPartialReturnedLabel =>
      'STOCK_DETAILS_PARTIAL_QUANTITY_RETURNED_SPAQ';

  String get quantityWastedReturnedLabel =>
      'STOCK_DETAILS_WASTED_QUANTITY_RETURNED_SPAQ';

  String get quantityLostLabel => 'STOCK_DETAILS_QUANTITY_LOST';

  String get quantityDamagedLabel => 'STOCK_DETAILS_QUANTITY_DAMAGED';

  /// Waybill number label
  String get waybillNumberLabel => 'STOCK_DETAILS_WAYBILL_NUMBER';

  /// Number of product indicated on waybill title
  String get quantityOfProductIndicatedOnWaybillLabel {
    return 'STOCK_DETAILS_WAYBILL_QUANTITY_SPAQ';
  }

  /// Lost/Damaged during label
  String get transactionReasonLost => 'STOCK_DETAILS_LOST_DURING';

  String get transactionReasonDamaged => 'STOCK_DETAILS_DAMAGED_DURING';

  String get vehicleNumberLabel => 'STOCK_DETAILS_VEHICLE_NUMBER';

  String get commentsLabel => 'STOCK_DETAILS_COMMENTS_LABEL';

  String get dialogTitle => 'STOCK_DETAILS_DIALOG_TITLE';

  String get dialogContent => 'STOCK_DETAILS_DIALOG_CONTENT';

  String get transportTypeLabel => 'STOCK_DETAILS_TRANSPORT_TYPE';

  String get receivedSpaqDetails => 'RECEIVED_SPAQ_DETAILS';
  String get selectSpaqVariant => 'SELECT_SPAQ_VARIANT';
  String get issuedSpaqDetails => 'ISSUED_SPAQ_DETAILS';
  String get returnedSpaqDetails => 'RETURNED_SPAQ_DETAILS';
  String get damagedSpaqDetails => 'DAMAGED_SPAQ_DETAILS';
  String get quantityDamagedCountLabel => 'STOCK_DAMAGED_QUANTITY_LABEL';

  String get batchNumberLabel => 'STOCK_DETAILS_BATCH_NUMBER';

  String get countDialogTitle => 'STOCK_DETAILS_COUNT_DIALOG_TITLE';

  String get countContent => 'STOCK_DETAILS_COUNT_DIALOG_CONTENT';

  String get countDialogSuccess =>
      'STOCK_DETAILS_COUNT_DIALOG_SUCCESS_ACTION_LABEL';

  String get countDialogCancel =>
      'STOCK_DETAILS_COUNT_DIALOG_CANCEL_ACTION_LABEL';
  String get scannedResources => 'SCANNED_RESOURCES';

  String get senderReceiverValidation =>
      'STOCK_DETAILS_SENDER_RECEIVER_ID_VALIDATION';
}

class StockReconciliationDetails {
  const StockReconciliationDetails();

  String get reconciliationPageTitle => 'STOCK_RECONCILIATION_PAGE_TITLE';

  String get facilityLabel => 'STOCK_RECONCILIATION_FACILITY_LABEL';
  String get facilityName => 'STOCK_RECONCILIATION_FACILITY_NAME';

  String get stockLabel => 'STOCK_LABEL';

  String get productLabel => 'STOCK_RECONCILIATION_PRODUCT_LABEL';

  String get spaqLabel => 'STOCK_RECONCILIATION_SPAQ_LABEL';

  String get dateOfReconciliation => 'STOCK_RECONCILIATION_DATE';

  String get stockReceived => 'STOCK_RECONCILIATION_STOCK_RECEIVED';

  String get stockIssued => 'STOCK_RECONCILIATION_STOCK_ISSUED';

  String get stockReturned => 'STOCK_RECONCILIATION_STOCK_RETURNED';

  String get stockLost => 'STOCK_RECONCILIATION_STOCK_LOST';

  String get stockDamaged => 'STOCK_RECONCILIATION_STOCK_DAMAGED';

  String get stockOnHand => 'STOCK_RECONCILIATION_STOCK_ON_HAND';

  String get manualCountLabel =>
      'STOCK_RECONCILIATION_MANUAL_STOCK_COUNT_LABEL';

  String get commentsLabel => 'STOCK_RECONCILIATION_COMMENTS_LABEL';

  String get infoCardTitle => 'STOCK_RECONCILIATION_INFO_CARD_TITLE';

  String get infoCardContent => 'STOCK_RECONCILIATION_INFO_CARD_CONTENT';
  String get infoCardDescription =>
      'STOCK_RECONCILIATION_INFO_CARD_DESCRIPTION_SPAQ';

  String get dialogTitle => 'STOCK_RECONCILIATION_DIALOG_TITLE';

  String get dialogContent => 'STOCK_RECONCILIATION_DIALOG_CONTENT';

  String get manualCountRequiredError =>
      'STOCK_RECONCILIATION_COUNT_IS_REQUIRED';

  String get manualCountInvalidType =>
      'STOCK_RECONCILIATION_COUNT_EXPECTS_NUMBER';

  String get manualCountMinError => 'STOCK_RECONCILIATION_COUNT_BELOW_MIN';

  String get manualCountMaxError => 'STOCK_RECONCILIATION_COUNT_EXCEEDED_MAX';

  String get noProjectSelected => 'NO_PROJECT_SELECTED';

  String get fieldRequired => 'STOCK_RECONCILIATION_FILED_REQUIRED';

  String get facilityNameCommunitySupervisor =>
      'FACILITY_NAME_COMMUNITY_SUPERVISOR';

  String get spaqReconciliation => 'SPAQ_RECONCILIATION';
  String get spaqReceived => 'SPAQ_RECEIVED';
  String get spaqIssued => 'SPAQ_ISSUED';
  String get spaqReturned => 'SPAQ_RETURNED';
  String get spaqDamaged => 'SPAQ_DAMAGED';
  String get spaqOnHand => 'SPAQ_ON_HAND';
  String get manualSpaqCount => 'MANUAL_SPAQ_COUNT';
  String get physicalSpaqCount => 'PHYSICAL_SPAQ_COUNT';
  String get reconciliationCommentRequiredError =>
      'SPAQ_RECONCILIATION_COMMENT_IS_REQUIRED';
  String get spaqSent => 'SPAQ_SENT';
  String get spaqTheoretical => 'SPAQ_THEORETICAL';
}

class ManageStock {
  const ManageStock();

  String get label => 'MANAGE_STOCK_LABEL';

  String get recordStockReceiptLabel =>
      'MANAGE_STOCK_RECORDSTOCK_RECEIPT_LABEL';

  String get recordStockReceiptDescription =>
      'MANAGE_STOCK_RECEIPT_DESCRIPTION';

  String get recordStockReceiptDistributorDescription =>
      'MANAGE_STOCK_RECEIPT_DISTRIBUTOR_DESCRIPTION';

  String get recordStockIssuedLabel => 'MANAGE_STOCK_RECORDSTOCK_ISSUED_LABEL';

  String get recordStockIssuedDescription =>
      'MANAGE_STOCK_RECORDSTOCK_ISSUED_DESCRIPTION';

  String get recordStockReturnedToLabel =>
      'MANAGE_STOCK_RECORDSTOCK_RETURNED_TO_LABEL';

  String get recordStockReturnedToDescription =>
      'MANAGE_STOCK_RECORDSTOCK_RETURNED_TO_DESCRIPTION';

  String get recordStockReturnedLabel =>
      'MANAGE_STOCK_RECORDSTOCK_RETURNED_LABEL';

  String get recordStockReturnedDescription =>
      'MANAGE_STOCK_RECORDSTOCK_RETURNED_DESCRIPTION';

  String get recordStockDamagedLabel =>
      'MANAGE_STOCK_RECORDSTOCK_DAMAGED_LABEL';

  String get recordStockDamagedDescription =>
      'MANAGE_STOCK_RECORDSTOCK_DAMAGED_DESCRIPTION';

  String get recordStockLossLabel => 'MANAGE_STOCK_RECORDSTOCK_LOSS_LABEL';

  String get recordStockLossDescription =>
      'MANAGE_STOCK_RECORDSTOCK_LOSS_DESCRIPTION';

  String get recordSpaqReceipt => 'RECORD_SPAQ_RECEIPT';
  String get recordSpaqReceivedAtFacility => 'RECORD_SPAQ_RECEIVED_AT_FACILITY';
  String get recordSpaqIssued => 'RECORD_SPAQ_ISSUED';
  String get spaqSentFromFacility => 'SPAQ_SENT_FROM_FACILITY';
  String get recordSpaqReturned => 'RECORD_SPAQ_RETURNED';
  String get recordSpaqReturnedToFacility => 'RECORD_SPAQ_RETURNED_TO_FACILITY';
  String get recordSpaqDamaged => 'RECORD_SPAQ_DAMAGED';
  String get recordListOfSpaqDamaged => 'RECORD_LIST_OF_SPAQ_DAMAGED';
  String get cddTeamCodeLabel => 'STOCK_CDD_TEAM_CODE_LABEL';
  String get cddSupervisorCodeLabel => 'STOCK_SUPERVISOR_CODE_LABEL';
  String get facilityRequired => 'STOCK_DETAILS_FACILITY_IS_REQUIRED';
  String get teamCodeRequired => 'STOCK_DETAILS_TEAM_CODE_IS_REQUIRED';
}

class Complaints {
  const Complaints();

  String get complaintsTypeHeading => 'COMPLAINTS_TYPE_HEADING';

  String get complaintsTypeLabel => 'COMPLAINTS_TYPE_LABEL';

  String get actionLabel => 'HOUSEHOLD_LOCATION_ACTION_LABEL';

  String get complaintsLocationLabel => 'COMPLAINTS_LOCATION_LABEL';

  String get complaintsDetailsLabel => 'COMPLAINTS_DETAILS_LABEL';

  String get dateOfComplaint => 'COMPLAINTS_DATE';

  String get complainantTypeQuestion => 'COMPLAINTS_COMPLAINANT_TYPE_QUESTION';

  String get complainantName => 'COMPLAINTS_COMPLAINANT_NAME';

  String get complainantContactNumber =>
      'COMPLAINTS_COMPLAINANT_CONTACT_NUMBER';

  String get supervisorName => 'COMPLAINTS_SUPERVISOR_NAME';

  String get supervisorContactNumber => 'COMPLAINTS_SUPERVISOR_CONTACT_NUMBER';

  String get complaintDescription => 'COMPLAINTS_DESCRIPTION';

  String get dialogTitle => 'COMPLAINTS_DIALOG_TITLE';

  String get dialogContent => 'COMPLAINTS_DIALOG_MESSAGE';

  String get fileComplaintAction => 'COMPLAINTS_FILE_COMPLAINT_ACTION';

  String get inboxHeading => 'COMPLAINTS_INBOX_HEADING';

  String get searchCTA => 'COMPLAINTS_INBOX_SEARCH_CTA';

  String get filterCTA => 'COMPLAINTS_INBOX_FILTER_CTA';

  String get sortCTA => 'COMPLAINTS_INBOX_SORT_CTA';

  String get complaintInboxFilterHeading => 'COMPLAINTS_INBOX_FILTER_HEADING';

  String get complaintsFilterClearAll => 'COMPLAINTS_FILTER_CLEAR_ALL';

  String get complaintInboxSearchHeading => 'COMPLAINTS_INBOX_SEARCH_HEADING';

  String get complaintInboxSortHeading => 'COMPLAINTS_INBOX_SORT_HEADING';

  String get complaintsSortDateAsc => 'COMPLAINT_SORT_DATE_ASC';

  String get complaintsSortDateDesc => 'COMPLAINT_SORT_DATE_DESC';

  String get assignedToAll => 'COMPLAINTS_ASSIGNED_TO_ALL';

  String get assignedToSelf => 'COMPLAINTS_ASSIGNED_TO_SELF';

  String get noComplaintsExist => 'COMPLAINTS_NO_COMPLAINTS_EXIST';

  String get validationRequiredError => 'COMPLAINTS_VALIDATION_REQUIRED_ERROR';

  String get inboxDateLabel => 'COMPLAINTS_INBOX_DATE_LABEL';

  String get inboxNumberLabel => 'COMPLAINTS_INBOX_NUMBER_LABEL';

  String get inboxTypeLabel => 'COMPLAINTS_INBOX_TYPE_LABEL';

  String get inboxAreaLabel => 'COMPLAINTS_INBOX_AREA_LABEL';

  String get inboxStatusLabel => 'COMPLAINTS_INBOX_STATUS_LABEL';

  String get inboxNotGeneratedLabel => 'COMPLAINTS_INBOX_NOT_GENERATED_LABEL';

  String get inboxSyncRequiredLabel => 'COMPLAINTS_INBOX_SYNC_REQUIRED_LABEL';

  String get raisedForMyself => 'COMPLAINTS_RAISED_FOR_MYSELF';
  String get validationMinLengthError =>
      'COMPLAINTS_VALIDATION_MINLENGTH_ERROR';

  String get raisedForAnotherUser => 'COMPLAINTS_RAISED_FOR_ANOTHER_USER';

  String get locality => 'COMPLAINTS_LOCALITY';

  String get backToInbox => 'COMPLAINTS_BACK_TO_INBOX';

  String get acknowledgementAction => 'COMPLAINTS_ACKNOWLEDGEMENT_ACTION';

  String get acknowledgementDescription =>
      'COMPLAINTS_ACKNOWLEDGEMENT_DESCRIPTION';

  String get acknowledgementLabel => 'COMPLAINTS_ACKNOWLEDGEMENT_LABEL';

  String get acknowledgementSubLabelMain =>
      'COMPLAINTS_ACKNOWLEDGEMENT_SUB_LABEL_MAIN';

  String get acknowledgementSubLabelSub =>
      'COMPLAINTS_ACKNOWLEDGEMENT_SUB_LABEL_SUB';

  String get complaintsError => 'COMPLAINTS_VALIDATION_REQUIRED_ERROR';

  String get validationRadioRequiredError =>
      'COMPLAINTS_VALIDATION_RADIO_REQUIRED_ERROR';
}

class ReasonForDeletion {
  const ReasonForDeletion();

  String get reasonForDeletionLabel => 'REASON_FOR_DELETION_LABEL';
}

class InventoryReportSelection {
  const InventoryReportSelection();

  String get label {
    return 'INVENTORY_REPORT_SELECTION_LABEL';
  }

  String get inventoryReportReceiptLabel {
    return 'INVENTORY_REPORT_SELECTION_RECEIPT_LABEL';
  }

  String get inventoryReportReceiptDescription {
    return 'INVENTORY_REPORT_SELECTION_RECEIPT_DESCRIPTION';
  }

  String get inventoryReportIssuedLabel {
    return 'INVENTORY_REPORT_SELECTION_ISSUED_LABEL';
  }

  String get inventoryReportIssuedDescription {
    return 'INVENTORY_REPORT_SELECTION_ISSUED_DESCRIPTION';
  }

  String get inventoryReportReturnedToLabel {
    return 'INVENTORY_REPORT_SELECTION_RETURNED_TO_LABEL';
  }

  String get inventoryReportReturnedToDescription {
    return 'INVENTORY_REPORT_SELECTION_RETURNED_TO_DESCRIPTION';
  }

  String get inventoryReportReturnedLabel {
    return 'INVENTORY_REPORT_SELECTION_RETURNED_LABEL';
  }

  String get inventoryReportReturnedDescription {
    return 'INVENTORY_REPORT_SELECTION_RETURNED_DESCRIPTION';
  }

  String get inventoryReportDamagedLabel {
    return 'INVENTORY_REPORT_SELECTION_DAMAGE_LABEL';
  }

  String get inventoryReportDamagedDescription {
    return 'INVENTORY_REPORT_SELECTION_DAMAGE_DESCRIPTION';
  }

  String get inventoryReportLossLabel {
    return 'INVENTORY_REPORT_SELECTION_LOSS_LABEL';
  }

  String get inventoryReportLossDescription {
    return 'INVENTORY_REPORT_SELECTION_LOSS_DESCRIPTION';
  }

  String get inventoryReportReconciliationLabel {
    return 'INVENTORY_REPORT_SELECTION_RECONCILIATION_LABEL';
  }

  String get inventoryReportReconciliationDescription {
    return 'INVENTORY_REPORT_SELECTION_RECONCILIATION_DESCRIPTION';
  }
}

class InventoryReportDetails {
  const InventoryReportDetails();

  String get backToHomeButtonLabel {
    return 'INVENTORY_REPORT_DETAILS_BACK_TO_HOME_BUTTON_LABEL';
  }

  String get receiptReportTitle {
    return 'INVENTORY_REPORT_DETAILS_RECEIPT_REPORT_TITLE';
  }

  String get dispatchReportTitle {
    return 'INVENTORY_REPORT_DETAILS_DISPATCH_REPORT_TITLE';
  }

  String get returnedReportTitle {
    return 'INVENTORY_REPORT_DETAILS_RETURNED_REPORT_TITLE';
  }

  String get damageReportTitle {
    return 'INVENTORY_REPORT_DETAILS_DAMAGE_REPORT_TITLE';
  }

  String get lossReportTitle {
    return 'INVENTORY_REPORT_DETAILS_LOSS_REPORT_TITLE';
  }

  String get reconciliationReportTitle {
    return 'INVENTORY_REPORT_DETAILS_RECONCILIATION_REPORT_TITLE';
  }

  String get dateLabel {
    return 'INVENTORY_REPORT_DETAILS_DATE_LABEL';
  }

  String get waybillLabel {
    return 'INVENTORY_REPORT_DETAILS_WAYBILL_LABEL';
  }

  String get receiptQuantityLabel {
    return 'INVENTORY_REPORT_DETAILS_RECEIPT_QUANTITY_LABEL';
  }

  String get dispatchQuantityLabel {
    return 'INVENTORY_REPORT_DETAILS_DISPATCH_QUANTITY_LABEL';
  }

  String get returnedQuantityLabel {
    return 'INVENTORY_REPORT_DETAILS_RETURNED_QUANTITY_LABEL';
  }

  String get partialReturnedQuantityLabel {
    return 'INVENTORY_REPORT_DETAILS_PARTIAL_RETURNED_QUANTITY_LABEL';
  }

  String get wastedReturnedQuantityLabel {
    return 'INVENTORY_REPORT_DETAILS_WASTED_RETURNED_QUANTITY_LABEL';
  }

  String get damagedQuantityLabel {
    return 'INVENTORY_REPORT_DETAILS_DAMAGED_QUANTITY_LABEL';
  }

  String get lossQuantityLabel {
    return 'INVENTORY_REPORT_DETAILS_LOSS_QUANTITY_LABEL';
  }

  String get receiptTransactingPartyLabel {
    return 'INVENTORY_REPORT_DETAILS_RECEIPT_TRANSACTING_PARTY_LABEL';
  }

  String get dispatchTransactingPartyLabel {
    return 'INVENTORY_REPORT_DETAILS_DISPATCH_TRANSACTING_PARTY_LABEL';
  }

  String get returnedTransactingPartyLabel {
    return 'INVENTORY_REPORT_DETAILS_RETURNED_TRANSACTING_PARTY_LABEL';
  }

  String get returnedToTransactingPartyLabel {
    return 'INVENTORY_REPORT_DETAILS_RETURNED_TO_TRANSACTING_PARTY_LABEL';
  }

  String get damagedTransactingPartyLabel {
    return 'INVENTORY_REPORT_DETAILS_DAMAGED_TRANSACTING_PARTY_LABEL';
  }

  String get lossTransactingPartyLabel {
    return 'INVENTORY_REPORT_DETAILS_LOSS_TRANSACTING_PARTY_LABEL';
  }

  String get stockInHandLabel {
    return 'INVENTORY_REPORT_DETAILS_STOCK_IN_HAND_LABEL';
  }

  String get manualCountLabel {
    return 'INVENTORY_REPORT_DETAILS_MANUAL_COUNT_LABEL';
  }

  String get receivedCountLabel {
    return 'INVENTORY_REPORT_DETAILS_RECEIVED_COUNT_LABEL';
  }

  String get dispatchedCountLabel {
    return 'INVENTORY_REPORT_DETAILS_DISPATCHED_COUNT_LABEL';
  }

  String get returnedCountLabel {
    return 'INVENTORY_REPORT_DETAILS_RETURNED_COUNT_LABEL';
  }

  String get damagedCountLabel {
    return 'INVENTORY_REPORT_DETAILS_DAMAGED_COUNT_LABEL';
  }

  String get lostCountLabel {
    return 'INVENTORY_REPORT_DETAILS_LOST_COUNT_LABEL';
  }

  String get noRecordsMessage {
    return 'INVENTORY_REPORT_DETAILS_NO_RECORDS_MESSAGE';
  }

  String get noFilterMessage {
    return 'INVENTORY_REPORT_DETAILS_NO_FILTER_MESSAGE';
  }
}

class SyncDialog {
  const SyncDialog();

  String get syncFailedTitle => 'SYNC_DIALOG_SYNC_FAILED_TITLE';

  String get downSyncFailedTitle => 'SYNC_DIALOG_DOWN_SYNC_FAILED_TITLE';

  String get upSyncFailedTitle => 'SYNC_DIALOG_UP_SYNC_FAILED_TITLE';

  String get syncInProgressTitle => 'SYNC_DIALOG_SYNC_IN_PROGRESS_TITLE';

  String get dataSyncedTitle => 'SYNC_DIALOG_DATA_SYNCED_TITLE';

  String get closeButtonLabel => 'SYNC_DIALOG_CLOSE_BUTTON_LABEL';

  String get retryButtonLabel => 'SYNC_DIALOG_RETRY_BUTTON_LABEL';
  String get pendingSyncLabel => 'PENDING_SYNC_LABEL';
  String get pendingSyncContent => 'PENDING_SYNC_CONTENT';
}

class ReferBeneficiary {
  const ReferBeneficiary();

  String get dateOfReferralLabel => 'REFER_BENEFICIARY_DATE_OF_REFERRAL_LABEL';
  String get dateOfEvaluationLabel =>
      'REFER_BENEFICIARY_DATE_OF_EVALUATION_LABEL';
  String get administrationUnitFormLabel => 'ADMINISTRATION_UNIT_FORM_LABEL';
  String get organizationUnitFormLabel => 'ORGANIZATION_UNIT_FORM_LABEL';
  String get referredByLabel => 'REFERRED_BY_FORM_LABEL';
  String get referredToLabel => 'REFERRED_TO_FORM_LABEL';
  String get reasonForReferral => 'REASON_FOR_REFERRAL';
  String get referralComments => 'REFERRAL_COMMENTS';
  String get referralDetails => 'REFERRAL_DETAILS_HEADER';
  String get facilityValidationMessage => 'PLEASE_ENTER_VALID_FACILITY';
  String get facilityDetails => 'FACILITY_DETAILS_HEADER';
  String get evaluationFacilityLabel => 'EVALUATION_FACILITY_LABEL';
  String get nameOfHealthFacilityCoordinatorLabel =>
      'NAME_OF_HEALTH_FACILITY_COORDINATOR';
  String get healthFacilityCoordinatorLabel => 'NAME_OF_HF_COORDINATOR_LABEL';
  String get nameOfTheChildLabel => 'REFERRAL_NAME_OF_CHILD_LABEL';
  String get beneficiaryIdLabel => 'REFERRAL_BENEFICIARY_ID_LABEL';
  String get referralCodeLabel => 'REFERRAL_CODE_LABEL';
  String get reasonForReferralHeader => 'REASON_FOR_REFERRAL_HEADER';
  String get searchReferralsHeader => 'SEARCH_REFERRALS_HEADER';
  String get referredByTeamCodeLabel => 'REFERRED_BY_TEAM_CODE_LABEL';
  String get selectCycle => 'REFERRAL_SELECT_CYCLE';
  String get createReferralLabel => 'CREATE_REFERRAL_LABEL';
  String get noChecklistFound => 'NO_CHECKLISTS_FOUND';
  String get dialogTitle => 'REFERRAL_CONFIRMATION_DIALOG_TITLE';
  String get dialogContent => 'REFERRAL_CONFIRMATION_DIALOG_CONTENT';
  String get dialogSuccess => 'REFERRAL_CONFIRMATION_SUCCESS_LABEL';
  String get dialogCancel => 'REFERRAL_CONFIRMATION_CANCEL_LABEL';
  String get referredDialogTitle => 'REFERRAL_CONFIRMATION_DIALOG_BOX_TITLE';
  String get referredDialogContent =>
      'REFERRAL_CONFIRMATION_DIALOG_BOX_CONTENT';
  String get referAlertDialogTitle => 'REFERRAL_ALERT_DIALOG_TITLE';
  String get referAlertDialogContent => 'REFERRAL_ALERT_DIALOG_CONTENT';
}

class IneligibilityReasons {
  const IneligibilityReasons();

  String get dialogTitle => 'INELIGIBILITY_REASONS_DIALOG_TITLE';
  String get dialogContent => 'INELIGIBILITY_REASONS_DIALOG_CONTENT';
  String get ineligibilityReasonsLabel => 'INELIGIBILITY_REASONS_LABEL';
  String get selectReasonsLabel => 'INELIGIBILITY_REASONS_SELECT_LABEL';
}

class Scanner {
  const Scanner();

  String get changingCameraLens => 'CHANGING_CAMERA_LENS';
  String get flashOn => 'FLASH_ON';
  String get flashOff => 'FLASH_OFF';
  String get scannerLabel => 'SCANNER_LABEL';
  String get barCodeScannerLabel => 'BARCODE_SCANNER';
  String get manualScan => 'MANUAL_SCAN';
  String get enterManualCode => 'ENTER_MANUAL_CODE';
  String get resourcesScanned => 'RESOURCE_SCANNED';
  String get resourceAlreadyScanned => 'RESOURCES_ALREADY_SCANNED';
  String get manualCodeDescription => 'MANUAL_CODE_DESC';
  String get resourceCode => 'RESOURCE_CODE';
  String get scannerDialogTitle => 'SCANNER_DIALOG_TITLE';
  String get scannerDialogContent => 'SCANNER_DIALOG_CONTENT';
  String get scannerDialogPrimaryAction => 'SCANNER_DIALOG_PRIMARY_ACTION';
  String get scannerDialogSecondaryAction => 'SCANNER_DIALOG_SECONDARY_ACTION';
  String get scannedResourceCountMisMatch => 'SCANNED_RESOURCE_COUNT_MISMATCH';
  String get barCodesFound => 'BARCODES_FOUND';
  String get barCode => 'BARCODE';
  String get scanBales => 'CORE_COMMON_SCAN_BALES';
}
