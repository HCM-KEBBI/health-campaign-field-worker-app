import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../blocs/app_initialization/app_initialization.dart';
import '../../../blocs/auth/auth.dart';
import '../../../blocs/digit_scanner/digit_scanner.dart';
import '../../../blocs/facility/facility.dart';
import '../../../blocs/product_variant/product_variant.dart';
import '../../../blocs/record_stock/record_stock.dart';
import '../../../data/local_store/no_sql/schema/app_configuration.dart';
import '../../../models/data_model.dart';
import '../../../router/app_router.dart';
import '../../../utils/i18_key_constants.dart' as i18;
import '../../../utils/utils.dart';
import '../../../widgets/header/back_navigation_help_header.dart';
import '../../../widgets/localized.dart';
import '../../digit_scanner.dart';
import '../facility_selection.dart';

class StockDetailsPage extends LocalizedStatefulWidget {
  const StockDetailsPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<StockDetailsPage> createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends LocalizedState<StockDetailsPage> {
  static const _productVariantKey = 'productVariant';
  static const _transactingPartyKey = 'transactingParty';
  static const _transactionQuantityKey = 'quantity';
  static const _partialBlistersKey = 'partialBlistersReturned';
  static const _wastedBlistersKey = 'wastedBlistersReturned';
  static const _commentsKey = 'comments';
  static const _transactionReasonKey = 'transactionReason';
  static const _waybillNumberKey = 'waybillNumber';
  static const _waybillQuantityKey = 'waybillQuantity';
  static const _vehicleNumberKey = 'vehicleNumber';
  static const _typeOfTransportKey = 'typeOfTransport';
  static const _batchNumberKey = 'batchNumber';
  static int maxQuantity = 100000000;
  static int minQuantity = 0;

  List<ValidatorFunction> partialBlistersQuantityValidator = [];
  List<ValidatorFunction> batchNumberValidators = [Validators.required];
  List<ValidatorFunction> wastedBlistersQuantityValidator = [];
  List<GS1Barcode> scannedResources = [];
  static const _deliveryTeamKey = 'deliveryTeam';
  static const _supervisorKey = 'supervisor';
  bool deliveryTeamSelected = false;
  bool isSpaq1 = true;

  FormGroup _form(
    List<FacilityModel> facilities,
    bool isDistributor,
    bool isHealthFacilitySupervisor,
    StockRecordEntryType entryType,
  ) {
    deliveryTeamSelected = context.isHealthFacilitySupervisor &&
        entryType != StockRecordEntryType.receipt;

    return fb.group({
      _productVariantKey: FormControl<ProductVariantModel>(
        validators: [Validators.required],
      ),
      _transactingPartyKey: FormControl<FacilityModel>(
        value: facilities.length >= 2
            ? null
            : facilities.isNotEmpty
                ? facilities.first
                : null,
        validators: [Validators.required],
      ),
      _transactionQuantityKey: FormControl<int>(validators: [
        Validators.number,
        Validators.required,
        Validators.min(
          (entryType == StockRecordEntryType.returned &&
                      isHealthFacilitySupervisor) ||
                  (entryType == StockRecordEntryType.dispatch && isDistributor)
              ? minQuantity
              : 1,
        ),
        Validators.max(maxQuantity),
      ]),
      _partialBlistersKey:
          FormControl<int>(validators: partialBlistersQuantityValidator),
      _wastedBlistersKey:
          FormControl<int>(validators: wastedBlistersQuantityValidator),
      _commentsKey: FormControl<String>(),
      _deliveryTeamKey: FormControl<String>(
        validators: (!isDistributor &&
                isHealthFacilitySupervisor &&
                entryType != StockRecordEntryType.receipt)
            ? [Validators.required]
            : [],
        value: '',
      ),
      _supervisorKey: FormControl<String>(
        validators: isDistributor ? [Validators.required] : [],
        value: '',
      ),
      _transactionReasonKey: FormControl<TransactionReason>(),
      _waybillNumberKey: FormControl<String>(
        validators: (isDistributor || deliveryTeamSelected)
            ? []
            : [
                Validators.required,
              ],
      ),
      _waybillQuantityKey: FormControl<int>(
        validators: (isDistributor || deliveryTeamSelected)
            ? []
            : [
                Validators.number,
                Validators.required,
                Validators.min(minQuantity),
                Validators.max(maxQuantity),
              ],
      ),
      _vehicleNumberKey: FormControl<String>(
        validators: (isDistributor || deliveryTeamSelected)
            ? []
            : [
                Validators.required,
              ],
      ),
      _typeOfTransportKey: FormControl<String>(
        validators: (isDistributor || deliveryTeamSelected)
            ? []
            : [
                Validators.required,
              ],
      ),
      _batchNumberKey: FormControl<String>(
        validators: batchNumberValidators,
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDistributor = context.isDistributor;
    final isHealthFacilitySupervisor = context.isHealthFacilitySupervisor;

    return PopScope(
      onPopInvoked: (didPop) {
        final stockState = context.read<RecordStockBloc>().state;
        clearQRCodes();
        // if (stockState.primaryId != null) {
        //   context.read<DigitScannerBloc>().add(
        //         DigitScannerEvent.handleScanner(
        //           barCode: [],
        //           qrCode: [stockState.primaryId.toString()],
        //         ),
        //       );
        // }
      },
      child: Scaffold(
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
            return BlocConsumer<RecordStockBloc, RecordStockState>(
              listener: (context, stockState) {
                stockState.mapOrNull(
                  persisted: (value) {
                    StockRecordEntryType entryType = stockState.entryType;

                    final parent = context.router.parent() as StackRouter;
                    var currDescription = localizations.translate(
                      i18.stockDetails.stockRecordDialogDynamicDescription,
                    );

                    if (entryType == StockRecordEntryType.receipt) {
                      currDescription =
                          currDescription.replaceAll('()', "incoming");
                    } else if (entryType == StockRecordEntryType.dispatch) {
                      currDescription = currDescription =
                          currDescription.replaceAll('()', "outgoing");
                    } else if (entryType == StockRecordEntryType.returned) {
                      currDescription = currDescription =
                          currDescription.replaceAll('()', "returning");
                    }
                    parent.replace(
                      AcknowledgementRoute(
                        isStock: true,
                        label: localizations.translate(
                          i18.stockDetails.stockRecordSuccessLabel,
                        ),
                        description: currDescription,
                      ),
                    );
                  },
                );
              },
              builder: (context, stockState) {
                StockRecordEntryType entryType = stockState.entryType;
                const module = i18.stockDetails;
                final isWarehouseMgr = context.isWarehouseMgr;

                deliveryTeamSelected = context.isHealthFacilitySupervisor &&
                    entryType != StockRecordEntryType.receipt;

                String pageTitle;
                String transactionPartyLabel;
                String quantityCountLabel;
                String? transactionReasonLabel;
                TransactionType transactionType;
                TransactionReason? transactionReason;

                List<TransactionReason>? reasons;

                switch (entryType) {
                  case StockRecordEntryType.receipt:
                    pageTitle = module.receivedPageTitle;
                    transactionPartyLabel =
                        module.selectTransactingPartyReceived;
                    quantityCountLabel = module.quantityReceivedLabel;
                    transactionType = TransactionType.received;
                    break;
                  case StockRecordEntryType.dispatch:
                    pageTitle = isDistributor
                        ? module.returnedPageTitle
                        : module.issuedPageTitle;
                    transactionPartyLabel = isDistributor
                        ? module.selectTransactingPartyReturned
                        : module.selectTransactingPartyIssued;
                    quantityCountLabel = isDistributor
                        ? module.quantityReturnedLabel
                        : module.quantitySentLabel;
                    transactionType = TransactionType.dispatched;
                    if (context.isDistributor) {
                      wastedBlistersQuantityValidator = [
                        Validators.number,
                        Validators.required,
                        Validators.min(minQuantity),
                        Validators.max(maxQuantity),
                      ];

                      partialBlistersQuantityValidator = [
                        Validators.number,
                        Validators.required,
                        Validators.min(minQuantity),
                        Validators.max(maxQuantity),
                      ];

                      batchNumberValidators = [];
                    }

                    break;
                  case StockRecordEntryType.returned:
                    pageTitle = module.returnedPageTitle;
                    transactionPartyLabel =
                        module.selectTransactingPartyReturned;
                    quantityCountLabel = module.quantityReturnedLabel;
                    transactionType = TransactionType.received;
                    partialBlistersQuantityValidator = [
                      Validators.number,
                      Validators.required,
                      Validators.min(minQuantity),
                      Validators.max(maxQuantity),
                    ];
                    break;
                  case StockRecordEntryType.loss:
                    pageTitle = module.lostPageTitle;
                    transactionPartyLabel =
                        module.selectTransactingPartyReceivedFromLost;
                    quantityCountLabel = module.quantityLostLabel;
                    transactionType = TransactionType.dispatched;
                    transactionReasonLabel = module.transactionReasonLost;
                    reasons = [
                      TransactionReason.lostInStorage,
                      TransactionReason.lostInTransit,
                    ];
                    break;
                  case StockRecordEntryType.damaged:
                    pageTitle = module.damagedSpaqDetails;
                    transactionPartyLabel =
                        module.selectTransactingPartyReceivedFromDamaged;
                    quantityCountLabel = module.quantityDamagedLabel;
                    transactionType = TransactionType.dispatched;
                    transactionReasonLabel = module.transactionReasonDamaged;
                    reasons = [
                      TransactionReason.damagedInStorage,
                      TransactionReason.damagedInTransit,
                    ];
                    break;
                }

                transactionReasonLabel ??= '';

                return BlocBuilder<FacilityBloc, FacilityState>(
                  builder: (context, state) {
                    List<FacilityModel> facilities = state.whenOrNull(
                          fetched: (_, facilities, __) => facilities,
                        ) ??
                        [];
                    List<FacilityModel> mappedFacilities = state.whenOrNull(
                          fetched: (facilities, _, __) => facilities,
                        ) ??
                        [];
                    List<FacilityModel> filteredFacilities = [];

                    if (context.selectedProject.address?.boundaryType ==
                        Constants.stateBoundaryLevel) {
                      filteredFacilities = entryType ==
                              StockRecordEntryType.receipt
                          ? facilities
                              .where((element) =>
                                  element.usage == Constants.centralFacility)
                              .toList()
                          : facilities
                              .where((element) =>
                                  element.usage == Constants.lgaFacility)
                              .toList();
                    } else if (context.selectedProject.address?.boundaryType ==
                        Constants.lgaBoundaryLevel) {
                      filteredFacilities = entryType ==
                              StockRecordEntryType.receipt
                          ? facilities
                              .where((element) =>
                                  element.usage == Constants.stateFacility)
                              .toList()
                          : mappedFacilities
                              .where((element) =>
                                  element.usage == Constants.healthFacility)
                              .toList();
                    } else {
                      filteredFacilities = context.isDistributor
                          ? mappedFacilities
                              .where((element) =>
                                  element.usage == Constants.healthFacility)
                              .toList()
                          : entryType == StockRecordEntryType.receipt
                              ? mappedFacilities
                                  .where((element) =>
                                      element.usage == Constants.lgaFacility)
                                  .toList()
                              : [];
                    }

                    facilities = context.isHealthFacilitySupervisor &&
                            entryType != StockRecordEntryType.receipt
                        ? []
                        : filteredFacilities.isEmpty
                            ? facilities
                            : filteredFacilities;

                    final teamFacilities = [
                      FacilityModel(
                        id: 'Delivery Team',
                        name: 'CDD Team',
                      ),
                    ];
                    teamFacilities.addAll(
                      facilities,
                    );

                    return ReactiveFormBuilder(
                      form: () => _form(
                        context.isHealthFacilitySupervisor &&
                                entryType != StockRecordEntryType.receipt
                            ? teamFacilities
                            : facilities,
                        isDistributor,
                        isHealthFacilitySupervisor,
                        entryType,
                      ),
                      builder: (context, form, child) {
                        return BlocBuilder<DigitScannerBloc, DigitScannerState>(
                          builder: (context, scannerState) {
                            if (isDistributor) {
                              if (form
                                      .control(_supervisorKey)
                                      .value
                                      .toString()
                                      .isEmpty ||
                                  form.control(_supervisorKey).value == null ||
                                  scannerState.qrCodes.isNotEmpty) {
                                form.control(_supervisorKey).value =
                                    scannerState.qrCodes.isNotEmpty
                                        ? scannerState.qrCodes.last
                                        : '';
                              }
                            } else {
                              if (form
                                      .control(_deliveryTeamKey)
                                      .value
                                      .toString()
                                      .isEmpty ||
                                  form.control(_deliveryTeamKey).value ==
                                      null ||
                                  scannerState.qrCodes.isNotEmpty) {
                                form.control(_deliveryTeamKey).value =
                                    scannerState.qrCodes.isNotEmpty
                                        ? scannerState.qrCodes.last
                                        : '';
                              }
                            }

                            if (scannerState.barCodes.isNotEmpty) {
                              scannedResources.clear();
                              scannedResources.addAll(scannerState.barCodes);
                            }

                            return ScrollableContent(
                              enableFixedButton: true,
                              header: Column(children: [
                                BackNavigationHelpHeaderWidget(
                                  handleback: () {
                                    final stockState =
                                        context.read<RecordStockBloc>().state;
                                    clearQRCodes();
                                    // if (stockState.primaryId != null) {
                                    //   context.read<DigitScannerBloc>().add(
                                    //         DigitScannerEvent.handleScanner(
                                    //           barCode: [],
                                    //           qrCode: [
                                    //             stockState.primaryId.toString(),
                                    //           ],
                                    //         ),
                                    //       );
                                    // }
                                  },
                                ),
                              ]),
                              footer: SizedBox(
                                child: DigitCard(
                                  margin: const EdgeInsets.fromLTRB(
                                      0, kPadding, 0, 0),
                                  padding: const EdgeInsets.fromLTRB(
                                      kPadding, 0, kPadding, 0),
                                  child: ReactiveFormConsumer(
                                    builder: (context, form, child) {
                                      return DigitElevatedButton(
                                        onPressed: form.hasErrors
                                            ? null
                                            : () async {
                                                form.markAllAsTouched();
                                                if (!form.valid) {
                                                  return;
                                                }
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();

                                                final bloc = context
                                                    .read<RecordStockBloc>();

                                                final productVariant = form
                                                    .control(_productVariantKey)
                                                    .value as ProductVariantModel;

                                                final primaryType = BlocProvider
                                                    .of<RecordStockBloc>(
                                                  context,
                                                ).state.primaryType;

                                                final primaryId = BlocProvider
                                                    .of<RecordStockBloc>(
                                                  context,
                                                ).state.primaryId;

                                                final transactingParty = form
                                                    .control(
                                                      _transactingPartyKey,
                                                    )
                                                    .value as FacilityModel;

                                                if (primaryId ==
                                                    transactingParty.id) {
                                                  DigitToast.show(
                                                    context,
                                                    options: DigitToastOptions(
                                                      localizations.translate(
                                                        i18.stockDetails
                                                            .senderReceiverValidation,
                                                      ),
                                                      true,
                                                      theme,
                                                    ),
                                                  );

                                                  return;
                                                }

                                                switch (entryType) {
                                                  case StockRecordEntryType
                                                        .receipt:
                                                    transactionReason =
                                                        TransactionReason
                                                            .received;
                                                    break;
                                                  case StockRecordEntryType
                                                        .dispatch:
                                                    transactionReason = null;
                                                    break;
                                                  case StockRecordEntryType
                                                        .returned:
                                                    transactionReason =
                                                        TransactionReason
                                                            .returned;
                                                    break;
                                                  default:
                                                    transactionReason = null;
                                                    break;
                                                }

                                                final waybillNumber = form
                                                    .control(_waybillNumberKey)
                                                    .value as String?;

                                                final waybillQuantity = form
                                                    .control(
                                                      _waybillQuantityKey,
                                                    )
                                                    .value;

                                                final vehicleNumber = form
                                                    .control(_vehicleNumberKey)
                                                    .value as String?;

                                                final batchNumber = form
                                                    .control(_batchNumberKey)
                                                    .value as String?;
                                                final transportType = form
                                                    .control(
                                                      _typeOfTransportKey,
                                                    )
                                                    .value as String?;

                                                final quantity = form
                                                    .control(
                                                      _transactionQuantityKey,
                                                    )
                                                    .value;

                                                final partialBlisters = form
                                                    .control(
                                                      _partialBlistersKey,
                                                    )
                                                    .value;

                                                final wastedBlisters = form
                                                    .control(
                                                      _wastedBlistersKey,
                                                    )
                                                    .value;

                                                if ((entryType ==
                                                            StockRecordEntryType
                                                                .returned &&
                                                        isHealthFacilitySupervisor &&
                                                        quantity == 0 &&
                                                        partialBlisters == 0) ||
                                                    (entryType ==
                                                            StockRecordEntryType
                                                                .dispatch &&
                                                        isDistributor &&
                                                        quantity == 0 &&
                                                        partialBlisters == 0 &&
                                                        wastedBlisters == 0)) {
                                                  DigitToast.show(
                                                    context,
                                                    options: DigitToastOptions(
                                                      localizations.translate(
                                                        i18.stockDetails
                                                            .quantityMinError,
                                                      ),
                                                      true,
                                                      theme,
                                                    ),
                                                  );

                                                  return;
                                                }

                                                final lat =
                                                    locationState.latitude;
                                                final lng =
                                                    locationState.longitude;

                                                final hasLocationData =
                                                    lat != null && lng != null;

                                                final comments = form
                                                    .control(_commentsKey)
                                                    .value as String?;

                                                String? transactingPartyType;

                                                final fields = transactingParty
                                                    .additionalFields?.fields;

                                                if (fields != null &&
                                                    fields.isNotEmpty) {
                                                  final type =
                                                      fields.firstWhereOrNull(
                                                    (element) =>
                                                        element.key == 'type',
                                                  );
                                                  final value = type?.value;
                                                  if (value != null &&
                                                      value is String &&
                                                      value.isNotEmpty) {
                                                    transactingPartyType =
                                                        value;
                                                  }
                                                }

                                                transactingPartyType ??=
                                                    'WAREHOUSE';

                                                if (entryType ==
                                                        StockRecordEntryType
                                                            .dispatch &&
                                                    !isDistributor) {
                                                  int issueQuantity =
                                                      quantity ?? 0;

                                                  List<StockModel>
                                                      stocksByProductVAriant =
                                                      stockState.existingStocks
                                                          .where((element) =>
                                                              element
                                                                  .productVariantId ==
                                                              productVariant.id)
                                                          .toList();

                                                  num stockReceived =
                                                      _getQuantityCount(
                                                    stocksByProductVAriant
                                                        .where((e) =>
                                                            e.transactionType ==
                                                                TransactionType
                                                                    .received &&
                                                            e.transactionReason ==
                                                                TransactionReason
                                                                    .received),
                                                  );

                                                  num stockIssued =
                                                      _getQuantityCount(
                                                    stocksByProductVAriant
                                                        .where((e) =>
                                                            e.transactionType ==
                                                                TransactionType
                                                                    .dispatched &&
                                                            e.transactionReason ==
                                                                null),
                                                  );

                                                  num stockReturned =
                                                      _getQuantityCount(
                                                    stocksByProductVAriant
                                                        .where((e) =>
                                                            e.transactionType ==
                                                                TransactionType
                                                                    .received &&
                                                            e.transactionReason ==
                                                                TransactionReason
                                                                    .returned),
                                                  );

                                                  num stockInHand =
                                                      (stockReceived +
                                                              stockReturned) -
                                                          (stockIssued);
                                                  if (issueQuantity >
                                                      stockInHand) {
                                                    final alert =
                                                        await DigitDialog.show<
                                                            bool>(
                                                      context,
                                                      options:
                                                          DigitDialogOptions(
                                                        titleText: localizations
                                                            .translate(
                                                          i18.stockDetails
                                                              .countDialogTitle,
                                                        ),
                                                        contentText:
                                                            localizations
                                                                .translate(
                                                                  i18.stockDetails
                                                                      .countContent,
                                                                )
                                                                .replaceAll(
                                                                  '{}',
                                                                  stockInHand
                                                                      .toString(),
                                                                ),
                                                        primaryAction:
                                                            DigitDialogActions(
                                                          label: localizations
                                                              .translate(
                                                            i18.stockDetails
                                                                .countDialogSuccess,
                                                          ),
                                                          action: (context) {
                                                            Navigator.of(
                                                              context,
                                                              rootNavigator:
                                                                  true,
                                                            ).pop(false);
                                                          },
                                                        ),
                                                      ),
                                                    );

                                                    if (!(alert ?? false)) {
                                                      return;
                                                    }
                                                  }
                                                }
                                                String? deliveryTeamName = form
                                                    .control(_deliveryTeamKey)
                                                    .value as String?;

                                                if (deliveryTeamName != null) {
                                                  deliveryTeamName =
                                                      deliveryTeamName
                                                          .split(Constants
                                                              .pipeSeparator)
                                                          .last;
                                                }

                                                final supervisorCode = form
                                                    .control(_supervisorKey)
                                                    .value as String?;

                                                String? senderId;
                                                String? senderType;
                                                String? receiverId;
                                                String? receiverType;

                                                switch (entryType) {
                                                  case StockRecordEntryType
                                                        .receipt:
                                                  case StockRecordEntryType
                                                        .loss:
                                                  case StockRecordEntryType
                                                        .damaged:
                                                  case StockRecordEntryType
                                                        .returned:
                                                    if (deliveryTeamSelected) {
                                                      senderId =
                                                          deliveryTeamName;
                                                      senderType = "STAFF";
                                                    } else {
                                                      senderId =
                                                          transactingParty.id;
                                                      senderType = "WAREHOUSE";
                                                    }
                                                    receiverId = primaryId;
                                                    receiverType = primaryType;

                                                    break;
                                                  case StockRecordEntryType
                                                        .dispatch:
                                                    if (deliveryTeamSelected) {
                                                      receiverId =
                                                          deliveryTeamName;
                                                      receiverType = "STAFF";
                                                    } else {
                                                      receiverId =
                                                          transactingParty.id;
                                                      receiverType =
                                                          "WAREHOUSE";
                                                    }
                                                    senderId = primaryId;
                                                    senderType = primaryType;
                                                    break;
                                                }

                                                final stockModel = StockModel(
                                                  clientReferenceId:
                                                      IdGen.i.identifier,
                                                  productVariantId:
                                                      productVariant.id,
                                                  transactingPartyId:
                                                      transactingParty.id,
                                                  senderType: senderType,
                                                  senderId: senderId,
                                                  receiverType: receiverType,
                                                  receiverId: receiverId,
                                                  transactingPartyType:
                                                      transactingPartyType,
                                                  transactionType:
                                                      transactionType,
                                                  transactionReason:
                                                      transactionReason,
                                                  referenceId:
                                                      stockState.projectId,
                                                  referenceIdType: 'PROJECT',
                                                  quantity: quantity.toString(),
                                                  waybillNumber: waybillNumber,
                                                  auditDetails: AuditDetails(
                                                    createdBy: context
                                                        .loggedInUserUuid,
                                                    createdTime: context
                                                        .millisecondsSinceEpoch(),
                                                  ),
                                                  clientAuditDetails:
                                                      ClientAuditDetails(
                                                    createdBy: context
                                                        .loggedInUserUuid,
                                                    createdTime: context
                                                        .millisecondsSinceEpoch(),
                                                    lastModifiedBy: context
                                                        .loggedInUserUuid,
                                                    lastModifiedTime: context
                                                        .millisecondsSinceEpoch(),
                                                  ),
                                                  additionalFields: [
                                                            comments,
                                                            partialBlisters,
                                                            wastedBlisters,
                                                            waybillQuantity,
                                                            batchNumber,
                                                            vehicleNumber,
                                                            transportType,
                                                            supervisorCode,
                                                          ].any((element) =>
                                                              element !=
                                                              null) ||
                                                          hasLocationData
                                                      ? StockAdditionalFields(
                                                          version: 1,
                                                          fields: [
                                                            if (partialBlisters !=
                                                                null)
                                                              AdditionalField(
                                                                _partialBlistersKey,
                                                                partialBlisters,
                                                              ),
                                                            if (wastedBlisters !=
                                                                null)
                                                              AdditionalField(
                                                                _wastedBlistersKey,
                                                                wastedBlisters,
                                                              ),
                                                            if (waybillQuantity !=
                                                                null)
                                                              AdditionalField(
                                                                'waybill_quantity',
                                                                waybillQuantity
                                                                    .toString(),
                                                              ),
                                                            if (comments !=
                                                                    null &&
                                                                comments
                                                                    .trim()
                                                                    .isNotEmpty)
                                                              AdditionalField(
                                                                'comments',
                                                                comments,
                                                              ),
                                                            if (batchNumber !=
                                                                    null &&
                                                                batchNumber
                                                                    .trim()
                                                                    .isNotEmpty)
                                                              AdditionalField(
                                                                _batchNumberKey,
                                                                batchNumber,
                                                              ),
                                                            if (vehicleNumber !=
                                                                    null &&
                                                                vehicleNumber
                                                                    .trim()
                                                                    .isNotEmpty)
                                                              AdditionalField(
                                                                _vehicleNumberKey,
                                                                vehicleNumber,
                                                              ),
                                                            if (transportType !=
                                                                    null &&
                                                                transportType
                                                                    .trim()
                                                                    .isNotEmpty)
                                                              AdditionalField(
                                                                _typeOfTransportKey,
                                                                transportType,
                                                              ),
                                                            if (supervisorCode !=
                                                                    null &&
                                                                supervisorCode
                                                                    .trim()
                                                                    .isNotEmpty)
                                                              AdditionalField(
                                                                _supervisorKey,
                                                                supervisorCode,
                                                              ),
                                                            if (hasLocationData) ...[
                                                              AdditionalField(
                                                                'lat',
                                                                lat,
                                                              ),
                                                              AdditionalField(
                                                                'lng',
                                                                lng,
                                                              ),
                                                            ],
                                                            if (scannerState
                                                                .barCodes
                                                                .isNotEmpty)
                                                              addBarCodesToFields(
                                                                scannerState
                                                                    .barCodes,
                                                              ),
                                                          ],
                                                        )
                                                      : null,
                                                );

                                                bloc.add(
                                                  RecordStockSaveStockDetailsEvent(
                                                    stockModel: stockModel,
                                                  ),
                                                );

                                                final submit = await DigitDialog
                                                    .show<bool>(
                                                  context,
                                                  options: DigitDialogOptions(
                                                    titleText:
                                                        localizations.translate(
                                                      i18.stockDetails
                                                          .dialogTitle,
                                                    ),
                                                    contentText:
                                                        localizations.translate(
                                                      i18.stockDetails
                                                          .dialogContent,
                                                    ),
                                                    primaryAction:
                                                        DigitDialogActions(
                                                      label: localizations
                                                          .translate(
                                                        i18.common
                                                            .coreCommonSubmit,
                                                      ),
                                                      action: (context) {
                                                        Navigator.of(
                                                          context,
                                                          rootNavigator: true,
                                                        ).pop(true);
                                                      },
                                                    ),
                                                    secondaryAction:
                                                        DigitDialogActions(
                                                      label: localizations
                                                          .translate(
                                                        i18.common
                                                            .coreCommonCancel,
                                                      ),
                                                      action: (context) =>
                                                          Navigator.of(
                                                        context,
                                                        rootNavigator: true,
                                                      ).pop(false),
                                                    ),
                                                  ),
                                                );

                                                if (submit ?? false) {
                                                  bloc.add(
                                                    const RecordStockCreateStockEntryEvent(),
                                                  );

                                                  if (isDistributor) {
                                                    int spaq1 = 0;
                                                    int spaq2 = 0;

                                                    int totalQuantity = 0;

                                                    totalQuantity = entryType ==
                                                            StockRecordEntryType
                                                                .dispatch
                                                        ? ((quantity != null
                                                                    ? int.parse(
                                                                        quantity
                                                                            .toString(),
                                                                      )
                                                                    : 0) +
                                                                (wastedBlisters !=
                                                                        null
                                                                    ? int.parse(
                                                                        wastedBlisters
                                                                            .toString(),
                                                                      )
                                                                    : 0)) *
                                                            -1
                                                        : quantity != null
                                                            ? int.parse(
                                                                quantity
                                                                    .toString(),
                                                              )
                                                            : 0;

                                                    if (isSpaq1) {
                                                      spaq1 = totalQuantity;
                                                    } else {
                                                      spaq2 = totalQuantity;
                                                    }

                                                    context
                                                        .read<AuthBloc>()
                                                        .add(
                                                          AuthAddSpaqCountsEvent(
                                                            spaq1Count: spaq1,
                                                            spaq2Count: spaq2,
                                                          ),
                                                        );
                                                  }
                                                }
                                              },
                                        child: Center(
                                          child: Text(
                                            localizations.translate(
                                              i18.common.coreCommonSubmit,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              children: [
                                DigitCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        localizations.translate(pageTitle),
                                        style: theme.textTheme.displayMedium,
                                      ),
                                      BlocBuilder<ProductVariantBloc,
                                          ProductVariantState>(
                                        builder: (context, state) {
                                          return state.maybeWhen(
                                            orElse: () => const Offstage(),
                                            fetched: (productVariants) {
                                              return DigitReactiveDropdown<
                                                  ProductVariantModel>(
                                                formControlName:
                                                    _productVariantKey,
                                                label: localizations.translate(
                                                  module.selectProductLabel,
                                                ),
                                                isRequired: true,
                                                valueMapper: (value) {
                                                  return localizations
                                                      .translate(
                                                    value.sku ?? value.id,
                                                  );
                                                },
                                                menuItems: productVariants,
                                                validationMessages: {
                                                  'required': (object) =>
                                                      localizations.translate(
                                                        '${module.selectProductLabel}_IS_REQUIRED',
                                                      ),
                                                },
                                                onChanged: (value) {
                                                  isSpaq1 = value.sku != null &&
                                                      value.sku!.contains(
                                                        Constants.spaq1String,
                                                      );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      BlocBuilder<FacilityBloc, FacilityState>(
                                        builder: (context, state) {
                                          return InkWell(
                                            onTap: () async {
                                              clearQRCodes();
                                              form
                                                  .control(_deliveryTeamKey)
                                                  .value = '';
                                              final parent = context.router
                                                  .parent() as StackRouter;
                                              final facility = await parent
                                                  .push<FacilityModel>(
                                                FacilitySelectionRoute(
                                                  facilities:
                                                      (isHealthFacilitySupervisor &&
                                                              entryType !=
                                                                  StockRecordEntryType
                                                                      .receipt)
                                                          ? teamFacilities
                                                          : facilities,
                                                ),
                                              );

                                              if (facility == null) return;

                                              if (isWarehouseMgr) {
                                                if (facility.id ==
                                                    'Delivery Team') {
                                                  setState(() {
                                                    form
                                                        .control(
                                                      _waybillNumberKey,
                                                    )
                                                        .setValidators(
                                                      [],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );
                                                    form
                                                        .control(
                                                      _waybillQuantityKey,
                                                    )
                                                        .setValidators(
                                                      [],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );
                                                    form
                                                        .control(
                                                      _vehicleNumberKey,
                                                    )
                                                        .setValidators(
                                                      [],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );
                                                    form
                                                        .control(
                                                      _typeOfTransportKey,
                                                    )
                                                        .setValidators(
                                                      [],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );
                                                    form
                                                        .control(
                                                      _commentsKey,
                                                    )
                                                        .setValidators(
                                                      [],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );
                                                    deliveryTeamSelected = true;
                                                    form
                                                        .control(
                                                      _deliveryTeamKey,
                                                    )
                                                        .setValidators(
                                                      [
                                                        Validators.required,
                                                      ],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );
                                                  });
                                                } else {
                                                  setState(() {
                                                    form
                                                        .control(
                                                      _deliveryTeamKey,
                                                    )
                                                        .setValidators(
                                                      [],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );
                                                    deliveryTeamSelected =
                                                        false;
                                                    form
                                                        .control(
                                                      _waybillNumberKey,
                                                    )
                                                        .setValidators(
                                                      [
                                                        Validators.required,
                                                      ],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );
                                                    form
                                                        .control(
                                                      _waybillQuantityKey,
                                                    )
                                                        .setValidators(
                                                      [
                                                        Validators.number,
                                                        Validators.required,
                                                        Validators.min(
                                                          minQuantity,
                                                        ),
                                                        Validators.max(
                                                          maxQuantity,
                                                        ),
                                                      ],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );
                                                    form
                                                        .control(
                                                      _vehicleNumberKey,
                                                    )
                                                        .setValidators(
                                                      [
                                                        Validators.required,
                                                      ],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );
                                                    form
                                                        .control(
                                                      _typeOfTransportKey,
                                                    )
                                                        .setValidators(
                                                      [
                                                        Validators.required,
                                                      ],
                                                      updateParent: true,
                                                      autoValidate: true,
                                                    );

                                                    final quantity = form
                                                        .control(
                                                          _transactionQuantityKey,
                                                        )
                                                        .value as int?;
                                                    final waybillQuantity = form
                                                        .control(
                                                          _waybillQuantityKey,
                                                        )
                                                        .value as int?;
                                                    if (quantity !=
                                                        waybillQuantity) {
                                                      form
                                                          .control(
                                                        _commentsKey,
                                                      )
                                                          .setValidators(
                                                        [Validators.required],
                                                        updateParent: true,
                                                        autoValidate: true,
                                                      );
                                                      form
                                                          .control(
                                                            _commentsKey,
                                                          )
                                                          .touched;
                                                    } else {
                                                      form
                                                          .control(
                                                        _commentsKey,
                                                      )
                                                          .setValidators(
                                                        [],
                                                        updateParent: true,
                                                        autoValidate: true,
                                                      );
                                                    }
                                                  });
                                                }
                                              }

                                              form
                                                  .control(_transactingPartyKey)
                                                  .value = facility;
                                            },
                                            child: IgnorePointer(
                                              child: DigitTextFormField(
                                                valueAccessor:
                                                    FacilityValueAccessor(
                                                  teamFacilities,
                                                ),
                                                label: localizations.translate(
                                                  (isDistributor &&
                                                          stockState
                                                                  .entryType ==
                                                              StockRecordEntryType
                                                                  .dispatch)
                                                      ? transactionPartyLabel
                                                      : '${pageTitle}_${i18.stockReconciliationDetails.stockLabel}',
                                                ),
                                                isRequired: true,
                                                suffix: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(Icons.search),
                                                ),
                                                formControlName:
                                                    _transactingPartyKey,
                                                readOnly: false,
                                                onTap: () async {
                                                  clearQRCodes();
                                                  form
                                                      .control(_deliveryTeamKey)
                                                      .value = '';
                                                  final parent = context.router
                                                      .parent() as StackRouter;
                                                  final facility = await parent
                                                      .push<FacilityModel>(
                                                    FacilitySelectionRoute(
                                                      facilities:
                                                          (isHealthFacilitySupervisor &&
                                                                  entryType !=
                                                                      StockRecordEntryType
                                                                          .receipt)
                                                              ? teamFacilities
                                                              : facilities,
                                                    ),
                                                  );

                                                  if (facility == null) return;
                                                  if (isWarehouseMgr) {
                                                    if (facility.id ==
                                                        'Delivery Team') {
                                                      setState(() {
                                                        form
                                                            .control(
                                                          _waybillNumberKey,
                                                        )
                                                            .setValidators(
                                                          [],
                                                          updateParent: true,
                                                          autoValidate: true,
                                                        );
                                                        form
                                                            .control(
                                                          _waybillQuantityKey,
                                                        )
                                                            .setValidators(
                                                          [],
                                                          updateParent: true,
                                                          autoValidate: true,
                                                        );
                                                        form
                                                            .control(
                                                          _vehicleNumberKey,
                                                        )
                                                            .setValidators(
                                                          [],
                                                          updateParent: true,
                                                          autoValidate: true,
                                                        );
                                                        form
                                                            .control(
                                                          _typeOfTransportKey,
                                                        )
                                                            .setValidators(
                                                          [],
                                                          updateParent: true,
                                                          autoValidate: true,
                                                        );
                                                        form
                                                            .control(
                                                          _commentsKey,
                                                        )
                                                            .setValidators(
                                                          [],
                                                          updateParent: true,
                                                          autoValidate: true,
                                                        );
                                                        deliveryTeamSelected =
                                                            true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        deliveryTeamSelected =
                                                            false;
                                                        form
                                                            .control(
                                                          _waybillNumberKey,
                                                        )
                                                            .setValidators(
                                                          [
                                                            Validators.required,
                                                          ],
                                                          updateParent: true,
                                                          autoValidate: true,
                                                        );
                                                        form
                                                            .control(
                                                          _waybillQuantityKey,
                                                        )
                                                            .setValidators(
                                                          [
                                                            Validators.number,
                                                            Validators.required,
                                                            Validators.min(
                                                              minQuantity,
                                                            ),
                                                            Validators.max(
                                                              maxQuantity,
                                                            ),
                                                          ],
                                                          updateParent: true,
                                                          autoValidate: true,
                                                        );
                                                        form
                                                            .control(
                                                          _vehicleNumberKey,
                                                        )
                                                            .setValidators(
                                                          [
                                                            Validators.required,
                                                          ],
                                                          updateParent: true,
                                                          autoValidate: true,
                                                        );
                                                        form
                                                            .control(
                                                          _typeOfTransportKey,
                                                        )
                                                            .setValidators(
                                                          [
                                                            Validators.required,
                                                          ],
                                                          updateParent: true,
                                                          autoValidate: true,
                                                        );

                                                        final quantity = form
                                                            .control(
                                                              _transactionQuantityKey,
                                                            )
                                                            .value as int?;
                                                        final waybillQuantity =
                                                            form
                                                                .control(
                                                                  _waybillQuantityKey,
                                                                )
                                                                .value as int?;
                                                        if (quantity !=
                                                            waybillQuantity) {
                                                          form
                                                              .control(
                                                            _commentsKey,
                                                          )
                                                              .setValidators(
                                                            [
                                                              Validators
                                                                  .required,
                                                            ],
                                                            updateParent: true,
                                                            autoValidate: true,
                                                          );
                                                          form
                                                              .control(
                                                                _commentsKey,
                                                              )
                                                              .touched;
                                                        } else {
                                                          form
                                                              .control(
                                                            _commentsKey,
                                                          )
                                                              .setValidators(
                                                            [],
                                                            updateParent: true,
                                                            autoValidate: true,
                                                          );
                                                        }
                                                      });
                                                    }
                                                  }

                                                  form
                                                      .control(
                                                        _transactingPartyKey,
                                                      )
                                                      .value = facility;
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      if (!isDistributor &&
                                          isHealthFacilitySupervisor &&
                                          entryType !=
                                              StockRecordEntryType.receipt)
                                        InkWell(
                                          onTap: () async {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const DigitScannerPage(
                                                  quantity: 1,
                                                  isGS1code: false,
                                                  singleValue: true,
                                                  validateQR: true,
                                                ),
                                                settings: const RouteSettings(
                                                  name: '/qr-scanner',
                                                ),
                                              ),
                                            );
                                          },
                                          child: IgnorePointer(
                                            child: DigitTextFormField(
                                              label: localizations.translate(
                                                i18.manageStock
                                                    .cddTeamCodeLabel,
                                              ),
                                              readOnly: false,
                                              onChanged: (val) {
                                                String? value =
                                                    val.value as String?;
                                                if (value != null &&
                                                    value.trim().isNotEmpty) {
                                                  context
                                                      .read<DigitScannerBloc>()
                                                      .add(
                                                        DigitScannerEvent
                                                            .handleScanner(
                                                          barCode: [],
                                                          qrCode: [value],
                                                          manualCode: value,
                                                        ),
                                                      );
                                                } else {
                                                  clearQRCodes();
                                                }
                                              },
                                              suffix: IconButton(
                                                onPressed: () {
                                                  //[TODO: Add route to auto_route]
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DigitScannerPage(
                                                        quantity: 1,
                                                        isGS1code: false,
                                                        singleValue: true,
                                                        validateQR: true,
                                                      ),
                                                      settings:
                                                          const RouteSettings(
                                                        name: '/qr-scanner',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.qr_code_2,
                                                  color: theme
                                                      .colorScheme.secondary,
                                                ),
                                              ),
                                              isRequired: true,
                                              maxLines: 3,
                                              formControlName: _deliveryTeamKey,
                                              validationMessages: {
                                                "required": (object) =>
                                                    localizations.translate(
                                                      i18.common
                                                          .corecommonRequired,
                                                    ),
                                              },
                                            ),
                                          ),
                                        ),
                                      if (isDistributor)
                                        InkWell(
                                          onTap: () async {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const DigitScannerPage(
                                                  quantity: 1,
                                                  isGS1code: false,
                                                  singleValue: true,
                                                  validateQR: true,
                                                ),
                                                settings: const RouteSettings(
                                                  name: '/qr-scanner',
                                                ),
                                              ),
                                            );
                                          },
                                          child: IgnorePointer(
                                            child: DigitTextFormField(
                                              label: localizations.translate(
                                                i18.manageStock
                                                    .cddSupervisorCodeLabel,
                                              ),
                                              // readOnly: true,
                                              onChanged: (val) {
                                                String? value =
                                                    val.value as String?;
                                                if (value != null &&
                                                    value.trim().isNotEmpty) {
                                                  context
                                                      .read<DigitScannerBloc>()
                                                      .add(
                                                        DigitScannerEvent
                                                            .handleScanner(
                                                          barCode: [],
                                                          qrCode: [value],
                                                          manualCode: value,
                                                        ),
                                                      );
                                                } else {
                                                  clearQRCodes();
                                                }
                                              },
                                              suffix: IconButton(
                                                onPressed: () {
                                                  //[TODO: Add route to auto_route]
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DigitScannerPage(
                                                        quantity: 1,
                                                        isGS1code: false,
                                                        singleValue: true,
                                                        validateQR: true,
                                                      ),
                                                      settings:
                                                          const RouteSettings(
                                                        name: '/qr-scanner',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.qr_code_2,
                                                  color: theme
                                                      .colorScheme.secondary,
                                                ),
                                              ),
                                              isRequired: isDistributor,
                                              maxLines: 3,
                                              formControlName: _supervisorKey,
                                              validationMessages: {
                                                "required": (object) =>
                                                    localizations.translate(
                                                      i18.common
                                                          .corecommonRequired,
                                                    ),
                                              },
                                            ),
                                          ),
                                        ),
                                      DigitTextFormField(
                                        formControlName:
                                            _transactionQuantityKey,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                          LengthLimitingTextInputFormatter(9),
                                        ],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                        ),
                                        isRequired: true,
                                        validationMessages: {
                                          "number": (object) =>
                                              localizations.translate(
                                                '${quantityCountLabel}_VALIDATION',
                                              ),
                                          "max": (object) => localizations
                                              .translate(
                                                '${quantityCountLabel}_MAX_ERROR',
                                              )
                                              .replaceAll(
                                                '{}',
                                                maxQuantity.toString(),
                                              ),
                                          "min": (object) => localizations
                                              .translate(
                                                '${quantityCountLabel}_MIN_ERROR',
                                              )
                                              .replaceAll(
                                                '{}',
                                                (entryType ==
                                                                StockRecordEntryType
                                                                    .returned &&
                                                            isHealthFacilitySupervisor) ||
                                                        (entryType ==
                                                                StockRecordEntryType
                                                                    .dispatch &&
                                                            isDistributor)
                                                    ? minQuantity.toString()
                                                    : "1",
                                              ),
                                        },
                                        label: localizations.translate(
                                          quantityCountLabel,
                                        ),
                                        onChanged: (control) {
                                          if (isWarehouseMgr &&
                                              !deliveryTeamSelected) {
                                            final quantity = form
                                                .control(
                                                  _transactionQuantityKey,
                                                )
                                                .value as int?;
                                            final waybillQuantity = form
                                                .control(_waybillQuantityKey)
                                                .value as int?;
                                            if (quantity != waybillQuantity) {
                                              setState(() {
                                                form
                                                    .control(
                                                  _commentsKey,
                                                )
                                                    .setValidators(
                                                  [Validators.required],
                                                  updateParent: true,
                                                  autoValidate: true,
                                                );
                                                form
                                                    .control(
                                                      _commentsKey,
                                                    )
                                                    .touched;
                                              });
                                            } else {
                                              setState(() {
                                                form
                                                    .control(
                                                  _commentsKey,
                                                )
                                                    .setValidators(
                                                  [],
                                                  updateParent: true,
                                                  autoValidate: true,
                                                );
                                              });
                                            }
                                          }
                                        },
                                      ),
                                      if ([
                                            StockRecordEntryType.returned,
                                          ].contains(entryType) ||
                                          ([
                                                StockRecordEntryType.dispatch,
                                              ].contains(entryType) &&
                                              context.isDistributor))
                                        DigitTextFormField(
                                          formControlName: _partialBlistersKey,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'),
                                            ),
                                            LengthLimitingTextInputFormatter(9),
                                          ],
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                            decimal: true,
                                          ),
                                          isRequired: true,
                                          validationMessages: {
                                            "number": (object) =>
                                                localizations.translate(
                                                  '${quantityCountLabel}_VALIDATION',
                                                ),
                                            "max": (object) => localizations
                                                .translate(
                                                  '${quantityCountLabel}_MAX_ERROR',
                                                )
                                                .replaceAll(
                                                  '{}',
                                                  maxQuantity.toString(),
                                                ),
                                            "min": (object) => localizations
                                                .translate(
                                                  '${quantityCountLabel}_MIN_ERROR',
                                                )
                                                .replaceAll(
                                                  '{}',
                                                  minQuantity.toString(),
                                                ),
                                          },
                                          label: localizations.translate(
                                            module.quantityPartialReturnedLabel,
                                          ),
                                        ),
                                      if ([
                                            StockRecordEntryType.dispatch,
                                          ].contains(entryType) &&
                                          context.isDistributor)
                                        DigitTextFormField(
                                          formControlName: _wastedBlistersKey,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'),
                                            ),
                                            LengthLimitingTextInputFormatter(9),
                                          ],
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                            decimal: true,
                                          ),
                                          isRequired: true,
                                          validationMessages: {
                                            "number": (object) =>
                                                localizations.translate(
                                                  '${quantityCountLabel}_VALIDATION',
                                                ),
                                            "max": (object) => localizations
                                                .translate(
                                                  '${quantityCountLabel}_MAX_ERROR',
                                                )
                                                .replaceAll(
                                                  '{}',
                                                  maxQuantity.toString(),
                                                ),
                                            "min": (object) => localizations
                                                .translate(
                                                  '${quantityCountLabel}_MIN_ERROR',
                                                )
                                                .replaceAll(
                                                  '{}',
                                                  minQuantity.toString(),
                                                ),
                                          },
                                          label: localizations.translate(
                                            i18.stockDetails
                                                .quantityWastedReturnedLabel,
                                          ),
                                        ),
                                      isWarehouseMgr && !deliveryTeamSelected
                                          ? DigitTextFormField(
                                              label: localizations.translate(
                                                i18.stockDetails
                                                    .waybillNumberLabel,
                                              ),
                                              isRequired: true,
                                              formControlName:
                                                  _waybillNumberKey,
                                              validationMessages: {
                                                'required': (object) =>
                                                    localizations.translate(
                                                      i18.common
                                                          .corecommonRequired,
                                                    ),
                                              },
                                            )
                                          : const Offstage(),
                                      isWarehouseMgr && !deliveryTeamSelected
                                          ? DigitTextFormField(
                                              label: localizations.translate(
                                                i18.stockDetails
                                                    .quantityOfProductIndicatedOnWaybillLabel,
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(r'[0-9]'),
                                                ),
                                                LengthLimitingTextInputFormatter(
                                                    9),
                                              ],
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                decimal: true,
                                              ),
                                              isRequired: true,
                                              formControlName:
                                                  _waybillQuantityKey,
                                              validationMessages: {
                                                "number": (object) =>
                                                    localizations.translate(
                                                      '${i18.stockDetails.quantityOfProductIndicatedOnWaybillLabel}_ERROR',
                                                    ),
                                                "max": (object) => localizations
                                                    .translate(
                                                      '${quantityCountLabel}_MAX_ERROR',
                                                    )
                                                    .replaceAll(
                                                      '{}',
                                                      maxQuantity.toString(),
                                                    ),
                                                "min": (object) => localizations
                                                    .translate(
                                                      '${quantityCountLabel}_MIN_ERROR',
                                                    )
                                                    .replaceAll(
                                                      '{}',
                                                      minQuantity.toString(),
                                                    ),
                                              },
                                              onChanged: (control) {
                                                if (isWarehouseMgr &&
                                                    !deliveryTeamSelected) {
                                                  final quantity = form
                                                      .control(
                                                        _transactionQuantityKey,
                                                      )
                                                      .value as int?;
                                                  final waybillQuantity = form
                                                      .control(
                                                          _waybillQuantityKey)
                                                      .value as int?;
                                                  if (quantity !=
                                                      waybillQuantity) {
                                                    setState(() {
                                                      form
                                                          .control(
                                                        _commentsKey,
                                                      )
                                                          .setValidators(
                                                        [Validators.required],
                                                        updateParent: true,
                                                        autoValidate: true,
                                                      );
                                                      form
                                                          .control(
                                                            _commentsKey,
                                                          )
                                                          .touched;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      form
                                                          .control(
                                                        _commentsKey,
                                                      )
                                                          .setValidators(
                                                        [],
                                                        updateParent: true,
                                                        autoValidate: true,
                                                      );
                                                    });
                                                  }
                                                }
                                              },
                                            )
                                          : const Offstage(),
                                      if (!([
                                            StockRecordEntryType.dispatch,
                                          ].contains(entryType) &&
                                          context.isDistributor))
                                        DigitTextFormField(
                                          label: localizations.translate(
                                            i18.stockDetails.batchNumberLabel,
                                          ),
                                          isRequired: true,
                                          formControlName: _batchNumberKey,
                                          validationMessages: {
                                            'required': (object) =>
                                                localizations.translate(
                                                  i18.common.corecommonRequired,
                                                ),
                                          },
                                        ),
                                      isWarehouseMgr && !deliveryTeamSelected
                                          ? BlocBuilder<AppInitializationBloc,
                                              AppInitializationState>(
                                              builder: (context, state) =>
                                                  state.maybeWhen(
                                                orElse: () => const Offstage(),
                                                initialized:
                                                    (appConfiguration, _) {
                                                  final transportTypeOptions =
                                                      appConfiguration
                                                              .transportTypes ??
                                                          <TransportTypes>[];

                                                  return DigitReactiveDropdown<
                                                      String>(
                                                    isRequired: true,
                                                    label:
                                                        localizations.translate(
                                                      i18.stockDetails
                                                          .transportTypeLabel,
                                                    ),
                                                    valueMapper: (e) =>
                                                        localizations
                                                            .translate(e),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        form.control(
                                                          _typeOfTransportKey,
                                                        );
                                                      });
                                                    },
                                                    initialValue:
                                                        localizations.translate(
                                                      transportTypeOptions
                                                              .firstOrNull
                                                              ?.code ??
                                                          '',
                                                    ),
                                                    menuItems:
                                                        transportTypeOptions
                                                            .map(
                                                      (e) {
                                                        return e.code;
                                                      },
                                                    ).toList(),
                                                    formControlName:
                                                        _typeOfTransportKey,
                                                    validationMessages: {
                                                      'required': (object) =>
                                                          localizations
                                                              .translate(
                                                            i18.common
                                                                .corecommonRequired,
                                                          ),
                                                    },
                                                  );
                                                },
                                              ),
                                            )
                                          : const Offstage(),
                                      isWarehouseMgr && !deliveryTeamSelected
                                          ? DigitTextFormField(
                                              label: localizations.translate(
                                                i18.stockDetails
                                                    .vehicleNumberLabel,
                                              ),
                                              isRequired: true,
                                              formControlName:
                                                  _vehicleNumberKey,
                                              validationMessages: {
                                                'required': (object) =>
                                                    localizations.translate(
                                                      i18.common
                                                          .corecommonRequired,
                                                    ),
                                              },
                                            )
                                          : const Offstage(),
                                      DigitTextFormField(
                                        label: localizations.translate(
                                          i18.stockDetails.commentsLabel,
                                        ),
                                        minLines: 3,
                                        maxLines: 3,
                                        formControlName: _commentsKey,
                                        validationMessages: {
                                          'required': (object) =>
                                              localizations.translate(
                                                i18.common.corecommonRequired,
                                              ),
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  num _getQuantityCount(Iterable<StockModel> stocks) {
    return stocks.fold<num>(
      0.0,
      (old, e) => (num.tryParse(e.quantity ?? '') ?? 0.0) + old,
    );
  }

  void clearQRCodes() {
    context.read<DigitScannerBloc>().add(const DigitScannerEvent.handleScanner(
          barCode: [],
          qrCode: [],
        ));
  }

  /// @return A map where the keys and values are joined by '|'.
  AdditionalField addBarCodesToFields(List<GS1Barcode> barCodes) {
    List<String> keys = [];
    List<String> values = [];
    for (var element in barCodes) {
      for (var e in element.elements.entries) {
        keys.add(e.key.toString());
        values.add(e.value.data.toString());
      }
    }
    return AdditionalField(keys.join('|'), values.join('|'));
  }
}
