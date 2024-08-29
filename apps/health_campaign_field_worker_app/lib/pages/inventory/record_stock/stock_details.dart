import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../blocs/app_initialization/app_initialization.dart';
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
  static int maxQuantity = 10000;
  static int minQuantity = 0;

  List<ValidatorFunction> partialBlistersQuantityValidator = [];
  List<ValidatorFunction> wastedBlistersQuantityValidator = [];
  List<ValidatorFunction> transactionQuantityValidator = [
    Validators.number,
    Validators.required,
    Validators.min(minQuantity),
    Validators.max(maxQuantity),
  ];
  List<GS1Barcode> scannedResources = [];
  static const _deliveryTeamKey = 'deliveryTeam';
  bool deliveryTeamSelected = false;

  FormGroup _form(List<FacilityModel> facilities) {
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
      _transactionQuantityKey:
          FormControl<int>(validators: transactionQuantityValidator),
      _partialBlistersKey:
          FormControl<int>(validators: partialBlistersQuantityValidator),
      _wastedBlistersKey:
          FormControl<int>(validators: wastedBlistersQuantityValidator),
      _commentsKey: FormControl<String>(),
      _deliveryTeamKey: FormControl<String>(
        validators: deliveryTeamSelected ? [Validators.required] : [],
      ),
      _transactionReasonKey: FormControl<TransactionReason>(),
      _waybillNumberKey: FormControl<String>(validators: [
        Validators.required,
      ]),
      _waybillQuantityKey: FormControl<int>(
        validators: [
          Validators.number,
          Validators.required,
          Validators.min(minQuantity),
          Validators.max(maxQuantity),
        ],
      ),
      _vehicleNumberKey: FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
      _typeOfTransportKey: FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
      _batchNumberKey: FormControl<String>(
        validators: [Validators.required],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      onPopInvoked: (didPop) {
        final stockState = context.read<RecordStockBloc>().state;
        if (stockState.primaryId != null) {
          context.read<DigitScannerBloc>().add(
                DigitScannerEvent.handleScanner(
                  barCode: [],
                  qrCode: [stockState.primaryId.toString()],
                ),
              );
        }
      },
      child: Scaffold(
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
            return BlocConsumer<RecordStockBloc, RecordStockState>(
              listener: (context, stockState) {
                stockState.mapOrNull(
                  persisted: (value) {
                    final parent = context.router.parent() as StackRouter;
                    parent.replace(AcknowledgementRoute());
                  },
                );
              },
              builder: (context, stockState) {
                StockRecordEntryType entryType = stockState.entryType;
                const module = i18.stockDetails;
                final isWarehouseMgr = context.isWarehouseMgr;

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
                    pageTitle = module.issuedPageTitle;
                    transactionPartyLabel = module.selectTransactingPartyIssued;
                    quantityCountLabel = module.quantitySentLabel;
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
                    List<FacilityModel> unSortedFacilities = state.whenOrNull(
                          fetched: (_, facilities, __) => facilities,
                        ) ??
                        [];

                    if ([
                          StockRecordEntryType.dispatch,
                          StockRecordEntryType.returned,
                        ].contains(entryType) &&
                        context.isSupervisor) {
                      unSortedFacilities = unSortedFacilities
                          .where((element) => element.usage == 'DeliveryTeam')
                          .toList();
                    }

                    var facilities = unSortedFacilities.toList();
                    facilities.sort((a, b) =>
                        (b.auditDetails?.lastModifiedTime ?? 0).compareTo(
                          (a.auditDetails?.lastModifiedTime ?? 0),
                        ));
                    final teamFacilities = [
                      FacilityModel(
                        id: 'Delivery Team',
                        name: 'Delivery Team',
                      ),
                    ];
                    teamFacilities.addAll(
                      facilities,
                    );

                    return ReactiveFormBuilder(
                      form: () => _form(facilities),
                      builder: (context, form, child) {
                        return BlocBuilder<DigitScannerBloc, DigitScannerState>(
                          builder: (context, scannerState) {
                            if (form
                                    .control(_deliveryTeamKey)
                                    .value
                                    .toString()
                                    .isEmpty ||
                                form.control(_deliveryTeamKey).value == null ||
                                scannerState.qrCodes.isNotEmpty) {
                              form.control(_deliveryTeamKey).value =
                                  scannerState.qrCodes.isNotEmpty
                                      ? scannerState.qrCodes.last
                                      : '';
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
                                    if (stockState.primaryId != null) {
                                      context.read<DigitScannerBloc>().add(
                                            DigitScannerEvent.handleScanner(
                                              barCode: [],
                                              qrCode: [
                                                stockState.primaryId.toString(),
                                              ],
                                            ),
                                          );
                                    }
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

                                                final transactingParty = form
                                                    .control(
                                                      _transactingPartyKey,
                                                    )
                                                    .value as FacilityModel;

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
                                                        .dispatch) {
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
                                                final deliveryTeamName = form
                                                    .control(_deliveryTeamKey)
                                                    .value as String?;

                                                String? senderId;
                                                String? senderType;
                                                String? receiverId;
                                                String? receiverType;

                                                final primaryType = BlocProvider
                                                    .of<RecordStockBloc>(
                                                  context,
                                                ).state.primaryType;

                                                final primaryId = BlocProvider
                                                    .of<RecordStockBloc>(
                                                  context,
                                                ).state.primaryId;

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
                                                  facilities: teamFacilities,
                                                ),
                                              );

                                              if (facility == null) return;
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
                                                  deliveryTeamSelected = false;
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
                                                          minQuantity),
                                                      Validators.max(
                                                          maxQuantity),
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
                                                  '${pageTitle}_${i18.stockReconciliationDetails.stockLabel}',
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
                                                          teamFacilities,
                                                    ),
                                                  );

                                                  if (facility == null) return;
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
                                                              minQuantity),
                                                          Validators.max(
                                                              maxQuantity),
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
                                      DigitTextFormField(
                                        label: localizations.translate(
                                          i18.manageStock.cddTeamCodeLabel,
                                        ),
                                        readOnly: !deliveryTeamSelected,
                                        onChanged: (val) {
                                          String? value = val.value as String?;
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
                                          onPressed: !deliveryTeamSelected
                                              ? null
                                              : () {
                                                  //[TODO: Add route to auto_route]
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DigitScannerPage(
                                                        quantity: 1,
                                                        isGS1code: false,
                                                        singleValue: true,
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
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ),
                                        isRequired: deliveryTeamSelected,
                                        maxLines: 3,
                                        formControlName: _deliveryTeamKey,
                                        validationMessages: {
                                          "required": (object) =>
                                              localizations.translate(
                                                i18.common.corecommonRequired,
                                              ),
                                        },
                                      ),
                                      DigitTextFormField(
                                        formControlName:
                                            _transactionQuantityKey,
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
