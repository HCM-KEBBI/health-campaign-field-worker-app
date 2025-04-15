import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/models/digit_table_model.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/utils/utils.dart'
    as utilsLocal;
import 'package:registration_delivery/blocs/app_localization.dart';
import 'package:registration_delivery/models/entities/additional_fields_type.dart';
import 'package:registration_delivery/models/entities/household.dart';
import 'package:registration_delivery/models/entities/project_beneficiary.dart';

import 'package:registration_delivery/models/entities/status.dart';
import 'package:registration_delivery/registration_delivery.dart';
import 'package:registration_delivery/utils/constants.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;

import 'package:registration_delivery/utils/utils.dart'
    as registration_delivery_utils;
import '../../../models/entities/status.dart' as status;
import '../../../utils/i18_key_constants.dart' as i18Local;

import '../../../widgets/localized.dart';
import 'custom_beneficiary_card.dart';

import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';

// import 'package:registration_delivery/models/entities/status.dart';

class CustomBeneficiaryCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final String? status;
  final String? statusType;
  final List<String>? fields;

  const CustomBeneficiaryCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.status,
    this.statusType,
    this.fields,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: Text(
            title,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        Offstage(
          offstage: status == null,
          child: status == Status.visited.toValue() ||
                  status == Status.registered.toValue() ||
                  status == Status.administeredSuccess.toValue()
              ? DigitIconButton(
                  icon: Icons.check_circle,
                  iconText: RegistrationDeliveryLocalization.of(context)
                      .translate(status.toString()),
                  iconTextColor: theme.colorScheme.onSurfaceVariant,
                  iconColor: theme.colorScheme.onSurfaceVariant,
                )
              : DigitIconButton(
                  icon: Icons.info_rounded,
                  iconText: RegistrationDeliveryLocalization.of(context)
                      .translate(status.toString()),
                  iconTextColor: theme.colorScheme.error,
                  iconColor: theme.colorScheme.error,
                ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              subtitle!,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              description!,
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class CustomViewBeneficiaryCardSMC extends LocalizedStatefulWidget {
  final HouseholdMemberWrapper householdMember;
  final VoidCallback? onOpenPressed;
  final double? distance;

  const CustomViewBeneficiaryCardSMC({
    super.key,
    super.appLocalizations,
    required this.householdMember,
    this.onOpenPressed,
    this.distance,
  });

  @override
  State<CustomViewBeneficiaryCardSMC> createState() =>
      _CustomViewBeneficiaryCardSMCState();
}

class _CustomViewBeneficiaryCardSMCState
    extends LocalizedState<CustomViewBeneficiaryCardSMC> {
  late HouseholdMemberWrapper householdMember;
  static const _menCountKey = 'menCount';
  static const _womenCountKey = 'womenCount';

  @override
  void initState() {
    householdMember = widget.householdMember;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomViewBeneficiaryCardSMC oldWidget) {
    householdMember = widget.householdMember;
    super.didUpdateWidget(oldWidget);
  }

  bool checkStatusSMC(List<TaskModel>? tasks, ProjectCycle? currentCycle) {
    if (currentCycle == null) {
      return false;
    }

    if (tasks == null || tasks.isEmpty) {
      return true;
    }

    final lastTask = tasks.last;
    final lastTaskCreatedTime = lastTask.clientAuditDetails?.createdTime;

    if (lastTaskCreatedTime == null) {
      return false;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(lastTaskCreatedTime);
    final diff = DateTime.now().difference(date);
    final isLastCycleRunning = lastTaskCreatedTime >= currentCycle.startDate &&
        lastTaskCreatedTime <= currentCycle.endDate;

    if (isLastCycleRunning) {
      if (lastTask.status == Status.delivered.name) {
        return true;
      }

      return false;
    }

    return true;
  }

  bool checkIfBeneficiaryIneligible(
    List<TaskModel>? tasks,
  ) {
    final isBeneficiaryIneligible = (tasks != null &&
        (tasks ?? []).isNotEmpty &&
        tasks.last.status == status.Status.beneficiaryIneligible.toValue());

    return isBeneficiaryIneligible;
  }

  bool _isCardExpanded = false;

  bool get isCardExpanded => _isCardExpanded;

  set isCardExpanded(bool value) => setState(() => _isCardExpanded = value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final headerList = [
      TableHeader(
        localizations.translate(i18.beneficiaryDetails.beneficiaryHeader),
        cellKey: 'beneficiary',
      ),
      TableHeader(
        localizations.translate(i18.beneficiaryDetails.deliveryHeader),
        cellKey: 'delivery',
      ),
      TableHeader(
        localizations.translate(i18.individualDetails.ageLabelText),
        cellKey: 'age',
      ),
      TableHeader(
        localizations.translate(i18.common.coreCommonGender),
        cellKey: 'gender',
      ),
    ];
    final filteredHeaderList = RegistrationDeliverySingleton()
                .beneficiaryType !=
            BeneficiaryType.individual
        ? headerList.where((element) => element.cellKey != 'delivery').toList()
        : headerList;
    final currentCycle =
        RegistrationDeliverySingleton().projectType?.cycles?.firstWhereOrNull(
              (e) =>
                  (e.startDate) < DateTime.now().millisecondsSinceEpoch &&
                  (e.endDate) > DateTime.now().millisecondsSinceEpoch,
              // Return null when no matching cycle is found
            );
    final household = householdMember.household;
    final childCount =
        getValueForTheKey(AdditionalFieldsType.children.toValue(), household);
    final pregnantWomenCount = getValueForTheKey(
        AdditionalFieldsType.pregnantWomen.toValue(), household);
    final menCount = getValueForTheKey(_menCountKey, household);
    final womenCount = getValueForTheKey(_womenCountKey, household);
    final noOfRooms =
        getValueForTheKey(AdditionalFieldsType.noOfRooms.toValue(), household);

    final tableData = householdMember.members?.map(
      (e) {
        final projectBeneficiary =
            householdMember.projectBeneficiaries?.where((element) {
          if (RegistrationDeliverySingleton().beneficiaryType ==
              BeneficiaryType.individual) {
            return element.beneficiaryClientReferenceId == e.clientReferenceId;
          } else {
            return element.beneficiaryClientReferenceId ==
                householdMember.household!.clientReferenceId;
          }
        }).toList();

        final taskData = (projectBeneficiary ?? []).isNotEmpty
            ? householdMember.tasks
                ?.where((element) =>
                    element.projectBeneficiaryClientReferenceId ==
                    projectBeneficiary?.first.clientReferenceId)
                .toList()
            : null;
        final referralData = (projectBeneficiary ?? []).isNotEmpty
            ? householdMember.referrals
                ?.where((element) =>
                    element.projectBeneficiaryClientReferenceId ==
                    projectBeneficiary?.first.clientReferenceId)
                .toList()
            : null;
        final sideEffects = taskData != null && taskData.isNotEmpty
            ? householdMember.sideEffects
                ?.where((element) =>
                    element.taskClientReferenceId ==
                    taskData.last.clientReferenceId)
                .toList()
            : null;

        final ageInYears = DigitDateUtils.calculateAge(
          e.dateOfBirth != null
              ? DigitDateUtils.getFormattedDateToDateTime(
                    e.dateOfBirth!,
                  ) ??
                  DateTime.now()
              : DateTime.now(),
        ).years;
        final ageInMonths = DigitDateUtils.calculateAge(
          e.dateOfBirth != null
              ? DigitDateUtils.getFormattedDateToDateTime(
                    e.dateOfBirth!,
                  ) ??
                  DateTime.now()
              : DateTime.now(),
        ).months;

        final isNotEligible =
            !registration_delivery_utils.checkEligibilityForAgeAndSideEffect(
          DigitDOBAge(
            years: ageInYears,
            months: ageInMonths,
          ),
          RegistrationDeliverySingleton().projectType,
          (taskData ?? []).isNotEmpty ? taskData?.last : null,
          sideEffects,
        );
        final isHead = e.clientReferenceId ==
            householdMember.headOfHousehold!.clientReferenceId;

        final isSideEffectRecorded =
            registration_delivery_utils.recordedSideEffect(
          currentCycle,
          (taskData ?? []).isNotEmpty ? taskData?.last : null,
          sideEffects,
        );
        final isBeneficiaryRefused =
            registration_delivery_utils.checkIfBeneficiaryRefused(taskData);
        final isBeneficiaryReferred =
            registration_delivery_utils.checkIfBeneficiaryReferred(
          referralData,
          currentCycle,
        );
        final isBeneficiaryIneligible = checkIfBeneficiaryIneligible(
          taskData,
        );

        final isStatusReset = checkStatusSMC(taskData, currentCycle);

        final rowTableData = [
          TableData(
            [
              e.name?.givenName,
              e.name?.familyName,
            ].whereNotNull().join(' '),
            cellKey: 'beneficiary',
          ),
          TableData(
            isHead
                ? localizations.translate(
                    i18Local.householdOverView
                        .householdOverViewHouseholderHeadLabelSMC,
                  )
                : getTableCellText(
                    StatusKeys(
                      isNotEligible,
                      isBeneficiaryRefused,
                      isBeneficiaryReferred,
                      isStatusReset,
                    ),
                    taskData,
                    isBeneficiaryIneligible,
                  ),
            cellKey: 'delivery',
            style: TextStyle(
              color: getTableCellTextColor(
                isNotEligible: isNotEligible,
                taskdata: taskData,
                isBeneficiaryRefused:
                    isBeneficiaryRefused || isBeneficiaryReferred,
                isStatusReset: isStatusReset,
                theme: theme,
                isBeneficiaryIneligible: isBeneficiaryIneligible,
              ),
            ),
          ),
          TableData(
            e.dateOfBirth == null
                ? ''
                : '${DigitDateUtils.calculateAge(
                    DigitDateUtils.getFormattedDateToDateTime(
                          e.dateOfBirth!,
                        ) ??
                        DateTime.now(),
                  ).years} ${localizations.translate(i18.searchBeneficiary.yearsAbbr)} ${DigitDateUtils.calculateAge(
                    DigitDateUtils.getFormattedDateToDateTime(
                          e.dateOfBirth!,
                        ) ??
                        DateTime.now(),
                  ).months} ${localizations.translate(i18.searchBeneficiary.monthsAbbr)}',
            cellKey: 'age',
          ),
          TableData(
            e.gender?.name != null
                ? localizations
                    .translate('CORE_COMMON_${e.gender?.name.toUpperCase()}')
                : ' -- ',
            cellKey: 'gender',
          ),
        ];

        return TableDataRow(
          RegistrationDeliverySingleton().beneficiaryType !=
                  BeneficiaryType.individual
              ? rowTableData
                  .where((element) => element.cellKey != 'delivery')
                  .toList()
              : rowTableData,
        );
        // rowTableData
      },
    ).toList();

    final ageInYears = DigitDateUtils.calculateAge(
      householdMember.headOfHousehold?.dateOfBirth != null
          ? DigitDateUtils.getFormattedDateToDateTime(
                householdMember.headOfHousehold!.dateOfBirth!,
              ) ??
              DateTime.now()
          : DateTime.now(),
    ).years;
    final ageInMonths = DigitDateUtils.calculateAge(
      householdMember.headOfHousehold?.dateOfBirth != null
          ? DigitDateUtils.getFormattedDateToDateTime(
                householdMember.headOfHousehold!.dateOfBirth!,
              ) ??
              DateTime.now()
          : DateTime.now(),
    ).months;

    final isNotEligible =
        !registration_delivery_utils.checkEligibilityForAgeAndSideEffect(
      DigitDOBAge(
        years: ageInYears,
        months: ageInMonths,
      ),
      RegistrationDeliverySingleton().projectType,
      householdMember.tasks?.last,
      householdMember.sideEffects,
    );

    final isBeneficiaryRefused = registration_delivery_utils
        .checkIfBeneficiaryRefused(householdMember.tasks);
    final projectBeneficiary = householdMember.projectBeneficiaries?.where((p) {
      if (RegistrationDeliverySingleton().beneficiaryType ==
          BeneficiaryType.individual) {
        return p.beneficiaryClientReferenceId ==
            householdMember.headOfHousehold?.clientReferenceId;
      } else {
        return p.beneficiaryClientReferenceId ==
            householdMember.household?.clientReferenceId;
      }
    }).firstOrNull;

    final tasks = householdMember.tasks?.where((t) =>
        t.projectBeneficiaryClientReferenceId ==
        projectBeneficiary?.clientReferenceId);

    return DigitCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.7,
                child: CustomBeneficiaryCard(
                  description: [
                    householdMember.household?.address?.doorNo,
                    householdMember.household?.address?.addressLine1,
                    householdMember.household?.address?.addressLine2,
                    householdMember.household?.address?.landmark,
                    householdMember.household?.address?.city,
                    householdMember.household?.address?.pincode,
                  ].whereNotNull().take(2).join(' '),
                  subtitle:
                      '${householdMember.household?.memberCount ?? 1} ${householdMember.members?.length == 1 ? localizations.translate(i18Local.beneficiaryDetails.householdMemberSingularSMC) : localizations.translate(i18Local.beneficiaryDetails.householdMemberPluralSMC)}'
                      '${childCount != null ? ' | $childCount ${localizations.translate(i18Local.beneficiaryDetails.childrenLabel)}' : ''}'
                      '${pregnantWomenCount != null ? ' | $pregnantWomenCount ${localizations.translate(i18Local.beneficiaryDetails.pregnantWomenLabel)}' : ''}'
                      '${menCount != null ? ' | $menCount ${localizations.translate(i18Local.beneficiaryDetails.menLabel)}' : ''}'
                      '${womenCount != null ? ' | $womenCount ${localizations.translate(i18Local.beneficiaryDetails.womenLabel)}' : ''}'
                      '${noOfRooms != null ? ' | $noOfRooms ${localizations.translate(i18Local.beneficiaryDetails.roomsLabel)}' : ''}'
                      '${widget.distance != null ? '\n${((widget.distance!) * 1000).round() > 999 ? '(${((widget.distance!).round())} km)' : '(${((widget.distance!) * 1000).round()} m) ${localizations.translate(i18.beneficiaryDetails.fromCurrentLocation)}'}' : ''}',
                  status: getStatus(
                      tasks ?? [],
                      householdMember.projectBeneficiaries ?? [],
                      RegistrationDeliverySingleton().beneficiaryType ==
                              BeneficiaryType.individual
                          ? isNotEligible
                          : false,
                      isBeneficiaryRefused),
                  title: [
                    householdMember.headOfHousehold?.name?.givenName ??
                        localizations.translate(i18.common.coreCommonNA),
                    householdMember.headOfHousehold?.name?.familyName,
                  ].whereNotNull().join(' '),
                ),
              ),
              Flexible(
                child: DigitOutLineButton(
                  buttonStyle: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  label:
                      localizations.translate(i18.searchBeneficiary.iconLabel),
                  onPressed: widget.onOpenPressed,
                ),
              ),
            ],
          ),
          Offstage(
            offstage: !isCardExpanded,
            child: DigitTable(
              headerList: filteredHeaderList,
              tableData: tableData ?? [],
              columnWidth: 130,
              height: householdMember.members?.length == 1
                  ? 65 * 2
                  : (householdMember.members?.length ?? 0) <= 4
                      ? ((householdMember.members?.length ?? 0) + 1) * 65
                      : 5 * 68,
              scrollPhysics: (householdMember.members?.length ?? 0) <= 4
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(),
            ),
          ),
          Container(
            height: 24,
            margin: const EdgeInsets.all(4),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                isCardExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 24,
              ),
              onPressed: () => isCardExpanded = !isCardExpanded,
            ),
          ),
        ],
      ),
    );
  }

  String getTableCellText(
    StatusKeys statusKeys,
    List<TaskModel>? taskData,
    bool isBeneficiaryIneligible,
  ) {
    if (statusKeys.isNotEligible || isBeneficiaryIneligible) {
      return localizations.translate(
          i18Local.householdOverView.householdOverViewNotEligibleIconLabelSMC);
    } else if (statusKeys.isBeneficiaryReferred) {
      return localizations.translate(i18Local
          .householdOverView.householdOverViewBeneficiaryReferredLabelSMC);
    } else if (taskData != null) {
      if (taskData.isEmpty) {
        return localizations.translate(i18Local
            .householdOverView.householdOverViewNotDeliveredIconLabelSMC);
      } else if (statusKeys.isBeneficiaryRefused && !statusKeys.isStatusReset) {
        return localizations.translate(i18Local
            .householdOverView.householdOverViewBeneficiaryRefusedLabelSMC);
      } else if (statusKeys.isStatusReset) {
        return localizations.translate(i18Local
            .householdOverView.householdOverViewNotDeliveredIconLabelSMC);
      } else {
        return localizations.translate(
            i18Local.householdOverView.householdOverViewDeliveredIconLabelSMC);
      }
    } else {
      return localizations.translate(
          i18Local.householdOverView.householdOverViewNotDeliveredIconLabelSMC);
    }
  }

  // ignore: long-parameter-list
  Color getTableCellTextColor({
    required bool isNotEligible,
    required List<TaskModel>? taskdata,
    required bool isBeneficiaryRefused,
    required bool isStatusReset,
    required ThemeData theme,
    required bool isBeneficiaryIneligible,
  }) {
    return taskdata != null &&
            taskdata.isNotEmpty &&
            !isBeneficiaryRefused &&
            !isNotEligible &&
            !isStatusReset &&
            !isBeneficiaryIneligible
        ? theme.colorScheme.onSurfaceVariant
        : theme.colorScheme.error;
  }

  getStatus(
      Iterable<TaskModel> tasks,
      List<ProjectBeneficiaryModel> projectBeneficiaries,
      bool isNotEligible,
      bool isBeneficiaryRefused) {
    if (projectBeneficiaries.isNotEmpty) {
      if (tasks.isEmpty || tasks.last.status == "NOT_ADMINISTERED") {
        // INFO : for closed household status update on edit
        return Status.registered.toValue();
      } else {
        return getTaskStatus(tasks).toValue();
      }
    } else {
      return Status.notRegistered.toValue();
    }
  }

  dynamic getValueForTheKey(String key, HouseholdModel? householdModel) {
    if (householdModel == null ||
        householdModel.additionalFields == null ||
        householdModel.additionalFields!.fields.isEmpty) {
      return null;
    }
    final object = householdModel.additionalFields!.fields
        .where((element) => element.key == key)
        .firstOrNull;

    return object == null ? object : object.value;
  }
  // todo verify this , not_delivered removed check from product

  Status getTaskStatus(Iterable<TaskModel> tasks) {
    final statusMap = {
      Status.delivered.toValue(): Status.delivered,
      Status.notAdministered.toValue(): Status.notAdministered,
      Status.visited.toValue(): Status.visited,
      Status.notVisited.toValue(): Status.notVisited,
      Status.beneficiaryRefused.toValue(): Status.beneficiaryRefused,
      Status.beneficiaryReferred.toValue(): Status.beneficiaryReferred,
      Status.administeredSuccess.toValue(): Status.administeredSuccess,
      Status.administeredFailed.toValue(): Status.administeredFailed,
      Status.inComplete.toValue(): Status.inComplete,
      Status.toAdminister.toValue(): Status.toAdminister,
      Status.closeHousehold.toValue(): Status.closeHousehold,
    };

    if (tasks.isNotEmpty) {
      final mappedStatus = statusMap[tasks.last.status];
      if (mappedStatus != null) {
        return mappedStatus;
      }
    }

    // for (var task in tasks) {
    //   final mappedStatus = statusMap[task.status];
    //   if (mappedStatus != null) {
    //     return mappedStatus;
    //   }
    // }

    return Status.registered;
  }
}
