library app_utils;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digit_components/theme/digit_theme.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:digit_components/widgets/digit_dialog.dart';
import 'package:digit_components/widgets/digit_sync_dialog.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:isar/isar.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:uuid/uuid.dart';

import '../blocs/digit_scanner/digit_scanner.dart';
import '../blocs/localization/app_localization.dart';
import '../blocs/search_households/project_beneficiaries_downsync.dart';
import '../blocs/search_households/search_households.dart';
import '../data/local_store/no_sql/schema/localization.dart';
import '../data/local_store/secure_store/secure_store.dart';
import '../models/data_model.dart';
import '../models/project_type/project_type_model.dart';
import '../router/app_router.dart';
import '../widgets/progress_indicator/progress_indicator.dart';
import '../widgets/vision_detector_views/painters/barcode_detector_painter.dart';
import './i18_key_constants.dart' as i18;
import 'constants.dart';
import 'extensions/extensions.dart';

export 'app_exception.dart';
export 'constants.dart';
export 'extensions/extensions.dart';

Expression<bool> buildAnd(Iterable<Expression<bool>> iterable) {
  if (iterable.isEmpty) return const Constant(true);
  final result = iterable.reduce((value, element) => value & element);

  return result.equals(true);
}

Expression<bool> buildOr(Iterable<Expression<bool>> iterable) {
  if (iterable.isEmpty) return const Constant(true);
  final result = iterable.reduce((value, element) => value | element);

  return result.equals(true);
}

class IdGen {
  static const IdGen _instance = IdGen._internal();

  static IdGen get instance => _instance;

  /// Shorthand for [instance]
  static IdGen get i => instance;

  final Uuid uuid;

  const IdGen._internal() : uuid = const Uuid();

  String get identifier => uuid.v1();
}

class CustomValidator {
  /// Validates that control's value must be `true`
  static Map<String, dynamic>? requiredMin(
    AbstractControl<dynamic> control,
  ) {
    return control.value == null ||
            control.value.toString().length >= 2 ||
            control.value.toString().trim().isEmpty
        ? null
        : {'required': true};
  }

  static Map<String, dynamic>? requiredMin3(
    AbstractControl<dynamic> control,
  ) {
    return control.value == null ||
            control.value.toString().trim().length >= 3 ||
            control.value.toString().trim().isEmpty
        ? null
        : {'min3': true};
  }

  static Map<String, dynamic>? validMobileNumber(
    AbstractControl<dynamic> control,
  ) {
    if (control.value == null || control.value.toString().isEmpty) {
      return null;
    }

    const pattern = r'[0-9]';

    if (control.value.toString().length != 10) {
      return {'mobileNumber': true};
    }

    if (RegExp(pattern).hasMatch(control.value.toString())) return null;

    return {'mobileNumber': true};
  }

  static Map<String, dynamic>? validStockCount(
    AbstractControl<dynamic> control,
  ) {
    if (control.value == null || control.value.toString().isEmpty) {
      return {'required': true};
    }

    var parsed = int.tryParse(control.value) ?? 0;
    if (parsed < 0) {
      return {'min': true};
    } else if (parsed > 1000000) {
      return {'max': true};
    }

    return null;
  }
}

setBgRunning(bool isBgRunning) async {
  final localSecureStore = LocalSecureStore.instance;
  await localSecureStore.setBackgroundService(isBgRunning);
}

performBackgroundService({
  BuildContext? context,
  required bool stopService,
  required bool isBackground,
}) async {
  final connectivityResult = await (Connectivity().checkConnectivity());

  final isOnline = connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.mobile;
  final service = FlutterBackgroundService();
  var isRunning = await service.isRunning();

  if (!stopService) {
    if (isOnline & !isRunning) {
      final isStarted = await service.startService();
      if (!isStarted) {
        await service.startService();
      }
    }
  } else {
    if (isRunning) {
      service.invoke('stopService');
    }
  }
}

String maskString(String input) {
  // Define the character to use for masking (e.g., "*")
  const maskingChar = '*';

  // Create a new string with the same length as the input string
  final maskedString =
      List<String>.generate(input.length, (index) => maskingChar).join();

  return maskedString;
}

class Coordinate {
  final double? latitude;
  final double? longitude;

  Coordinate(this.latitude, this.longitude);
}

double? calculateDistance(Coordinate? start, Coordinate? end) {
  const double earthRadius = 6371.0; // Earth's radius in kilometers

  double toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  if (start?.latitude != null &&
      start?.longitude != null &&
      end?.latitude != null &&
      end?.longitude != null) {
    double lat1Rad = toRadians(start!.latitude!);
    double lon1Rad = toRadians(start.longitude!);
    double lat2Rad = toRadians(end!.latitude!);
    double lon2Rad = toRadians(end.longitude!);

    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    double a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  return null;
}

final requestData = {
  "data": [
    {
      "id": 1,
      "name": "John Doe",
      "age": 30,
      "email": "johndoe@example.com",
      "address": {
        "street": "123 Main Street",
        "city": "New York",
        "state": "NY",
        "zipcode": "10001",
      },
      "orders": [
        {
          "id": 101,
          "product": "Widget A",
          "quantity": 2,
          "price": 10.99,
        },
        {
          "id": 102,
          "product": "Widget B",
          "quantity": 1,
          "price": 19.99,
        },
      ],
    },
    {
      "id": 2,
      "name": "Jane Smith",
      "age": 25,
      "email": "janesmith@example.com",
      "address": {
        "street": "456 Elm Street",
        "city": "Los Angeles",
        "state": "CA",
        "zipcode": "90001",
      },
      "orders": [
        {
          "id": 201,
          "product": "Widget C",
          "quantity": 3,
          "price": 15.99,
        },
        {
          "id": 202,
          "product": "Widget D",
          "quantity": 2,
          "price": 12.99,
        },
      ],
    },
    // ... Repeat the above structure to reach approximately 100KB in size
  ],
};

/// This checks for if the active cycle is a new cycle or its the past cycle,
/// If the active cycle is same as past cycle then all validations for tracking delivery applies, else validations do not get applied
bool checkEligibilityForActiveCycle(
  int activeCycle,
  HouseholdMemberWrapper householdWrapper,
) {
  final pastCycle = (householdWrapper.tasks ?? []).isNotEmpty
      ? householdWrapper.tasks?.last.additionalFields?.fields
              .firstWhereOrNull(
                (e) => e.key == AdditionalFieldsType.cycleIndex.toValue(),
              )
              ?.value ??
          '1'
      : '1';

  return (activeCycle == int.parse(pastCycle));
}

/*Check for if the individual falls on the valid age category*/
///  * Returns [true] if the individual is in the same cycle and is eligible for the next dose,
bool checkEligibilityForAgeAndSideEffect(
  DigitDOBAge age,
  ProjectType? projectType,
  TaskModel? tasks,
  List<SideEffectModel>? sideEffects,
) {
  int totalAgeMonths = age.years * 12 + age.months;
  bool skipAge = [
    Status.administeredFailed.toValue(),
    Status.administeredSuccess.toValue(),
    Status.delivered.toValue(),
  ].contains(tasks?.status);
  final currentCycle = projectType?.cycles?.firstWhereOrNull(
    (e) =>
        (e.startDate!) < DateTime.now().millisecondsSinceEpoch &&
        (e.endDate!) > DateTime.now().millisecondsSinceEpoch,
    // Return null when no matching cycle is found
  );
  if (currentCycle != null &&
      currentCycle.startDate != null &&
      currentCycle.endDate != null) {
    bool recordedSideEffect = false;
    if ((tasks != null) && sideEffects != null && sideEffects.isNotEmpty) {
      final lastTaskTime =
          tasks.clientReferenceId == sideEffects.last.taskClientReferenceId
              ? tasks.clientAuditDetails?.createdTime
              : null;
      recordedSideEffect = lastTaskTime != null &&
          (lastTaskTime >= currentCycle.startDate! &&
              lastTaskTime <= currentCycle.endDate!);

      return projectType?.validMinAge != null &&
              projectType?.validMaxAge != null
          ? skipAge ||
                  (totalAgeMonths >= projectType!.validMinAge! &&
                      totalAgeMonths <= projectType.validMaxAge!)
              ? recordedSideEffect && !checkStatus([tasks], currentCycle)
                  ? false
                  : true
              : false
          : false;
    } else {
      return skipAge ||
              (totalAgeMonths >= projectType!.validMinAge! &&
                  totalAgeMonths <= projectType.validMaxAge!)
          ? true
          : false;
    }
  }

  return false;
}

bool checkIfBeneficiaryRefused(
  List<TaskModel>? tasks,
) {
  final isBeneficiaryRefused = (tasks != null &&
      (tasks ?? []).isNotEmpty &&
      tasks.last.status == Status.beneficiaryRefused.toValue());

  return isBeneficiaryRefused;
}

bool checkIfBeneficiaryIneligible(
  List<TaskModel>? tasks,
) {
  final isBeneficiaryIneligible = (tasks != null &&
      (tasks ?? []).isNotEmpty &&
      tasks.last.status == Status.beneficiaryIneligible.toValue());

  return isBeneficiaryIneligible;
}

bool checkIfBeneficiaryReferred(
  List<TaskModel>? tasks,
) {
  final isBeneficiaryReferred = (tasks != null &&
      (tasks ?? []).isNotEmpty &&
      tasks.last.status == Status.beneficiaryReferred.toValue());

  return isBeneficiaryReferred;
}

bool checkStatus(
  List<TaskModel>? tasks,
  Cycle? currentCycle,
) {
  if (currentCycle != null &&
      currentCycle.startDate != null &&
      currentCycle.endDate != null) {
    if (tasks != null && tasks.isNotEmpty) {
      final lastTask = tasks.last;
      final lastTaskCreatedTime = lastTask.clientAuditDetails?.createdTime;
      // final lastDose = lastTask.additionalFields?.fields.where((e) => e.key = AdditionalFieldsType.doseIndex)
      if (lastTaskCreatedTime != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(lastTaskCreatedTime);
        final diff = DateTime.now().difference(date);
        final isLastCycleRunning =
            lastTaskCreatedTime >= currentCycle.startDate! &&
                lastTaskCreatedTime <= currentCycle.endDate!;

        return isLastCycleRunning
            ? lastTask.status == Status.delivered.name
                ? true
                : diff.inHours >=
                        24 //[TODO: Need to move gap between doses to config
                    ? true
                    : false
            : true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  } else {
    return false;
  }
}

bool recordedSideEffect(
  Cycle? selectedCycle,
  TaskModel? task,
  List<SideEffectModel>? sideEffects,
) {
  if (selectedCycle != null &&
      selectedCycle.startDate != null &&
      selectedCycle.endDate != null) {
    if ((task != null) && (sideEffects ?? []).isNotEmpty) {
      final lastTaskCreatedTime =
          task.clientReferenceId == sideEffects?.last.taskClientReferenceId
              ? task.clientAuditDetails?.createdTime
              : null;

      return lastTaskCreatedTime != null &&
          lastTaskCreatedTime >= selectedCycle.startDate! &&
          lastTaskCreatedTime <= selectedCycle.endDate!;
    }
  }

  return false;
}

bool allDosesDelivered(
  List<TaskModel>? tasks,
  Cycle? selectedCycle,
  List<SideEffectModel>? sideEffects,
  IndividualModel? individualModel,
) {
  if (selectedCycle == null ||
      selectedCycle.id == 0 ||
      (selectedCycle.deliveries ?? []).isEmpty) {
    return true;
  } else {
    if ((tasks ?? []).isNotEmpty) {
      final lastCycle = int.tryParse(tasks?.last.additionalFields?.fields
              .where(
                (e) => e.key == AdditionalFieldsType.cycleIndex.toValue(),
              )
              .firstOrNull
              ?.value ??
          '');
      final lastDose = int.tryParse(tasks?.last.additionalFields?.fields
              .where(
                (e) => e.key == AdditionalFieldsType.doseIndex.toValue(),
              )
              .firstOrNull
              ?.value ??
          '');
      if (lastDose != null &&
          lastDose == selectedCycle.deliveries?.length &&
          lastCycle != null &&
          lastCycle == selectedCycle.id &&
          tasks?.last.status != Status.delivered.toValue()) {
        return true;
      } else if (selectedCycle.id == lastCycle &&
          tasks?.last.status == Status.delivered.toValue()) {
        return false;
      } else if ((sideEffects ?? []).isNotEmpty) {
        return recordedSideEffect(selectedCycle, tasks?.last, sideEffects);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

DoseCriteriaModel? fetchProductVariant(
  DeliveryModel? currentDelivery,
  IndividualModel? individualModel,
) {
  if (currentDelivery != null && individualModel != null) {
    final individualAge = DigitDateUtils.calculateAge(
      DigitDateUtils.getFormattedDateToDateTime(
            individualModel.dateOfBirth!,
          ) ??
          DateTime.now(),
    );
    final individualAgeInMonths =
        individualAge.years * 12 + individualAge.months;
    final filteredCriteria = currentDelivery.doseCriteria?.where((criteria) {
      final condition = criteria.condition;
      if (condition != null) {
        //{TODO: Expression package need to be parsed
        final ageRange = condition.split("<=age<");
        final minAge = int.parse(ageRange.first);
        final maxAge = int.parse(ageRange.last);

        // temp change for SMC specific use case
        if (maxAge == 59 && individualAgeInMonths > 59) {
          return true;
        }

        return individualAgeInMonths >= minAge &&
            individualAgeInMonths <= maxAge;
      }

      return false;
    }).toList();

    return (filteredCriteria ?? []).isNotEmpty ? filteredCriteria?.first : null;
  }

  return null;
}

Future<bool> getIsConnected() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }

    return false;
  } on SocketException catch (_) {
    return false;
  }
}

void showDownloadDialog(
  BuildContext context, {
  required DownloadBeneficiary model,
  required DigitProgressDialogType dialogType,
  bool isPop = true,
}) {
  if (isPop) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  switch (dialogType) {
    case DigitProgressDialogType.failed:
    case DigitProgressDialogType.checkFailed:
      DigitSyncDialog.show(
        context,
        type: DigitSyncDialogType.failed,
        label: model.title,
        primaryAction: DigitDialogActions(
          label: model.primaryButtonLabel ?? '',
          action: (ctx) {
            if (dialogType == DigitProgressDialogType.failed ||
                dialogType == DigitProgressDialogType.checkFailed) {
              Navigator.of(context, rootNavigator: true).pop();
              context.read<BeneficiaryDownSyncBloc>().add(
                    DownSyncGetBatchSizeEvent(
                      appConfiguration: [model.appConfiguartion!],
                      projectId: context.projectId,
                      boundaryCode: model.boundary,
                      pendingSyncCount: model.pendingSyncCount ?? 0,
                      boundaryName: model.boundaryName,
                    ),
                  );
            } else {
              Navigator.of(context, rootNavigator: true).pop();
              context.router.pop();
            }
          },
        ),
        secondaryAction: DigitDialogActions(
          label: model.secondaryButtonLabel ?? '',
          action: (ctx) {
            Navigator.of(context, rootNavigator: true).pop();
            context.router.pop();
          },
        ),
      );
    case DigitProgressDialogType.dataFound:
    case DigitProgressDialogType.pendingSync:
    case DigitProgressDialogType.insufficientStorage:
      DigitDialog.show(
        context,
        options: DigitDialogOptions(
          titleText: model.title,
          titleIcon: Icon(
            dialogType == DigitProgressDialogType.insufficientStorage
                ? Icons.warning
                : Icons.info_outline_rounded,
            color: dialogType == DigitProgressDialogType.insufficientStorage
                ? DigitTheme.instance.colorScheme.error
                : DigitTheme.instance.colorScheme.surfaceTint,
          ),
          contentText: model.content,
          primaryAction: DigitDialogActions(
            label: model.primaryButtonLabel ?? '',
            action: (ctx) {
              if (dialogType == DigitProgressDialogType.pendingSync) {
                Navigator.of(context, rootNavigator: true).pop();
                context.router.popUntilRouteWithName(HomeRoute.name);
              } else {
                if ((model.totalCount ?? 0) > 0) {
                  context.read<BeneficiaryDownSyncBloc>().add(
                        DownSyncBeneficiaryEvent(
                          projectId: context.projectId,
                          boundaryCode: model.boundary,
                          // Batch Size need to be defined based on Internet speed.
                          batchSize: model.batchSize ?? 1,
                          initialServerCount: model.totalCount ?? 0,
                          boundaryName: model.boundaryName,
                        ),
                      );
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                  context.read<BeneficiaryDownSyncBloc>().add(
                        const DownSyncResetStateEvent(),
                      );
                }
              }
            },
          ),
          secondaryAction: model.secondaryButtonLabel != null
              ? DigitDialogActions(
                  label: model.secondaryButtonLabel ?? '',
                  action: (ctx) async {
                    await LocalSecureStore.instance.setManualSyncTrigger(false);
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pop();
                      context.router.popUntilRouteWithName(HomeRoute.name);
                    }
                  },
                )
              : null,
        ),
      );
    case DigitProgressDialogType.inProgress:
      DigitDialog.show(
        context,
        options: DigitDialogOptions(
          title: ProgressIndicatorContainer(
            label: '',
            prefixLabel: '',
            suffixLabel: '${model.prefixLabel}/${model.suffixLabel}' ?? '',
            value: model.totalCount == 0
                ? 0
                : min((model.syncCount ?? 0) / (model.totalCount ?? 1), 1),
            valueColor: AlwaysStoppedAnimation<Color>(
              DigitTheme.instance.colorScheme.secondary,
            ),
            subLabel: model.title,
          ),
        ),
      );
    default:
      return;
  }
}

// Returns value of the Additional Field Model, by passing the key and additional Fields list as <Map<String, dynamic>>
dynamic getValueByKey(List<Map<String, dynamic>> data, String key) {
  for (var map in data) {
    if (map["key"] == key) {
      return map["value"];
    }
  }

  return null; // Key not found
}

//Function to read the localizations from ISAR,
getLocalizationString(Isar isar, String selectedLocale) async {
  List<dynamic> localizationValues = [];

  final List<LocalizationWrapper> localizationList =
      await isar.localizationWrappers
          .filter()
          .localeEqualTo(
            selectedLocale.toString(),
          )
          .findAll();
  if (localizationList.isNotEmpty) {
    localizationValues.addAll(localizationList.first.localization!);
  }

  return localizationValues;
}

class UniqueIdGeneration {
  Future<Set<String>> generateUniqueId({
    required String localityCode,
    required String loggedInUserId,
    required bool returnBothIds,
  }) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    // Get the Android ID
    String androidId = androidInfo.serialNumber == 'unknown'
        ? androidInfo.id.replaceAll('.', '')
        : androidInfo.serialNumber;

    // Get current timestamp
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    // Combine the Android ID with the timestamp
    String combinedId = '$loggedInUserId$androidId$localityCode$timestamp';

    // Generate SHA-256 hash
    List<int> bytes = utf8.encode(combinedId);
    Digest sha256Hash = sha256.convert(bytes);

    // Convert the hash to a 12-character string and make it uppercase
    String hashString = sha256Hash.toString();
    String uniqueId = hashString.substring(0, 12).toUpperCase();

    // Add a hyphen every 4 characters, except the last
    String formattedUniqueId = uniqueId.replaceAllMapped(
      RegExp(r'.{1,4}'),
      (match) => '${match.group(0)}-',
    );

    // Remove the last hyphen
    formattedUniqueId =
        formattedUniqueId.substring(0, formattedUniqueId.length - 1);

    if (kDebugMode) {
      print('uniqueId : $formattedUniqueId');
    }

    return returnBothIds
        ? {formattedUniqueId, combinedId}
        : {formattedUniqueId};
  }
}

class DigitScannerUtils {
  void buildDialog(
    BuildContext context,
    AppLocalizations localizations,
    int quantity,
  ) async {
    var contentLocalization = localizations
        .translate(
          i18.scanner.scannerDialogContent,
        )
        .replaceAll('{quantity}', quantity.toString());
    await DigitDialog.show<bool>(
      context,
      options: DigitDialogOptions(
        titleText: localizations.translate(
          i18.scanner.scannerDialogTitle,
        ),
        contentText: contentLocalization,
        primaryAction: DigitDialogActions(
          label: localizations.translate(
            i18.scanner.scannerDialogPrimaryAction,
          ),
          action: (ctx) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop(false);
          },
        ),
        secondaryAction: DigitDialogActions(
          label: localizations.translate(
            i18.scanner.scannerDialogSecondaryAction,
          ),
          action: (ctx) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop(true);

            Navigator.of(
              context,
            ).pop();
          },
        ),
      ),
    );
  }

  String trimString(String input) {
    return input.length > 20 ? '${input.substring(0, 20)}...' : input;
  }

  Future<void> processImage({
    required BuildContext context,
    required InputImage inputImage,
    required bool canProcess,
    required bool isBusy,
    required Function setBusy,
    required Function setText,
    required Function updateCustomPaint,
    required bool isGS1code,
    required int quantity,
    required List<GS1Barcode> result,
    required Function handleError,
    required Function storeValue,
    required Function storeCode,
    required CameraLensDirection cameraLensDirection,
    required BarcodeScanner barcodeScanner,
    required AppLocalizations localizations,
  }) async {
    // Check if processing is allowed
    if (!canProcess) return;

    // Check if another processing is in progress
    if (isBusy) return;

    setBusy(true);

    // Clear previous text state
    setText('');

    // Process the image to detect barcodes
    final barcodes = await barcodeScanner.processImage(inputImage);

    // Check if the input image has valid metadata for size and rotation
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      // If barcodes are found
      if (barcodes.isNotEmpty) {
        final bloc = context.read<DigitScannerBloc>();

        // Check if the widget is scanning GS1 codes
        if (isGS1code) {
          try {
            // Parse the first barcode using GS1BarcodeParser
            final parser = GS1BarcodeParser.defaultParser();
            final parsedResult =
                parser.parse(barcodes.first.displayValue.toString());

            // Check if the barcode has already been scanned
            final alreadyScanned = bloc.state.barCodes.any((element) =>
                element.elements.entries.last.value.data ==
                parsedResult.elements.entries.last.value.data);

            if (alreadyScanned) {
              // Handle error if the barcode is already scanned
              await handleError(
                  localizations.translate(i18.scanner.resourceAlreadyScanned));
            } else if (quantity > result.length) {
              // Store the parsed result if the quantity is greater than result length
              await storeValue(parsedResult);
            } else {
              // Handle error if there is a mismatch in the scanned resource count
              await handleError(localizations
                  .translate(i18.scanner.scannedResourceCountMisMatch));
            }
          } catch (e) {
            // Handle error if parsing fails
            await handleError(localizations
                .translate(i18.scanner.scannedResourceCountMisMatch));
          }
        } else {
          // For non-GS1 codes
          if (bloc.state.qrCodes.contains(barcodes.first.displayValue)) {
            // Handle error if the QR code is already scanned
            await handleError(
                localizations.translate(i18.scanner.resourceAlreadyScanned));
            return;
          } else {
            // Store the QR code if not already scanned
            await storeCode(barcodes.first.displayValue.toString());
          }
        }
      }

      // Create a custom painter to draw the detected barcodes
      final painter = BarcodeDetectorPainter(
        barcodes,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        cameraLensDirection,
      );
      updateCustomPaint(CustomPaint(painter: painter));
    } else {
      // Display the number of barcodes found and their raw values
      String text =
          '${localizations.translate(i18.scanner.barCodesFound)}: ${barcodes.length}\n\n';
      for (final barcode in barcodes) {
        text +=
            '${localizations.translate(i18.scanner.barCode)}: ${barcode.rawValue}\n\n';
      }
      setText(text);

      // TODO: set _customPaint to draw boundingRect on top of image
      updateCustomPaint(null);
    }

    // Mark the processing as complete
    setBusy(false);
  }

  Future<void> handleError({
    required BuildContext context,
    required String message,
    required AudioPlayer player,
    required List<dynamic> result,
    required Function setStateCallback,
    required AppLocalizations localizations,
  }) async {
    // Play the buzzer sound to indicate an error
    player.play(AssetSource(DigitScannerConstants().errorFilePath));

    // Check if the player has completed playing or if the result list is empty
    if (player.state == PlayerState.completed || result.isEmpty) {
      // Display a toast message with the provided error message
      DigitToast.show(
        context,
        options: DigitToastOptions(
          localizations.translate(message), // Translate the message
          true, // Show as an error
          DigitTheme.instance.mobileTheme, // Use the current theme
        ),
      );
    }

    // Wait for 2 seconds before proceeding
    await Future.delayed(const Duration(seconds: 2));

    // Update the state to allow processing again and indicate not busy
    setStateCallback();
  }

  Future<void> storeCode({
    required BuildContext context,
    required String code,
    required AudioPlayer player,
    required bool singleValue,
    required Function(List<String>) updateCodes,
    required List<String> initialCodes,
  }) async {
    // Play the add sound to indicate a successful scan
    player.play(AssetSource(DigitScannerConstants().audioFilePath));

    // Access the DigitScannerBloc from the context
    final bloc = context.read<DigitScannerBloc>();

    // Make a copy of the current QR codes from the bloc state
    List<String> codes = List.from(initialCodes);

    // If the widget is supposed to handle a single value, clear the codes list
    if (singleValue) {
      codes = [];
    }

    // Add the new code to the list
    codes.add(code);

    // Update the state with the new list of codes
    updateCodes(codes);

    // Dispatch an event to update the bloc with the new barcode and QR code lists
    bloc.add(DigitScannerEvent.handleScanner(
      barCode: bloc.state.barCodes, // Keep existing barcodes
      qrCode: codes, // Update QR codes with the new list
    ));

    // Wait for 5 seconds before completing the function
    await Future.delayed(const Duration(seconds: 5));
  }

  Future<void> storeValue({
    required BuildContext context,
    required GS1Barcode scanData,
    required AudioPlayer player,
    required Function(List<GS1Barcode>) updateResult,
    required List<GS1Barcode> initialResult,
  }) async {
    // Assign the scanned data to a local variable
    final parsedResult = scanData;

    // Access the DigitScannerBloc from the context
    final bloc = context.read<DigitScannerBloc>();

    // Play the add sound to indicate a successful scan
    player.play(AssetSource(DigitScannerConstants().audioFilePath));

    // Wait for 3 seconds before proceeding
    await Future.delayed(const Duration(seconds: 3));

    // Make a copy of the current barcodes from the bloc state
    List<GS1Barcode> result = List.from(initialResult);

    // Remove duplicate entries based on the last value in the elements map
    result.removeDuplicates(
      (element) => element.elements.entries.last.value.data,
    );

    // Add the new parsed result to the list
    result.add(parsedResult);

    // Dispatch an event to update the bloc with the new barcode and existing QR code lists
    bloc.add(DigitScannerEvent.handleScanner(
      barCode: result, // Update barcodes with the new list
      qrCode: bloc.state.qrCodes, // Keep existing QR codes
    ));

    // Update the state with the new list of results
    updateResult(result);

    // Wait for 5 seconds before completing the function
    await Future.delayed(const Duration(seconds: 5));
  }
}
