import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:health_campaign_field_worker_app/pages/beneficiary/widgets/consent_household_acknowledgement.dart';
import 'package:registration_delivery/pages/beneficiary/delivery_summary_page.dart';
import 'package:registration_delivery/pages/search_beneficiary.dart';
import 'package:registration_delivery/router/registration_delivery_router.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';

import '../blocs/beneficiary_registration/beneficiary_registration.dart';
import '../blocs/inventory_report/inventory_report.dart';
import '../blocs/localization/app_localization.dart';
import '../blocs/record_stock/record_stock.dart';
import '../blocs/search_households/search_households.dart';
import '../models/data_model.dart';
import '../pages/acknowledgement.dart';
import '../pages/authenticated.dart';
import '../pages/beneficiary/beneficiary_details.dart';
import '../pages/beneficiary/beneficiary_wrapper.dart';
import '../pages/beneficiary/deliver_intervention.dart';
import '../pages/beneficiary/dose_administered.dart';
import '../pages/beneficiary/dose_administered_verification.dart';
import '../pages/beneficiary/household_overview.dart';
import '../pages/beneficiary/ineligibility_reasons.dart';
import '../pages/beneficiary/record_past_delivery_details.dart';
import '../pages/beneficiary/record_redose.dart';
import '../pages/beneficiary/refer_beneficiary.dart';
import '../pages/beneficiary/side_effects.dart';
import '../pages/beneficiary/widgets/household_acknowledgement.dart';
import '../pages/beneficiary/widgets/splash_acknowledgement.dart';
import '../pages/beneficiary_registration/beneficiary_acknowledgement.dart';
import '../pages/beneficiary_registration/beneficiary_registration_wrapper.dart';
import '../pages/beneficiary_registration/household_details.dart';
import '../pages/beneficiary_registration/household_location.dart';
import '../pages/beneficiary_registration/individual_details.dart';
import '../pages/boundary_selection.dart';
import '../pages/checklist/checklist.dart';
import '../pages/checklist/checklist_boundary_view.dart';
import '../pages/checklist/checklist_eligibility_assessment.dart';
import '../pages/checklist/checklist_preview.dart';
import '../pages/checklist/checklist_view.dart';
import '../pages/checklist/checklist_wrapper.dart';
import '../pages/complaints/inbox/complaints_details_view.dart';
import '../pages/complaints/inbox/complaints_inbox.dart';
import '../pages/complaints/inbox/complaints_inbox_filter.dart';
import '../pages/complaints/inbox/complaints_inbox_search.dart';
import '../pages/complaints/inbox/complaints_inbox_sort.dart';
import '../pages/complaints/inbox/complaints_inbox_wrapper.dart';
import '../pages/complaints/registration/complaint_type.dart';
import '../pages/complaints/registration/complaints_details.dart';
import '../pages/complaints/registration/complaints_location.dart';
import '../pages/complaints/registration/complaints_registration_wrapper.dart';
import '../pages/complaints_acknowledgement.dart';
import '../pages/consent/household_consent.dart';
// import '../pages/custom_search_beneficiary.dart';
import '../pages/custom_search_beneficiary.dart';
import '../pages/health_field_worker/create_referral/create_hf_referral_wrapper.dart';
import '../pages/health_field_worker/create_referral/reason_checklist_preview.dart';
import '../pages/health_field_worker/create_referral/record_facility_details.dart';
import '../pages/health_field_worker/create_referral/record_reason_checklist.dart';
import '../pages/health_field_worker/create_referral/record_referral_details.dart';
import '../pages/home.dart';
import '../pages/inventory/facility_selection.dart';
import '../pages/inventory/manage_stocks.dart';
import '../pages/inventory/project_facility_selection.dart';
import '../pages/inventory/record_stock/record_stock_wrapper.dart';
import '../pages/inventory/record_stock/stock_details.dart';
import '../pages/inventory/record_stock/warehouse_details.dart';
import '../pages/inventory/reports/performance_summary_report_details.dart';
import '../pages/inventory/reports/report_details.dart';
import '../pages/inventory/reports/report_selection.dart';
import '../pages/inventory/stock_reconciliation/stock_reconciliation.dart';
import '../pages/login.dart';
import '../pages/profile.dart';
import '../pages/project_selection.dart';
import '../pages/qr_details_page.dart';
import '../pages/reason_for_deletion.dart';
import '../pages/reports/beneficiary/beneficaries_report.dart';
// import '../pages/search_beneficiary.dart';
import '../pages/search_referrals.dart';
import '../pages/unauthenticated.dart';

import 'package:registration_delivery/blocs/app_localization.dart';

export 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  // INFO : Need to add the router modules here
  modules: [
    RegistrationDeliveryRoute,
  ],
)
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> routes = [
    AutoRoute(
      page: UnauthenticatedRouteWrapper.page,
      path: '/',
      children: [
        AutoRoute(page: LoginRoute.page, path: 'login', initial: true),
      ],
    ),
    AutoRoute(
      page: AuthenticatedRouteWrapper.page,
      path: '/',
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),

        AutoRoute(
          page: RegistrationDeliveryWrapperRoute.page,
          path: 'registration-delivery-wrapper',
          children: [
            // AutoRoute(
            //   page: SearchBeneficiaryRoute.page,
            //   path: 'search-beneficiary',
            // ),
            AutoRoute(
              page: CustomSearchBeneficiaryRoute.page,
              path: 'custom-search-beneficiary',
              initial: true,
            ),
            // RedirectRoute(
            //   path: 'search-beneficiary',
            //   redirectTo: 'custom-search-beneficiary',
            // ),

            AutoRoute(
              page: FacilitySelectionRoute.page,
              path: 'select-facilities',
            ),

            /// Beneficiary Registration
            AutoRoute(
              page: BeneficiaryRegistrationWrapperRoute.page,
              path: 'beneficiary-registration',
              children: [
                AutoRoute(
                  page: IndividualDetailsRoute.page,
                  path: 'individual-details',
                ),
                RedirectRoute(
                  path: 'individual-details',
                  redirectTo: 'custom-individual-details-smc',
                ),
                AutoRoute(
                  page: HouseHoldDetailsRoute.page,
                  path: 'household-details',
                ),
                RedirectRoute(
                  path: 'household-details',
                  redirectTo: 'custom-household-details-smc',
                ),
                AutoRoute(
                  page: HouseholdLocationRoute.page,
                  path: 'household-location',
                ),
                RedirectRoute(
                  path: 'household-location',
                  redirectTo: 'custom-household-location-smc',
                ),
                AutoRoute(
                  page: BeneficiaryAcknowledgementRoute.page,
                  path: 'beneficiary-acknowledgement',
                ),
                RedirectRoute(
                  path: 'beneficiary-acknowledgement',
                  redirectTo: 'custom-beneficiary-acknowledgement-smc',
                ),
                AutoRoute(
                  page: HouseDetailsRoute.page,
                  path: 'house-details',
                ),
                RedirectRoute(
                  path: 'house-details',
                  redirectTo: 'custom-house-details',
                ),
                AutoRoute(
                  page: SummaryRoute.page,
                  path: 'beneficiary-summary',
                ),
                AutoRoute(
                  page: BeneficiaryChecklistRoute.page,
                  path: 'beneficiary-checklist',
                ),
                AutoRoute(page: ChecklistViewRoute.page, path: 'view'),
                RedirectRoute(
                  path: 'beneficiary-summary',
                  redirectTo: 'ineligible-beneficiary-summary',
                ),
              ],
            ),
            AutoRoute(
              page: BeneficiaryWrapperRoute.page,
              path: 'beneficiary',
              children: [
                AutoRoute(
                  page: BeneficiaryChecklistRoute.page,
                  path: 'beneficiary-checklist',
                ),
                AutoRoute(
                  page: HouseholdOverviewRoute.page,
                  path: 'overview',
                ),
                RedirectRoute(
                  path: 'overview',
                  redirectTo: 'custom-overview',
                ),
                AutoRoute(
                  page: BeneficiaryDetailsRoute.page,
                  path: 'beneficiary-details',
                ),
                RedirectRoute(
                  path: 'beneficiary-details',
                  redirectTo: 'custom-beneficiary-details-smc',
                ),
                AutoRoute(
                  page: DeliverInterventionRoute.page,
                  path: 'deliver-intervention',
                ),
                RedirectRoute(
                  path: 'deliver-intervention',
                  redirectTo: 'custom-deliver-intervention-smc',
                ),
                AutoRoute(
                  page: EligibilityChecklistViewRoute.page,
                  path: 'eligibility-checklist',
                ),
                AutoRoute(
                  page: RefusedDeliveryRoute.page,
                  path: 'refused-delivery',
                ),
                RedirectRoute(
                  path: 'refused-delivery',
                  redirectTo: 'custom-refused-delivery',
                ),
                AutoRoute(
                  page: SideEffectsRoute.page,
                  path: 'side-effects',
                ),
                AutoRoute(
                  page: ReferBeneficiaryRoute.page,
                  path: 'refer-beneficiary',
                ),
                AutoRoute(
                  page: DoseAdministeredRoute.page,
                  path: 'dose-administered',
                ),
                AutoRoute(
                  page: SplashAcknowledgementRoute.page,
                  path: 'splash-acknowledgement',
                ),
                AutoRoute(
                  page: ReasonForDeletionRoute.page,
                  path: 'reason-for-deletion',
                ),
                AutoRoute(
                  page: RecordPastDeliveryDetailsRoute.page,
                  path: 'record-past-delivery-details',
                ),
                AutoRoute(
                  page: HouseholdAcknowledgementRoute.page,
                  path: 'household-acknowledgement',
                ),
                RedirectRoute(
                  path: 'household-acknowledgement',
                  redirectTo: 'custom-household-acknowledgement-smc',
                ),
                AutoRoute(
                  page: ChecklistViewRoute.page,
                  path: 'view',
                ),
                AutoRoute(
                  page: DeliverySummaryRoute.page,
                  path: 'delivery-summary',
                ),
                RedirectRoute(
                  path: 'delivery-summary',
                  redirectTo: 'custom-delivery-summary-smc',
                ),
                AutoRoute(
                  page: DoseAdministeredVerificationRoute.page,
                  path: 'dose-administered-verification',
                ),
              ],
            ),
          ],
        ),

        // AutoRoute(
        //     page: SearchBeneficiaryRoute.page, path: 'search-beneficiary'),
        //AutoRoute(page: QRScannerPage, path: 'scanner'),
        AutoRoute(
          page: BeneficiariesReportRoute.page,
          path: 'beneficiary-downsync-report',
        ),

        /// Beneficiary Registration
        AutoRoute(
          page: BeneficiaryRegistrationWrapperRoute.page,
          path: 'beneficiary-registration',
          children: [
            AutoRoute(
              page: IndividualDetailsRoute.page,
              path: 'individual-details',
            ),
            AutoRoute(
              page: HouseHoldDetailsRoute.page,
              path: 'household-details',
            ),
            AutoRoute(
              page: HouseHoldConsentRoute.page,
              path: 'household-consent',
            ),
            AutoRoute(
              page: HouseholdLocationRoute.page,
              path: 'household-location',
              initial: true,
            ),
            AutoRoute(
              page: ConsentHouseholdAcknowledgementRoute.page,
              path: 'consent-household-acknowledgement',
            ),
          ],
        ),
        AutoRoute(
          page: BeneficiaryWrapperRoute.page,
          path: 'beneficiary',
          children: [
            AutoRoute(
              page: HouseholdOverviewRoute.page,
              path: 'overview',
              initial: true,
            ),
            AutoRoute(
              page: BeneficiaryDetailsRoute.page,
              path: 'beneficiary-details',
            ),
            AutoRoute(
              page: DeliverInterventionRoute.page,
              path: 'deliver-intervention',
            ),
            AutoRoute(
              page: EligibilityChecklistViewRoute.page,
              path: 'eligibility-checklist',
            ),
            AutoRoute(
              page: SideEffectsRoute.page,
              path: 'side-effects',
            ),
            AutoRoute(
              page: ReferBeneficiaryRoute.page,
              path: 'refer-beneficiary',
            ),
            AutoRoute(
              page: IneligibilityReasonsRoute.page,
              path: 'ineligibility-reasons',
            ),
            AutoRoute(
              page: DoseAdministeredVerificationRoute.page,
              path: 'dose-administered-verification',
            ),
            AutoRoute(
              page: DoseAdministeredRoute.page,
              path: 'dose-administered',
            ),
            AutoRoute(
              page: RecordRedoseRoute.page,
              path: 'record-redose',
            ),
            AutoRoute(
              page: SplashAcknowledgementRoute.page,
              path: 'splash-acknowledgement',
            ),
            AutoRoute(
              page: ReasonForDeletionRoute.page,
              path: 'reason-for-deletion',
            ),
            AutoRoute(
              page: RecordPastDeliveryDetailsRoute.page,
              path: 'record-past-delivery-details',
            ),
            AutoRoute(
              page: HouseholdAcknowledgementRoute.page,
              path: 'household-acknowledgement',
            ),
            AutoRoute(page: ChecklistViewRoute.page, path: 'view'),
          ],
        ),
        AutoRoute(
          page: PerformamnceSummaryReportDetailsRoute.page,
          path: 'performance-summary-report-details',
        ),

        AutoRoute(
            page: ChecklistWrapperRoute.page,
            path: 'checklist',
            children: [
              AutoRoute(
                page: ChecklistRoute.page,
                path: '',
              ),
              AutoRoute(
                  page: ChecklistBoundaryViewRoute.page, path: 'view-boundary'),
              AutoRoute(page: ChecklistViewRoute.page, path: 'view'),
              AutoRoute(page: ChecklistPreviewRoute.page, path: 'preview'),
            ]),
        AutoRoute(
          page: BeneficiaryAcknowledgementRoute.page,
          path: 'beneficiary-acknowledgement',
        ),
        AutoRoute(page: AcknowledgementRoute.page, path: 'acknowledgement'),
        AutoRoute(
          page: ComplaintsAcknowledgementRoute.page,
          path: 'complaints-acknowledgement',
        ),

        /// Inventory Routes
        AutoRoute(
          page: RecordStockWrapperRoute.page,
          path: 'record-stock',
          children: [
            AutoRoute(
              page: WarehouseDetailsRoute.page,
              path: 'warehouse-details',
              initial: true,
            ),
            AutoRoute(page: StockDetailsRoute.page, path: 'details'),
          ],
        ),
        AutoRoute(page: SearchReferralsRoute.page, path: 'search-referrals'),
        AutoRoute(
          page: HFCreateReferralWrapperRoute.page,
          path: 'hf-referral',
          children: [
            AutoRoute(
              page: ReferralFacilityRoute.page,
              path: 'facility-details',
              initial: true,
            ),
            AutoRoute(
              page: RecordReferralDetailsRoute.page,
              path: 'referral-details',
            ),
            AutoRoute(
              page: ReferralReasonChecklistRoute.page,
              path: 'referral-reason',
            ),
            AutoRoute(
              page: ReferralReasonCheckListPreviewRoute.page,
              path: 'referral-reason-view',
            ),
          ],
        ),
        AutoRoute(page: ManageStocksRoute.page, path: 'manage-stocks'),
        AutoRoute(
            page: StockReconciliationRoute.page, path: 'stock-reconciliation'),
        AutoRoute(
          page: FacilitySelectionRoute.page,
          path: 'select-facilities',
        ),
        AutoRoute(
          page: ProjectFacilitySelectionRoute.page,
          path: 'select-project-facilities',
        ),
        AutoRoute(
          page: InventoryReportSelectionRoute.page,
          path: 'inventory-report-selection',
        ),
        AutoRoute(
          page: InventoryReportDetailsRoute.page,
          path: 'inventory-report-details',
        ),

        /// Project Selection
        AutoRoute(
          page: ProjectSelectionRoute.page,
          path: 'select-project',
          initial: true,
        ),

        /// Boundary Selection
        AutoRoute(
          page: BoundarySelectionRoute.page,
          path: 'select-boundary',
        ),

        AutoRoute(page: UserQRDetailsRoute.page, path: 'user-qr-code'),

        /// Complaints Inbox
        AutoRoute(
          page: ComplaintsInboxWrapperRoute.page,
          path: 'complaints-inbox',
          children: [
            AutoRoute(
              page: ComplaintsInboxRoute.page,
              path: 'complaints-inbox-items',
              initial: true,
            ),
            AutoRoute(
              page: ComplaintsInboxFilterRoute.page,
              path: 'complaints-inbox-filter',
            ),
            AutoRoute(
              page: ComplaintsInboxSearchRoute.page,
              path: 'complaints-inbox-search',
            ),
            AutoRoute(
              page: ComplaintsInboxSortRoute.page,
              path: 'complaints-inbox-sort',
            ),
            AutoRoute(
              page: ComplaintsDetailsViewRoute.page,
              path: 'complaints-inbox-view-details',
            ),
          ],
        ),

        /// Complaints registration
        AutoRoute(
          page: ComplaintsRegistrationWrapperRoute.page,
          path: 'complaints-registration',
          children: [
            AutoRoute(
              page: ComplaintTypeRoute.page,
              path: 'complaints-type',
              initial: true,
            ),
            AutoRoute(
              page: ComplaintsLocationRoute.page,
              path: 'complaints-location',
            ),
            AutoRoute(
              page: ComplaintsDetailsRoute.page,
              path: 'complaints-details',
            ),
          ],
        ),
      ],
    ),
  ];
}



// @MaterialAutoRouter(
//   replaceInRouteName: 'Page,Route',
//   routes: [
//     AutoRoute(
//       page: UnauthenticatedPageWrapper,
//       path: '/',
//       children: [
//         AutoRoute(page: LoginPage, path: 'login', initial: true),
//       ],
//     ),
//     AutoRoute(
//       page: AuthenticatedPageWrapper,
//       path: '/',
//       children: [
//         AutoRoute(page: HomePage, path: 'home'),
//         AutoRoute(page: ProfilePage, path: 'profile'),

//         AutoRoute(page: SearchBeneficiaryPage, path: 'search-beneficiary'),
//         //AutoRoute(page: QRScannerPage, path: 'scanner'),
//         AutoRoute(
//           page: BeneficiariesReportPage,
//           path: 'beneficiary-downsync-report',
//         ),

//         /// Beneficiary Registration
//         AutoRoute(
//           page: BeneficiaryRegistrationWrapperPage,
//           path: 'beneficiary-registration',
//           children: [
//             AutoRoute(page: IndividualDetailsPage, path: 'individual-details'),
//             AutoRoute(page: HouseHoldDetailsPage, path: 'household-details'),
//             AutoRoute(page: HouseHoldConsentPage, path: 'household-consent'),
//             AutoRoute(
//               page: HouseholdLocationPage,
//               path: 'household-location',
//               initial: true,
//             ),
//             AutoRoute(
//               page: ConsentHouseholdAcknowledgementPage,
//               path: 'consent-household-acknowledgement',
//             ),
//           ],
//         ),
//         AutoRoute(
//           page: BeneficiaryWrapperPage,
//           path: 'beneficiary',
//           children: [
//             AutoRoute(
//               page: HouseholdOverviewPage,
//               path: 'overview',
//               initial: true,
//             ),
//             AutoRoute(
//               page: BeneficiaryDetailsPage,
//               path: 'beneficiary-details',
//             ),
//             AutoRoute(
//               page: DeliverInterventionPage,
//               path: 'deliver-intervention',
//             ),
//             AutoRoute(
//               page: EligibilityChecklistViewPage,
//               path: 'eligibility-checklist',
//             ),
//             AutoRoute<List<TaskModel>>(
//               page: SideEffectsPage,
//               path: 'side-effects',
//             ),
//             AutoRoute(
//               page: ReferBeneficiaryPage,
//               path: 'refer-beneficiary',
//             ),
//             AutoRoute(
//               page: IneligibilityReasonsPage,
//               path: 'ineligibility-reasons',
//             ),
//             AutoRoute(
//               page: DoseAdministeredVerificationPage,
//               path: 'dose-administered-verification',
//             ),
//             AutoRoute(
//               page: DoseAdministeredPage,
//               path: 'dose-administered',
//             ),
//             AutoRoute(
//               page: RecordRedosePage,
//               path: 'record-redose',
//             ),
//             AutoRoute(
//               page: SplashAcknowledgementPage,
//               path: 'splash-acknowledgement',
//             ),
//             AutoRoute(
//               page: ReasonForDeletionPage,
//               path: 'reason-for-deletion',
//             ),
//             AutoRoute(
//               page: RecordPastDeliveryDetailsPage,
//               path: 'record-past-delivery-details',
//             ),
//             AutoRoute(
//               page: HouseholdAcknowledgementPage,
//               path: 'household-acknowledgement',
//             ),
//             AutoRoute(page: ChecklistViewPage, path: 'view'),
//           ],
//         ),
//         AutoRoute(
//           page: PerformamnceSummaryReportDetailsPage,
//           path: 'performance-summary-report-details',
//         ),

//         AutoRoute(page: ChecklistWrapperPage, path: 'checklist', children: [
//           AutoRoute(
//             page: ChecklistPage,
//             path: '',
//           ),
//           AutoRoute(page: ChecklistBoundaryViewPage, path: 'view-boundary'),
//           AutoRoute(page: ChecklistViewPage, path: 'view'),
//           AutoRoute(page: ChecklistPreviewPage, path: 'preview'),
//         ]),
//         AutoRoute(
//           page: BeneficiaryAcknowledgementPage,
//           path: 'beneficiary-acknowledgement',
//         ),
//         AutoRoute(page: AcknowledgementPage, path: 'acknowledgement'),
//         AutoRoute(
//           page: ComplaintsAcknowledgementPage,
//           path: 'complaints-acknowledgement',
//         ),

//         /// Inventory Routes
//         AutoRoute(
//           page: RecordStockWrapperPage,
//           path: 'record-stock',
//           children: [
//             AutoRoute(
//               page: WarehouseDetailsPage,
//               path: 'warehouse-details',
//               initial: true,
//             ),
//             AutoRoute(page: StockDetailsPage, path: 'details'),
//           ],
//         ),
//         AutoRoute(page: SearchReferralsPage, path: 'search-referrals'),
//         AutoRoute(
//           page: HFCreateReferralWrapperPage,
//           path: 'hf-referral',
//           children: [
//             AutoRoute(
//               page: ReferralFacilityPage,
//               path: 'facility-details',
//               initial: true,
//             ),
//             AutoRoute(
//               page: RecordReferralDetailsPage,
//               path: 'referral-details',
//             ),
//             AutoRoute(
//               page: ReferralReasonChecklistPage,
//               path: 'referral-reason',
//             ),
//             AutoRoute(
//               page: ReferralReasonCheckListPreviewPage,
//               path: 'referral-reason-view',
//             ),
//           ],
//         ),
//         AutoRoute(page: ManageStocksPage, path: 'manage-stocks'),
//         AutoRoute(page: StockReconciliationPage, path: 'stock-reconciliation'),
//         AutoRoute<FacilityModel>(
//           page: FacilitySelectionPage,
//           path: 'select-facilities',
//         ),
//         AutoRoute<ProjectFacilityModel>(
//           page: ProjectFacilitySelectionPage,
//           path: 'select-project-facilities',
//         ),
//         AutoRoute(
//           page: InventoryReportSelectionPage,
//           path: 'inventory-report-selection',
//         ),
//         AutoRoute(
//           page: InventoryReportDetailsPage,
//           path: 'inventory-report-details',
//         ),

//         /// Project Selection
//         AutoRoute(
//           page: ProjectSelectionPage,
//           path: 'select-project',
//           initial: true,
//         ),

//         /// Boundary Selection
//         AutoRoute(
//           page: BoundarySelectionPage,
//           path: 'select-boundary',
//         ),

//         AutoRoute(page: UserQRDetailsPage, path: 'user-qr-code'),

//         /// Complaints Inbox
//         AutoRoute(
//           page: ComplaintsInboxWrapperPage,
//           path: 'complaints-inbox',
//           children: [
//             AutoRoute(
//               page: ComplaintsInboxPage,
//               path: 'complaints-inbox-items',
//               initial: true,
//             ),
//             AutoRoute(
//               page: ComplaintsInboxFilterPage,
//               path: 'complaints-inbox-filter',
//             ),
//             AutoRoute(
//               page: ComplaintsInboxSearchPage,
//               path: 'complaints-inbox-search',
//             ),
//             AutoRoute(
//               page: ComplaintsInboxSortPage,
//               path: 'complaints-inbox-sort',
//             ),
//             AutoRoute(
//               page: ComplaintsDetailsViewPage,
//               path: 'complaints-inbox-view-details',
//             ),
//           ],
//         ),

//         /// Complaints registration
//         AutoRoute(
//           page: ComplaintsRegistrationWrapperPage,
//           path: 'complaints-registration',
//           children: [
//             AutoRoute(
//               page: ComplaintTypePage,
//               path: 'complaints-type',
//               initial: true,
//             ),
//             AutoRoute(
//               page: ComplaintsLocationPage,
//               path: 'complaints-location',
//             ),
//             AutoRoute(
//               page: ComplaintsDetailsPage,
//               path: 'complaints-details',
//             ),
//           ],
//         ),
//       ],
//     ),
//   ],
// )
// class AppRouter extends _$AppRouter {}
