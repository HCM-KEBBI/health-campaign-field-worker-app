// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

import 'data_model.dart' as p0;
import 'entities/additional_fields_type.dart' as p1;
import 'entities/address.dart' as p2;
import 'entities/address_type.dart' as p3;
import 'entities/attributes.dart' as p4;
import 'entities/beneficiary_type.dart' as p5;
import 'entities/blood_group.dart' as p6;
import 'entities/boundary.dart' as p7;
import 'entities/deliver_strategy_type.dart' as p8;
import 'entities/document.dart' as p9;
import 'entities/downsync.dart' as p10;
import 'entities/facility.dart' as p11;
import 'entities/gender.dart' as p12;
import 'entities/h_f_referral.dart' as p13;
import 'entities/hcm_attendance_log_model.dart' as p14;
import 'entities/hcm_attendance_model.dart' as p15;
import 'entities/household.dart' as p16;
import 'entities/household_member.dart' as p17;
import 'entities/identifier.dart' as p18;
import 'entities/identifier_types.dart' as p19;
import 'entities/individual.dart' as p20;
import 'entities/locality.dart' as p21;
import 'entities/name.dart' as p22;
import 'entities/product.dart' as p23;
import 'entities/product_variant.dart' as p24;
import 'entities/project.dart' as p25;
import 'entities/project_beneficiary.dart' as p26;
import 'entities/project_facility.dart' as p27;
import 'entities/project_product_variant.dart' as p28;
import 'entities/project_resource.dart' as p29;
import 'entities/project_staff.dart' as p30;
import 'entities/project_type.dart' as p31;
import 'entities/referral.dart' as p32;
import 'entities/roles_type.dart' as p33;
import 'entities/service.dart' as p34;
import 'entities/service_attributes.dart' as p35;
import 'entities/service_definition.dart' as p36;
import 'entities/side_effect.dart' as p37;
import 'entities/status.dart' as p38;
import 'entities/stock.dart' as p39;
import 'entities/stock_reconciliation.dart' as p40;
import 'entities/target.dart' as p41;
import 'entities/task.dart' as p42;
import 'entities/task_resource.dart' as p43;
import 'entities/transaction_reason.dart' as p44;
import 'entities/transaction_type.dart' as p45;
import 'entities/user.dart' as p46;
import 'oplog/oplog_entry.dart' as p47;
import 'pgr_complaints/pgr_address.dart' as p48;
import 'pgr_complaints/pgr_complaints.dart' as p49;
import 'pgr_complaints/pgr_complaints_response.dart' as p50;
import 'package:attendance_management/models/attendance_register.dart' as p51;
import 'package:attendance_management/models/staff.dart' as p52;
import 'package:attendance_management/models/attendance_audit.dart' as p53;
import 'package:attendance_management/models/attendance_log.dart' as p54;
import 'package:attendance_management/models/attendee.dart' as p55;

void initializeMappers() {
  p0.EntityModelMapper.ensureInitialized();
  p0.EntitySearchModelMapper.ensureInitialized();
  p0.AdditionalFieldsMapper.ensureInitialized();
  p0.AdditionalFieldMapper.ensureInitialized();
  p0.ClientAuditDetailsMapper.ensureInitialized();
  p0.AuditDetailsMapper.ensureInitialized();
  p1.AdditionalFieldsTypeMapper.ensureInitialized();
  p2.AddressSearchModelMapper.ensureInitialized();
  p2.AddressModelMapper.ensureInitialized();
  p2.AddressAdditionalFieldsMapper.ensureInitialized();
  p3.AddressTypeMapper.ensureInitialized();
  p4.AttributesSearchModelMapper.ensureInitialized();
  p4.AttributesModelMapper.ensureInitialized();
  p4.AttributesAdditionalFieldsMapper.ensureInitialized();
  p5.BeneficiaryTypeMapper.ensureInitialized();
  p6.BloodGroupMapper.ensureInitialized();
  p7.BoundarySearchModelMapper.ensureInitialized();
  p7.BoundaryModelMapper.ensureInitialized();
  p8.DeliverStrategyTypeMapper.ensureInitialized();
  p9.DocumentSearchModelMapper.ensureInitialized();
  p9.DocumentModelMapper.ensureInitialized();
  p9.DocumentAdditionalFieldsMapper.ensureInitialized();
  p10.DownsyncSearchModelMapper.ensureInitialized();
  p10.DownsyncModelMapper.ensureInitialized();
  p10.DownsyncAdditionalFieldsMapper.ensureInitialized();
  p11.FacilitySearchModelMapper.ensureInitialized();
  p11.FacilityModelMapper.ensureInitialized();
  p11.FacilityAdditionalFieldsMapper.ensureInitialized();
  p12.GenderMapper.ensureInitialized();
  p13.HFReferralSearchModelMapper.ensureInitialized();
  p13.HFReferralModelMapper.ensureInitialized();
  p13.HFReferralAdditionalFieldsMapper.ensureInitialized();
  p14.HCMAttendanceLogSearchModelMapper.ensureInitialized();
  p14.HCMAttendanceLogModelMapper.ensureInitialized();
  p15.HCMAttendanceSearchModelMapper.ensureInitialized();
  p15.HCMAttendanceRegisterModelMapper.ensureInitialized();
  p15.HCMAttendanceAdditionalModelMapper.ensureInitialized();
  p16.HouseholdSearchModelMapper.ensureInitialized();
  p16.HouseholdModelMapper.ensureInitialized();
  p16.HouseholdAdditionalFieldsMapper.ensureInitialized();
  p17.HouseholdMemberSearchModelMapper.ensureInitialized();
  p17.HouseholdMemberModelMapper.ensureInitialized();
  p17.HouseholdMemberAdditionalFieldsMapper.ensureInitialized();
  p18.IdentifierSearchModelMapper.ensureInitialized();
  p18.IdentifierModelMapper.ensureInitialized();
  p18.IdentifierAdditionalFieldsMapper.ensureInitialized();
  p19.IdentifierTypesMapper.ensureInitialized();
  p20.IndividualSearchModelMapper.ensureInitialized();
  p20.IndividualModelMapper.ensureInitialized();
  p20.IndividualAdditionalFieldsMapper.ensureInitialized();
  p21.LocalitySearchModelMapper.ensureInitialized();
  p21.LocalityModelMapper.ensureInitialized();
  p21.LocalityAdditionalFieldsMapper.ensureInitialized();
  p22.NameSearchModelMapper.ensureInitialized();
  p22.NameModelMapper.ensureInitialized();
  p22.NameAdditionalFieldsMapper.ensureInitialized();
  p23.ProductSearchModelMapper.ensureInitialized();
  p23.ProductModelMapper.ensureInitialized();
  p23.ProductAdditionalFieldsMapper.ensureInitialized();
  p24.ProductVariantSearchModelMapper.ensureInitialized();
  p24.ProductVariantModelMapper.ensureInitialized();
  p24.ProductVariantAdditionalFieldsMapper.ensureInitialized();
  p25.ProjectSearchModelMapper.ensureInitialized();
  p25.ProjectModelMapper.ensureInitialized();
  p25.ProjectAdditionalFieldsMapper.ensureInitialized();
  p26.ProjectBeneficiarySearchModelMapper.ensureInitialized();
  p26.ProjectBeneficiaryModelMapper.ensureInitialized();
  p26.ProjectBeneficiaryAdditionalFieldsMapper.ensureInitialized();
  p27.ProjectFacilitySearchModelMapper.ensureInitialized();
  p27.ProjectFacilityModelMapper.ensureInitialized();
  p27.ProjectFacilityAdditionalFieldsMapper.ensureInitialized();
  p28.ProjectProductVariantSearchModelMapper.ensureInitialized();
  p28.ProjectProductVariantModelMapper.ensureInitialized();
  p28.ProjectProductVariantAdditionalFieldsMapper.ensureInitialized();
  p29.ProjectResourceSearchModelMapper.ensureInitialized();
  p29.ProjectResourceModelMapper.ensureInitialized();
  p29.ProjectResourceAdditionalFieldsMapper.ensureInitialized();
  p30.ProjectStaffSearchModelMapper.ensureInitialized();
  p30.ProjectStaffModelMapper.ensureInitialized();
  p30.ProjectStaffAdditionalFieldsMapper.ensureInitialized();
  p31.ProjectTypeSearchModelMapper.ensureInitialized();
  p31.ProjectTypeModelMapper.ensureInitialized();
  p31.ProjectTypeAdditionalFieldsMapper.ensureInitialized();
  p32.ReferralSearchModelMapper.ensureInitialized();
  p32.ReferralModelMapper.ensureInitialized();
  p32.ReferralAdditionalFieldsMapper.ensureInitialized();
  p33.RolesTypeMapper.ensureInitialized();
  p34.ServiceSearchModelMapper.ensureInitialized();
  p34.ServiceModelMapper.ensureInitialized();
  p34.ServiceAdditionalFieldsMapper.ensureInitialized();
  p35.ServiceAttributesSearchModelMapper.ensureInitialized();
  p35.ServiceAttributesModelMapper.ensureInitialized();
  p35.ServiceAttributesAdditionalFieldsMapper.ensureInitialized();
  p36.ServiceDefinitionSearchModelMapper.ensureInitialized();
  p36.ServiceDefinitionModelMapper.ensureInitialized();
  p36.ServiceDefinitionAdditionalFieldsMapper.ensureInitialized();
  p37.SideEffectSearchModelMapper.ensureInitialized();
  p37.SideEffectModelMapper.ensureInitialized();
  p37.SideEffectAdditionalFieldsMapper.ensureInitialized();
  p38.StatusMapper.ensureInitialized();
  p39.StockSearchModelMapper.ensureInitialized();
  p39.StockModelMapper.ensureInitialized();
  p39.StockAdditionalFieldsMapper.ensureInitialized();
  p40.StockReconciliationSearchModelMapper.ensureInitialized();
  p40.StockReconciliationModelMapper.ensureInitialized();
  p40.StockReconciliationAdditionalFieldsMapper.ensureInitialized();
  p41.TargetSearchModelMapper.ensureInitialized();
  p41.TargetModelMapper.ensureInitialized();
  p41.TargetAdditionalFieldsMapper.ensureInitialized();
  p42.TaskSearchModelMapper.ensureInitialized();
  p42.TaskModelMapper.ensureInitialized();
  p42.TaskAdditionalFieldsMapper.ensureInitialized();
  p43.TaskResourceSearchModelMapper.ensureInitialized();
  p43.TaskResourceModelMapper.ensureInitialized();
  p43.TaskResourceAdditionalFieldsMapper.ensureInitialized();
  p44.TransactionReasonMapper.ensureInitialized();
  p45.TransactionTypeMapper.ensureInitialized();
  p46.UserSearchModelMapper.ensureInitialized();
  p46.UserModelMapper.ensureInitialized();
  p46.UserAdditionalFieldsMapper.ensureInitialized();
  p47.OpLogEntryMapper.ensureInitialized();
  p47.AdditionalIdMapper.ensureInitialized();
  p47.DataOperationMapper.ensureInitialized();
  p47.ApiOperationMapper.ensureInitialized();
  p48.PgrAddressModelMapper.ensureInitialized();
  p48.GeoLocationMapper.ensureInitialized();
  p49.PgrComplaintModelMapper.ensureInitialized();
  p49.PgrComplainantModelMapper.ensureInitialized();
  p49.PgrRolesModelMapper.ensureInitialized();
  p49.PgrServiceSearchModelMapper.ensureInitialized();
  p49.PgrServiceModelMapper.ensureInitialized();
  p49.PgrWorkflowModelMapper.ensureInitialized();
  p49.PgrFiltersMapper.ensureInitialized();
  p49.PgrSearchKeysMapper.ensureInitialized();
  p49.PgrAdditionalDetailsMapper.ensureInitialized();
  p49.PgrServiceApplicationStatusMapper.ensureInitialized();
  p50.PgrServiceCreateResponseModelMapper.ensureInitialized();
  p50.PgrComplaintResponseModelMapper.ensureInitialized();
  p50.PgrComplainantResponseModelMapper.ensureInitialized();
  p50.PgrServiceResponseModelMapper.ensureInitialized();
  p51.AttendanceRegisterModelMapper.ensureInitialized();
  p52.StaffModelMapper.ensureInitialized();
  p53.AttendanceAuditDetailsMapper.ensureInitialized();
  p54.AttendanceLogModelMapper.ensureInitialized();
  p55.AttendeeModelMapper.ensureInitialized();
}
