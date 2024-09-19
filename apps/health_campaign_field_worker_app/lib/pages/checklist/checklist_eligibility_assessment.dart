import 'dart:math';

import 'package:digit_components/digit_components.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../../blocs/delivery_intervention/deliver_intervention.dart';
import '../../blocs/household_overview/household_overview.dart';
import '../../blocs/search_households/search_households.dart';
import '../../blocs/service/service.dart';
import '../../blocs/service_definition/service_definition.dart';
import '../../models/data_model.dart';
import '../../router/app_router.dart';
import '../../utils/environment_config.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/utils.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';

class EligibilityChecklistViewPage extends LocalizedStatefulWidget {
  final String? referralClientRefId;
  final IndividualModel? individual;
  final String? projectBeneficiaryClientReferenceId;
  const EligibilityChecklistViewPage({
    Key? key,
    this.referralClientRefId,
    this.individual,
    this.projectBeneficiaryClientReferenceId,
    super.appLocalizations,
  }) : super(key: key);

  @override
  State<EligibilityChecklistViewPage> createState() =>
      _EligibilityChecklistViewPageState();
}

class _EligibilityChecklistViewPageState
    extends LocalizedState<EligibilityChecklistViewPage> {
  String isStateChanged = '';
  var submitTriggered = false;
  List<TextEditingController> controller = [];
  List<TextEditingController> additionalController = [];
  List<AttributesModel>? initialAttributes;
  ServiceDefinitionModel? selectedServiceDefinition;
  bool isControllersInitialized = false;
  List<int> visibleChecklistIndexes = [];
  GlobalKey<FormState> checklistFormKey = GlobalKey<FormState>();
  Map<String?, String> responses = {};
  final String yes = "YES";

  @override
  void initState() {
    context.read<ServiceBloc>().add(
          ServiceChecklistEvent(
            value: Random().nextInt(100).toString(),
            submitTriggered: true,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var ifReferral = false;
    var ifDeliver = false;
    var ifIneligible = false;
    var projectBeneficiaryClientReferenceId =
        widget.projectBeneficiaryClientReferenceId;

    return WillPopScope(
      onWillPop: context.isHealthFacilitySupervisor &&
              widget.referralClientRefId != null
          ? () async => false
          : () async => _onBackPressed(context),
      child: Scaffold(
        body: BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
          builder: (context, householdOverviewState) {
            return BlocBuilder<ServiceDefinitionBloc, ServiceDefinitionState>(
              builder: (context, state) {
                state.mapOrNull(
                  serviceDefinitionFetch: (value) {
                    selectedServiceDefinition = value.serviceDefinitionList
                        .where((element) => element.code.toString().contains(
                              'SMCKebbi.ELIGIBLITY_ASSESSMENT.COMMUNITY_DISTRIBUTOR',
                            ))
                        .toList()
                        .first;
                    initialAttributes = selectedServiceDefinition?.attributes;
                    if (!isControllersInitialized) {
                      initialAttributes?.forEach((e) {
                        controller.add(TextEditingController());
                        if (!(context.isHealthFacilitySupervisor &&
                            widget.referralClientRefId != null)) {
                          additionalController.add(TextEditingController());
                        }
                      });

                      // Set the flag to true after initializing controllers
                      isControllersInitialized = true;
                    }
                  },
                );

                return state.maybeMap(
                  orElse: () => Text(state.runtimeType.toString()),
                  serviceDefinitionFetch: (value) {
                    return ScrollableContent(
                      header: Column(children: [
                        if (!(context.isHealthFacilitySupervisor &&
                            widget.referralClientRefId != null))
                          const BackNavigationHelpHeaderWidget(),
                      ]),
                      enableFixedButton: true,
                      footer: DigitCard(
                        margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                        padding:
                            const EdgeInsets.fromLTRB(kPadding, 0, kPadding, 0),
                        child: DigitElevatedButton(
                          onPressed: () async {
                            final router = context.router;
                            submitTriggered = true;

                            context.read<ServiceBloc>().add(
                                  const ServiceChecklistEvent(
                                    value: '',
                                    submitTriggered: true,
                                  ),
                                );
                            final isValid =
                                checklistFormKey.currentState?.validate();
                            if (!isValid!) {
                              return;
                            }
                            final itemsAttributes = initialAttributes;

                            for (int i = 0; i < controller.length; i++) {
                              if (itemsAttributes?[i].required == true &&
                                  ((itemsAttributes?[i].dataType ==
                                              'SingleValueList' &&
                                          visibleChecklistIndexes
                                              .any((e) => e == i) &&
                                          (controller[i].text == '')) ||
                                      (itemsAttributes?[i].dataType !=
                                              'SingleValueList' &&
                                          (controller[i].text == '' &&
                                              !(context
                                                      .isHealthFacilitySupervisor &&
                                                  widget.referralClientRefId !=
                                                      null))))) {
                                return;
                              }
                            }
                            for (int i = 0; i < controller.length; i++) {
                              initialAttributes;
                              var attributeCode =
                                  '${initialAttributes?[i].code}';
                              var value = initialAttributes?[i].dataType !=
                                      'SingleValueList'
                                  ? controller[i]
                                          .text
                                          .toString()
                                          .trim()
                                          .isNotEmpty
                                      ? controller[i].text.toString()
                                      : (initialAttributes?[i].dataType !=
                                              'Number'
                                          ? ''
                                          : '0')
                                  : visibleChecklistIndexes.contains(i)
                                      ? controller[i].text.toString()
                                      : i18.checklist.notSelectedKey;
                              responses[attributeCode] = value;
                            }

                            List<String>? referralReasons = [];
                            List<String?> ineligibilityReasons = [];

                            ifReferral = isReferral(responses, referralReasons);
                            ifDeliver = isDelivery(responses);
                            ifIneligible = isIneligible(
                              responses,
                              ineligibilityReasons,
                            );
                            var descriptionText = ifIneligible
                                ? localizations.translate(
                                    i18.deliverIntervention
                                        .beneficiaryIneligibleDescription,
                                  )
                                : ifReferral
                                    ? localizations.translate(
                                        i18.deliverIntervention
                                            .beneficiaryReferralDescription,
                                      )
                                    : localizations.translate(
                                        i18.deliverIntervention
                                            .spaqRedirectionScreenDescription,
                                      );

                            final shouldSubmit = await DigitDialog.show(
                              context,
                              options: DigitDialogOptions(
                                titleText: localizations.translate(
                                  i18.checklist.submitButtonDialogLabelText,
                                ),
                                content: Text(localizations
                                    .translate(
                                      i18.checklist
                                          .checklistDialogDynamicDescription,
                                    )
                                    .replaceFirst('{}', descriptionText)),
                                primaryAction: DigitDialogActions(
                                  label: localizations.translate(
                                    i18.checklist.checklistDialogPrimaryAction,
                                  ),
                                  action: (ctx) {
                                    final referenceId = IdGen.i.identifier;
                                    List<ServiceAttributesModel> attributes =
                                        [];
                                    for (int i = 0;
                                        i < controller.length;
                                        i++) {
                                      final attribute = initialAttributes;
                                      attributes.add(ServiceAttributesModel(
                                        auditDetails: AuditDetails(
                                          createdBy: context.loggedInUserUuid,
                                          createdTime:
                                              context.millisecondsSinceEpoch(),
                                        ),
                                        attributeCode: '${attribute?[i].code}',
                                        dataType: attribute?[i].dataType,
                                        clientReferenceId: IdGen.i.identifier,
                                        referenceId:
                                            context.isHealthFacilitySupervisor &&
                                                    widget.referralClientRefId !=
                                                        null
                                                ? widget.referralClientRefId
                                                : referenceId,
                                        value: attribute?[i].dataType !=
                                                'SingleValueList'
                                            ? controller[i]
                                                    .text
                                                    .toString()
                                                    .trim()
                                                    .isNotEmpty
                                                ? controller[i].text.toString()
                                                : (attribute?[i].dataType !=
                                                        'Number'
                                                    ? ''
                                                    : '0')
                                            : visibleChecklistIndexes
                                                    .contains(i)
                                                ? controller[i].text.toString()
                                                : i18.checklist.notSelectedKey,
                                        rowVersion: 1,
                                        tenantId: attribute?[i].tenantId,
                                        additionalDetails: context
                                                    .isHealthFacilitySupervisor &&
                                                widget.referralClientRefId !=
                                                    null
                                            ? null
                                            : ((attribute?[i].values?.length ==
                                                            2 ||
                                                        attribute?[i]
                                                                .values
                                                                ?.length ==
                                                            3 ||
                                                        attribute?[i]
                                                                .values
                                                                ?.length ==
                                                            4) &&
                                                    controller[i].text ==
                                                        attribute?[i]
                                                            .values?[1]
                                                            .trim())
                                                ? additionalController[i]
                                                        .text
                                                        .toString()
                                                        .isEmpty
                                                    ? null
                                                    : additionalController[i]
                                                        .text
                                                        .toString()
                                                : null,
                                      ));
                                    }

                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop(true);
                                  },
                                ),
                                secondaryAction: DigitDialogActions(
                                  label: localizations.translate(
                                    i18.checklist
                                        .checklistDialogSecondaryAction,
                                  ),
                                  action: (context) {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop(false);
                                  },
                                ),
                              ),
                            );
                            if (shouldSubmit ?? false) {
                              if (context.mounted &&
                                  (ifDeliver || ifIneligible || ifReferral)) {
                                if (ifIneligible) {
                                  // todo add the deliversubmitevent here from ineligible reasons page
                                  final clientReferenceId = IdGen.i.identifier;
                                  context.read<DeliverInterventionBloc>().add(
                                        DeliverInterventionSubmitEvent(
                                          [
                                            TaskModel(
                                              projectBeneficiaryClientReferenceId:
                                                  projectBeneficiaryClientReferenceId,
                                              clientReferenceId:
                                                  clientReferenceId,
                                              tenantId:
                                                  envConfig.variables.tenantId,
                                              rowVersion: 1,
                                              auditDetails: AuditDetails(
                                                createdBy:
                                                    context.loggedInUserUuid,
                                                createdTime: context
                                                    .millisecondsSinceEpoch(),
                                              ),
                                              projectId: context.projectId,
                                              status: Status
                                                  .beneficiaryIneligible
                                                  .toValue(),
                                              clientAuditDetails:
                                                  ClientAuditDetails(
                                                createdBy:
                                                    context.loggedInUserUuid,
                                                createdTime: context
                                                    .millisecondsSinceEpoch(),
                                                lastModifiedBy:
                                                    context.loggedInUserUuid,
                                                lastModifiedTime: context
                                                    .millisecondsSinceEpoch(),
                                              ),
                                              additionalFields:
                                                  TaskAdditionalFields(
                                                version: 1,
                                                fields: [
                                                  AdditionalField(
                                                    'taskStatus',
                                                    Status.beneficiaryIneligible
                                                        .toValue(),
                                                  ),
                                                  AdditionalField(
                                                    'ineligibleReasons',
                                                    ineligibilityReasons
                                                        .join(","),
                                                  ),
                                                ],
                                              ),
                                              address: widget
                                                  .individual!.address?.first
                                                  .copyWith(
                                                relatedClientReferenceId:
                                                    clientReferenceId,
                                                id: null,
                                              ),
                                            ),
                                          ],
                                          false,
                                          context.boundary,
                                        ),
                                      );
                                  final searchBloc =
                                      context.read<SearchHouseholdsBloc>();
                                  searchBloc.add(
                                    const SearchHouseholdsClearEvent(),
                                  );

                                  // todo check the routing once like what the back button should have text
                                  router.popAndPushAll(
                                    [
                                      AcknowledgementRoute(),
                                    ],
                                  );
                                } else if (ifReferral) {
                                  router.push(
                                    ReferBeneficiaryRoute(
                                      projectBeneficiaryClientRefId:
                                          projectBeneficiaryClientReferenceId ??
                                              "",
                                      individual: widget.individual!,
                                      referralReasons: referralReasons,
                                    ),
                                  );
                                } else {
                                  router.push(BeneficiaryDetailsRoute());
                                }
                              }
                            }
                          },
                          child: Text(
                            localizations
                                .translate(i18.common.coreCommonSubmit),
                          ),
                        ),
                      ),
                      children: [
                        Form(
                          key: checklistFormKey, //assigning key to form
                          child: DigitCard(
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  localizations.translate(
                                    selectedServiceDefinition!.code.toString(),
                                  ),
                                  style: theme.textTheme.displayMedium,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              ...initialAttributes!.map((
                                e,
                              ) {
                                int index =
                                    (initialAttributes ?? []).indexOf(e);

                                return Column(children: [
                                  if (e.dataType == 'String' &&
                                      !(e.code ?? '').contains('.')) ...[
                                    DigitTextField(
                                      autoValidation:
                                          AutovalidateMode.onUserInteraction,
                                      isRequired: true,
                                      controller: controller[index],
                                      // inputFormatter: [
                                      //   FilteringTextInputFormatter.allow(RegExp(
                                      //     "[a-zA-Z0-9]",
                                      //   )),
                                      // ],
                                      validator: (value) {
                                        if (((value == null || value == '') &&
                                            e.required == true)) {
                                          return localizations.translate(
                                            i18.common.corecommonRequired,
                                          );
                                        }
                                        if (e.regex != null) {
                                          return (RegExp(e.regex!)
                                                  .hasMatch(value!))
                                              ? null
                                              : localizations
                                                  .translate("${e.code}_REGEX");
                                        }

                                        return null;
                                      },
                                      label: localizations.translate(
                                        '${selectedServiceDefinition?.code}.${e.code}',
                                      ),
                                    ),
                                  ] else if (e.dataType == 'Number' &&
                                      !(e.code ?? '').contains('.')) ...[
                                    DigitTextField(
                                      autoValidation:
                                          AutovalidateMode.onUserInteraction,
                                      textStyle: theme.textTheme.headlineMedium,
                                      textInputType: TextInputType.number,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(
                                          "[0-9]",
                                        )),
                                      ],
                                      validator: (value) {
                                        if (((value == null || value == '') &&
                                            e.required == true)) {
                                          return localizations.translate(
                                            i18.common.corecommonRequired,
                                          );
                                        }
                                        if (e.regex != null) {
                                          return (RegExp(e.regex!)
                                                  .hasMatch(value!))
                                              ? null
                                              : localizations
                                                  .translate("${e.code}_REGEX");
                                        }

                                        return null;
                                      },
                                      controller: controller[index],
                                      label: '${localizations.translate(
                                            '${selectedServiceDefinition?.code}.${e.code}',
                                          ).trim()} ${e.required == true ? '*' : ''}',
                                    ),
                                  ] else if (e.dataType == 'MultiValueList' &&
                                      !(e.code ?? '').contains('.')) ...[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${localizations.translate(
                                                '${selectedServiceDefinition?.code}.${e.code}',
                                              )} ${e.required == true ? '*' : ''}',
                                              style:
                                                  theme.textTheme.headlineSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    BlocBuilder<ServiceBloc, ServiceState>(
                                      builder: (context, state) {
                                        return Column(
                                          children: e.values!
                                              .map((e) => DigitCheckboxTile(
                                                    label: e,
                                                    value: controller[index]
                                                        .text
                                                        .split('.')
                                                        .contains(e),
                                                    onChanged: (value) {
                                                      context
                                                          .read<ServiceBloc>()
                                                          .add(
                                                            ServiceChecklistEvent(
                                                              value:
                                                                  e.toString(),
                                                              submitTriggered:
                                                                  submitTriggered,
                                                            ),
                                                          );
                                                      final String ele;
                                                      var val =
                                                          controller[index]
                                                              .text
                                                              .split('.');
                                                      if (val.contains(e)) {
                                                        val.remove(e);
                                                        ele = val.join(".");
                                                      } else {
                                                        ele =
                                                            "${controller[index].text}.$e";
                                                      }
                                                      controller[index].value =
                                                          TextEditingController
                                                              .fromValue(
                                                        TextEditingValue(
                                                          text: ele,
                                                        ),
                                                      ).value;
                                                    },
                                                  ))
                                              .toList(),
                                        );
                                      },
                                    ),
                                  ] else if (e.dataType ==
                                      'SingleValueList') ...[
                                    if (!(e.code ?? '').contains('.'))
                                      DigitCard(
                                        child: _buildChecklist(
                                          e,
                                          index,
                                          selectedServiceDefinition,
                                          context,
                                        ),
                                      ),
                                  ],
                                ]);
                              }).toList(),
                              const SizedBox(
                                height: 15,
                              ),
                            ]),
                          ),
                        ),
                      ],
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

  Widget _buildChecklist(
    AttributesModel item,
    int index,
    ServiceDefinitionModel? selectedServiceDefinition,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    /* Check the data type of the attribute*/
    if (item.dataType == 'SingleValueList') {
      final childItems = getNextQuestions(
        item.code.toString(),
        initialAttributes ?? [],
      );
      List<int> excludedIndexes = [];

      // Ensure the current index is added to visible indexes and not excluded
      if (!visibleChecklistIndexes.contains(index) &&
          !excludedIndexes.contains(index)) {
        visibleChecklistIndexes.add(index);
      }

      // Determine excluded indexes
      for (int i = 0; i < (initialAttributes ?? []).length; i++) {
        if (!visibleChecklistIndexes.contains(i)) {
          excludedIndexes.add(i);
        }
      }

      return Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Add padding here
              child: Text(
                '${localizations.translate(
                  '${selectedServiceDefinition?.code}.${item.code}',
                )} ${item.required == true ? '*' : ''}',
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ),
          Column(
            children: [
              BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  return RadioGroup<String>.builder(
                    groupValue: controller[index].text.trim(),
                    onChanged: (value) {
                      context.read<ServiceBloc>().add(
                            ServiceChecklistEvent(
                              value: Random().nextInt(100).toString(),
                              submitTriggered: submitTriggered,
                            ),
                          );
                      setState(() {
                        // Clear child controllers and update visibility
                        for (final matchingChildItem in childItems) {
                          final childIndex =
                              initialAttributes?.indexOf(matchingChildItem);
                          if (childIndex != null) {
                            visibleChecklistIndexes
                                .removeWhere((v) => v == childIndex);
                          }
                        }

                        // Update the current controller's value
                        controller[index].value =
                            TextEditingController.fromValue(
                          TextEditingValue(
                            text: value!,
                          ),
                        ).value;

                        // Remove corresponding controllers based on the removed attributes
                      });
                    },
                    items: item.values != null
                        ? item.values!
                            .where((e) => e != i18.checklist.notSelectedKey)
                            .toList()
                        : [],
                    itemBuilder: (item) => RadioButtonBuilder(
                      localizations.translate(
                        'CORE_COMMON_${item.trim().toUpperCase()}',
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  final hasError = (item.required == true &&
                      controller[index].text.isEmpty &&
                      submitTriggered);

                  return Offstage(
                    offstage: !hasError,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        localizations.translate(
                          i18.common.corecommonRequired,
                        ),
                        style: TextStyle(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          if (childItems.isNotEmpty &&
              controller[index].text.trim().isNotEmpty) ...[
            _buildNestedChecklists(
              item.code.toString(),
              index,
              controller[index].text.trim(),
              context,
            ),
          ],
        ],
      );
    } else if (item.dataType == 'String') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DigitTextField(
          onChange: (value) {
            checklistFormKey.currentState?.validate();
          },
          isRequired: item.required ?? true,
          controller: controller[index],
          validator: (value) {
            if (((value == null || value == '') && item.required == true)) {
              return localizations.translate("${item.code}_REQUIRED");
            }
            if (item.regex != null) {
              return (RegExp(item.regex!).hasMatch(value!))
                  ? null
                  : localizations.translate("${item.code}_REGEX");
            }

            return null;
          },
          label: localizations.translate(
            '${selectedServiceDefinition?.code}.${item.code}',
          ),
        ),
      );
    } else if (item.dataType == 'Number') {
      return DigitTextField(
        autoValidation: AutovalidateMode.onUserInteraction,
        textStyle: theme.textTheme.headlineMedium,
        textInputType: TextInputType.number,
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp(
            "[0-9]",
          )),
        ],
        validator: (value) {
          if (((value == null || value == '') && item.required == true)) {
            return localizations.translate(
              i18.common.corecommonRequired,
            );
          }
          if (item.regex != null) {
            return (RegExp(item.regex!).hasMatch(value!))
                ? null
                : localizations.translate("${item.code}_REGEX");
          }

          return null;
        },
        controller: controller[index],
        label: '${localizations.translate(
              '${selectedServiceDefinition?.code}.${item.code}',
            ).trim()} ${item.required == true ? '*' : ''}',
      );
    } else if (item.dataType == 'MultiValueList') {
      return Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    '${localizations.translate(
                      '${selectedServiceDefinition?.code}.${item.code}',
                    )} ${item.required == true ? '*' : ''}',
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              return Column(
                children: item.values!
                    .map((e) => DigitCheckboxTile(
                          label: e,
                          value: controller[index].text.split('.').contains(e),
                          onChanged: (value) {
                            context.read<ServiceBloc>().add(
                                  ServiceChecklistEvent(
                                    value: e.toString(),
                                    submitTriggered: submitTriggered,
                                  ),
                                );
                            final String ele;
                            var val = controller[index].text.split('.');
                            if (val.contains(e)) {
                              val.remove(e);
                              ele = val.join(".");
                            } else {
                              ele = "${controller[index].text}.$e";
                            }
                            controller[index].value =
                                TextEditingController.fromValue(
                              TextEditingValue(
                                text: ele,
                              ),
                            ).value;
                          },
                        ))
                    .toList(),
              );
            },
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  bool isIneligible(
    Map<String?, String> responses,
    List<String?> ineligibilityReasons,
  ) {
    var isIneligible = false;
    var q3Key = "KBEA3";
    var q5Key = "KBEA4";
    Map<String, String> keyVsReason = {
      q3Key: "NOT_ADMINISTERED_IN_PREVIOUS_CYCLE",
      q5Key: "CHILD_ON_MEDICATION_1",
    };
    final individualModel = widget.individual;

    if (responses.isNotEmpty) {
      if (responses.containsKey(q3Key) && responses[q3Key]!.isNotEmpty) {
        isIneligible = responses[q3Key] == yes ? true : false;
        if (individualModel != null && isIneligible) {
          // todo : verify this if any error
          try {
            final dateOfBirth = DateFormat("dd/MM/yyyy")
                .parse(individualModel.dateOfBirth ?? '');
            final age = DigitDateUtils.calculateAge(dateOfBirth);
            final ageInMonths = getAgeMonths(age);
            isIneligible = !(ageInMonths < 60);
          } catch (error) {
            isIneligible = false;
          }
        }
      }
      if (!isIneligible &&
          (responses.containsKey(q5Key) && responses[q5Key]!.isNotEmpty)) {
        isIneligible = responses[q5Key] == yes ? true : false;
      }
      // passing all the reasons which have response as true
      if (isIneligible) {
        for (var entry in responses.entries) {
          if (entry.key == q3Key || entry.key == q5Key) {
            entry.value == yes
                ? ineligibilityReasons.add(keyVsReason[entry.key])
                : null;
          }
        }
      }
    }

    return isIneligible;
  }

  bool isReferral(
    Map<String?, String> responses,
    List<String?> referralReasons,
  ) {
    var isReferral = false;
    var q1Key = "KBEA1";
    var q2Key = "KBEA2";
    var q4Key = "KBEA3.NO.ADT1";
    Map<String, String> referralKeysVsCode = {
      q1Key: "SICK",
      q2Key: "FEVER",
      q4Key: "DRUG_SE_PC",
    };
    // TODO Configure the reasons ,verify hardcoded strings

    if (responses.isNotEmpty) {
      if (responses.containsKey(q1Key) && responses[q1Key]!.isNotEmpty) {
        isReferral = responses[q1Key] == yes ? true : false;
      }
      if (!isReferral &&
          (responses.containsKey(q2Key) && responses[q2Key]!.isNotEmpty)) {
        isReferral = responses[q2Key] == yes ? true : false;
      }
      if (!isReferral &&
          (responses.containsKey(q4Key) && responses[q4Key]!.isNotEmpty)) {
        isReferral = responses[q4Key] == yes ? true : false;
      }
    }
    if (isReferral) {
      for (var entry in referralKeysVsCode.entries) {
        if (responses.containsKey(entry.key) &&
            responses[entry.key]!.isNotEmpty) {
          if (responses[entry.key] == yes) {
            referralReasons.add(entry.value);
          }
        }
      }
    }

    return isReferral;
  }

  bool isDelivery(Map<String?, String> responses) {
    var isDeliver = true;
    for (var entry in responses.entries) {
      if (entry.value == yes) {
        isDeliver = false;
        break;
      }
    }

    return isDeliver;
  }

  // Function to build nested checklists for child attributes
  Widget _buildNestedChecklists(
    String parentCode,
    int parentIndex,
    String parentControllerValue,
    BuildContext context,
  ) {
    // Retrieve child items for the given parent code
    final childItems = getNextQuestions(
      parentCode,
      initialAttributes ?? [],
    );

    return Column(
      children: [
        // Build cards for each matching child attribute
        for (final matchingChildItem in childItems.where((childItem) =>
            childItem.code!.startsWith('$parentCode.$parentControllerValue.')))
          Card(
            margin: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
            color: countDots(matchingChildItem.code ?? '') % 4 == 2
                ? const Color.fromRGBO(238, 238, 238, 1)
                : const DigitColors().white,
            child: _buildChecklist(
              matchingChildItem,
              initialAttributes?.indexOf(matchingChildItem) ??
                  parentIndex, // Pass parentIndex here as we're building at the same level
              selectedServiceDefinition,
              context,
            ),
          ),
      ],
    );
  }

  // Function to get the next questions (child attributes) based on a parent code
  List<AttributesModel> getNextQuestions(
    String parentCode,
    List<AttributesModel> checklistItems,
  ) {
    final childCodePrefix = '$parentCode.';
    final nextCheckLists = checklistItems.where((item) {
      return item.code!.startsWith(childCodePrefix) &&
          item.code?.split('.').length == parentCode.split('.').length + 2;
    }).toList();

    return nextCheckLists;
  }

  int countDots(String inputString) {
    int dotCount = 0;
    for (int i = 0; i < inputString.length; i++) {
      if (inputString[i] == '.') {
        dotCount++;
      }
    }

    return dotCount;
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    bool? shouldNavigateBack = await showDialog<bool>(
      context: context,
      builder: (context) => DigitDialog(
        options: DigitDialogOptions(
          titleText: localizations.translate(
            i18.checklist.checklistBackDialogLabel,
          ),
          content: Text(localizations.translate(
            i18.checklist.checklistBackDialogDescription,
          )),
          primaryAction: DigitDialogActions(
            label: localizations
                .translate(i18.checklist.checklistBackDialogPrimaryAction),
            action: (ctx) {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop(true);
            },
          ),
          secondaryAction: DigitDialogActions(
            label: localizations
                .translate(i18.checklist.checklistBackDialogSecondaryAction),
            action: (context) {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop(false);
            },
          ),
        ),
      ),
    );

    return shouldNavigateBack ?? false;
  }
}
