import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../blocs/digit_scanner/digit_scanner.dart';
import '../../../blocs/facility/facility.dart';
import '../../../blocs/product_variant/product_variant.dart';
import '../../../blocs/record_stock/record_stock.dart';
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
  static const _transactionDamagedQuantityKey = 'quantityDamaged';
  static const _commentsKey = 'comments';
  List<ValidatorFunction> damagedQuantityValidator = [];
  List<ValidatorFunction> transactionQuantityValidator = [
    Validators.number,
    Validators.required,
    Validators.min(0),
    Validators.max(10000),
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
      _transactionDamagedQuantityKey:
          FormControl<int>(validators: damagedQuantityValidator),
      _commentsKey: FormControl<String>(),
      _deliveryTeamKey: FormControl<String>(
        validators: deliveryTeamSelected ? [Validators.required] : [],
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

                String pageTitle;
                String transactionPartyLabel;
                String quantityCountLabel;
                String? transactionReasonLabel;
                TransactionType transactionType;
                TransactionReason? transactionReason;

                List<TransactionReason>? reasons;

                switch (entryType) {
                  case StockRecordEntryType.receipt:
                    pageTitle = module.receivedSpaqDetails;
                    transactionPartyLabel =
                        module.selectTransactingPartyReceived;
                    quantityCountLabel = module.quantityReceivedLabel;
                    transactionType = TransactionType.received;
                    transactionQuantityValidator = [
                      Validators.number,
                      Validators.required,
                      Validators.min(0),
                      Validators.max(20000),
                    ];
                    break;
                  case StockRecordEntryType.dispatch:
                    pageTitle = module.issuedSpaqDetails;
                    transactionPartyLabel = module.selectTransactingPartyIssued;
                    quantityCountLabel = module.quantitySentLabel;
                    transactionType = TransactionType.dispatched;
                    break;
                  case StockRecordEntryType.returned:
                    pageTitle = module.returnedSpaqDetails;
                    transactionPartyLabel =
                        module.selectTransactingPartyReturned;
                    quantityCountLabel = module.quantityReturnedLabel;
                    transactionType = TransactionType.received;
                    damagedQuantityValidator = [
                      Validators.number,
                      Validators.required,
                      Validators.min(0),
                      Validators.max(10000),
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
                                      if (form
                                              .control(_deliveryTeamKey)
                                              .value
                                              .toString()
                                              .isEmpty ||
                                          form
                                                  .control(_deliveryTeamKey)
                                                  .value ==
                                              null ||
                                          scannerState.qrCodes.isNotEmpty) {
                                        form.control(_deliveryTeamKey).value =
                                            scannerState.qrCodes.isNotEmpty
                                                ? scannerState.qrCodes.last
                                                : '';
                                      }

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

                                                final transactingParty = form
                                                    .control(
                                                        _transactingPartyKey)
                                                    .value as FacilityModel;

                                                final quantity = form
                                                    .control(
                                                        _transactionQuantityKey)
                                                    .value;

                                                final damagedQuantity = form
                                                    .control(
                                                        _transactionDamagedQuantityKey)
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
                                                  case StockRecordEntryType
                                                        .returned:
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
                                                            damagedQuantity,
                                                          ].any((element) =>
                                                              element !=
                                                              null) ||
                                                          hasLocationData
                                                      ? StockAdditionalFields(
                                                          version: 1,
                                                          fields: [
                                                            if (damagedQuantity !=
                                                                null)
                                                              AdditionalField(
                                                                'damaged_quantity',
                                                                damagedQuantity,
                                                              ),
                                                            if (comments !=
                                                                    null &&
                                                                comments
                                                                    .isNotEmpty)
                                                              AdditionalField(
                                                                'comments',
                                                                comments,
                                                              ),
                                                            if (hasLocationData) ...[
                                                              AdditionalField(
                                                                  'lat', lat),
                                                              AdditionalField(
                                                                  'lng', lng),
                                                            ],
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
                                                  module.selectSpaqVariant,
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
                                          return DigitTextFormField(
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
                                                  facilities: teamFacilities,
                                                ),
                                              );

                                              if (facility == null) return;
                                              if (facility.id ==
                                                  'Delivery Team') {
                                                setState(() {
                                                  deliveryTeamSelected = true;
                                                });
                                              } else {
                                                setState(() {
                                                  deliveryTeamSelected = false;
                                                });
                                              }
                                              form
                                                  .control(_transactingPartyKey)
                                                  .value = facility;
                                            },
                                          );
                                        },
                                      ),
                                      if (deliveryTeamSelected)
                                        DigitTextFormField(
                                          label: localizations.translate(
                                            i18.manageStock.cddTeamCodeLabel,
                                          ),
                                          formControlName: _deliveryTeamKey,
                                          onChanged: (val) {
                                            String? value = val as String?;
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
                                          isRequired: true,
                                          suffix: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DigitScannerPage(
                                                    quantity: 1,
                                                    isGS1code: false,
                                                    singleValue: false,
                                                  ),
                                                  settings: const RouteSettings(
                                                    name: '/qr-scanner',
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.qr_code_2,
                                              color:
                                                  theme.colorScheme.secondary,
                                            ),
                                          ),
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
                                          "max": (object) =>
                                              localizations.translate(
                                                '${quantityCountLabel}_MAX_ERROR',
                                              ),
                                          "min": (object) =>
                                              localizations.translate(
                                                '${quantityCountLabel}_MIN_ERROR',
                                              ),
                                        },
                                        label: localizations.translate(
                                          quantityCountLabel,
                                        ),
                                      ),
                                      if ([
                                        StockRecordEntryType.returned,
                                      ].contains(entryType))
                                        DigitTextFormField(
                                          formControlName:
                                              _transactionDamagedQuantityKey,
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
                                            "max": (object) =>
                                                localizations.translate(
                                                  '${quantityCountLabel}_MAX_ERROR',
                                                ),
                                            "min": (object) =>
                                                localizations.translate(
                                                  '${quantityCountLabel}_MIN_ERROR',
                                                ),
                                          },
                                          label: localizations.translate(
                                            i18.stockDetails
                                                .quantityDamagedCountLabel,
                                          ),
                                        ),
                                      DigitTextFormField(
                                        label: localizations.translate(
                                          i18.stockDetails.commentsLabel,
                                        ),
                                        minLines: 3,
                                        maxLines: 3,
                                        formControlName: _commentsKey,
                                      ),
                                      scannerState.barCodes.isEmpty
                                          ? DigitOutlineIconButton(
                                              buttonStyle:
                                                  OutlinedButton.styleFrom(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const DigitScannerPage(
                                                      quantity: 5,
                                                      isGS1code: true,
                                                      singleValue: false,
                                                    ),
                                                    settings:
                                                        const RouteSettings(
                                                      name: '/qr-scanner',
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icons.qr_code,
                                              label: localizations.translate(
                                                i18.scanner.scanBales,
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        localizations.translate(
                                                          i18.stockDetails
                                                              .scannedResources,
                                                        ),
                                                        style: DigitTheme
                                                            .instance
                                                            .mobileTheme
                                                            .textTheme
                                                            .labelSmall,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        bottom: kPadding * 2,
                                                      ),
                                                      child: IconButton(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        color: theme.colorScheme
                                                            .secondary,
                                                        icon: const Icon(
                                                            Icons.edit),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const DigitScannerPage(
                                                                quantity: 5,
                                                                isGS1code: true,
                                                                singleValue:
                                                                    false,
                                                              ),
                                                              settings:
                                                                  const RouteSettings(
                                                                      name:
                                                                          '/qr-scanner'),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ...scannedResources.map(
                                                  (e) => Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(e.elements
                                                        .values.first.data
                                                        .toString()),
                                                  ),
                                                ),
                                              ],
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
}
