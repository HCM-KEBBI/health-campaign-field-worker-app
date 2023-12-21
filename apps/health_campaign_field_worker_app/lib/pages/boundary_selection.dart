import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../blocs/boundary/boundary.dart';
import '../blocs/localization/app_localization.dart';
import '../models/data_model.dart';
import '../utils/i18_key_constants.dart' as i18;
import '../blocs/search_households/project_beneficiaries_downsync.dart';
import '../blocs/sync/sync.dart';
import '../models/data_model.dart';
import '../router/app_router.dart';
import '../utils/i18_key_constants.dart' as i18;
import '../utils/utils.dart';
import '../widgets/localized.dart';

class BoundarySelectionPage extends LocalizedStatefulWidget {
  const BoundarySelectionPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<BoundarySelectionPage> createState() => _BoundarySelectionPageState();
}

class _BoundarySelectionPageState
    extends LocalizedState<BoundarySelectionPage> {
  bool shouldPop = false;
  Map<String, FormControl<BoundaryModel>> formControls = {};
  int i = 0;
  int pendingSyncCount = 0;

  @override
  void initState() {
    context.read<SyncBloc>().add(SyncRefreshEvent(context.loggedInUserUuid));
    context.read<BeneficiaryDownSyncBloc>().add(
          const DownSyncResetStateEvent(),
        );
    super.initState();
  }

  @override
  void deactivate() {
    context.read<BeneficiaryDownSyncBloc>().add(
          const DownSyncResetStateEvent(),
        );
    super.deactivate();
  }

  Future<void> initDiskSpace() async {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => shouldPop,
      child: BlocBuilder<BoundaryBloc, BoundaryState>(
        builder: (context, state) {
          final selectedBoundary = state.selectedBoundaryMap.entries
              .lastWhereOrNull((element) => element.value != null);

          return Scaffold(
            body: Builder(
              builder: (context) {
                if (state.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final labelList = state.selectedBoundaryMap.keys.toList();

                return ReactiveFormBuilder(
                  form: () => buildForm(state),
                  builder: (context, form, child) => Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: labelList.length,
                          itemBuilder: (context, labelIndex) {
                            final label = labelList.elementAt(labelIndex);

                            final filteredItems =
                                state.boundaryList.where((element) {
                              if (element.label != label) return false;

                              if (labelIndex == 0) return true;
                              final parentIndex = labelIndex - 1;

                              final parentBoundaryEntry = state
                                  .selectedBoundaryMap.entries
                                  .elementAtOrNull(parentIndex);
                              final parentBoundary = parentBoundaryEntry?.value;
                              if (parentBoundary == null) return false;

                              if (element.materializedPathList
                                  .contains(parentBoundary.code)) {
                                return true;
                              }

                              return false;
                            }).toList();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kPadding * 2,
                              ),
                              child: DigitDropdown<BoundaryModel>(
                                initialValue: formControls[label]?.value,
                                label: label,
                                menuItems: filteredItems,
                                isRequired: labelIndex == 0,
                                onChanged: (value) {
                                  if (value == null) return;

                                  context.read<BoundaryBloc>().add(
                                        BoundarySelectEvent(
                                          label: label,
                                          selectedBoundary: value,
                                        ),
                                      );
                                  formControls[label]?.updateValue(value);
                                  // Call the resetChildDropdowns function when a parent dropdown is selected
                                  resetChildDropdowns(label, state);
                                },
                                valueMapper: (value) {
                                  return value.name ?? value.code ?? 'No Value';
                                },
                                formControlName: label,
                                validationMessages: {
                                  'required': (object) => AppLocalizations.of(
                                        context,
                                      ).translate(
                                        i18.common.corecommonRequired,
                                      ),
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      BlocListener<BeneficiaryDownSyncBloc,
                          BeneficiaryDownSyncState>(
                        listener: (context, downSyncState) {
                          downSyncState.maybeWhen(
                            orElse: () => false,
                            pendingSync: () => showDownloadDialog(
                              context,
                              model: DownloadBeneficiary(
                                title: localizations.translate(
                                  i18.syncDialog.pendingSyncLabel,
                                ),
                                projectId: context.projectId,
                                boundary:
                                    selectedBoundary!.value!.code.toString(),
                                batchSize: 15,
                                totalCount: 0,
                                content: localizations.translate(
                                  i18.syncDialog.pendingSyncContent,
                                ),
                                primaryButtonLabel: localizations.translate(
                                  i18.acknowledgementSuccess.goToHome,
                                ),
                                boundaryName:
                                    selectedBoundary.value!.name.toString(),
                              ),
                              dialogType: DigitProgressDialogType.pendingSync,
                              isPop: false,
                            ),
                            dataFound: (initialServerCount) =>
                                showDownloadDialog(
                              context,
                              model: DownloadBeneficiary(
                                title: localizations.translate(
                                  initialServerCount > 0
                                      ? i18.beneficiaryDetails.dataFound
                                      : i18.beneficiaryDetails.noDataFound,
                                ),
                                projectId: context.projectId,
                                boundary:
                                    selectedBoundary!.value!.code.toString(),
                                batchSize: 15,
                                totalCount: initialServerCount,
                                content: localizations.translate(
                                  initialServerCount > 0
                                      ? i18.beneficiaryDetails.dataFoundContent
                                      : i18.beneficiaryDetails
                                          .noDataFoundContent,
                                ),
                                primaryButtonLabel: localizations.translate(
                                  initialServerCount > 0
                                      ? i18.common.coreCommonDownload
                                      : i18.common.coreCommonGoback,
                                ),
                                secondaryButtonLabel: localizations.translate(
                                  initialServerCount > 0
                                      ? i18.beneficiaryDetails
                                          .proceedWithoutDownloading
                                      : i18.acknowledgementSuccess.goToHome,
                                ),
                                boundaryName:
                                    selectedBoundary.value!.name.toString(),
                              ),
                              dialogType: DigitProgressDialogType.dataFound,
                              isPop: false,
                            ),
                            inProgress: (syncCount, totalCount) =>
                                showDownloadDialog(
                              context,
                              model: DownloadBeneficiary(
                                title: localizations.translate(
                                  i18.beneficiaryDetails.dataDownloadInProgress,
                                ),
                                projectId: context.projectId,
                                boundary:
                                    selectedBoundary!.value!.code.toString(),
                                syncCount: syncCount,
                                totalCount: totalCount,
                                prefixLabel: syncCount.toString(),
                                suffixLabel: totalCount.toString(),
                                boundaryName:
                                    selectedBoundary.value!.name.toString(),
                              ),
                              dialogType: DigitProgressDialogType.inProgress,
                              isPop: true,
                            ),
                            success: (result) {
                              int? epochTime = result.lastSyncedTime;

                              String date =
                                  '${DigitDateUtils.getTimeFromTimestamp(epochTime!)} on ${DigitDateUtils.getDateFromTimestamp(epochTime)}';
                              String dataDescription =
                                  "${localizations.translate(
                                i18.beneficiaryDetails.downloadreport,
                              )}\n\n\n${localizations.translate(
                                i18.beneficiaryDetails.boundary,
                              )} ${result.boundaryName}\n${localizations.translate(
                                i18.beneficiaryDetails.status,
                              )} ${localizations.translate(
                                i18.beneficiaryDetails.downloadcompleted,
                              )}\n${localizations.translate(
                                i18.beneficiaryDetails.downloadedon,
                              )} $date\n${localizations.translate(
                                i18.beneficiaryDetails.recordsdownload,
                              )} ${result.totalCount}/${result.totalCount}";
                              Navigator.of(context, rootNavigator: true).pop();
                              context.router.popAndPush((AcknowledgementRoute(
                                isDataRecordSuccess: true,
                                description: dataDescription,
                              )));
                            },
                            failed: () => showDownloadDialog(
                              context,
                              model: DownloadBeneficiary(
                                title: localizations.translate(
                                  i18.common.coreCommonDownloadFailed,
                                ),
                                projectId: context.projectId,
                                pendingSyncCount: pendingSyncCount,
                                boundary:
                                    selectedBoundary!.value!.code.toString(),
                                content: localizations.translate(
                                  i18.beneficiaryDetails.dataFoundContent,
                                ),
                                primaryButtonLabel: localizations.translate(
                                  i18.syncDialog.retryButtonLabel,
                                ),
                                secondaryButtonLabel: localizations.translate(
                                  i18.beneficiaryDetails
                                      .proceedWithoutDownloading,
                                ),
                                boundaryName:
                                    selectedBoundary.value!.name.toString(),
                              ),
                              dialogType: DigitProgressDialogType.failed,
                              isPop: true,
                            ),
                            totalCountCheckFailed: () => showDownloadDialog(
                              context,
                              model: DownloadBeneficiary(
                                title: localizations.translate(
                                  i18.beneficiaryDetails
                                      .unableToCheckDataInServer,
                                ),
                                projectId: context.projectId,
                                pendingSyncCount: pendingSyncCount,
                                boundary:
                                    selectedBoundary!.value!.code.toString(),
                                primaryButtonLabel: localizations.translate(
                                  i18.syncDialog.retryButtonLabel,
                                ),
                                secondaryButtonLabel: localizations.translate(
                                  i18.beneficiaryDetails
                                      .proceedWithoutDownloading,
                                ),
                                boundaryName:
                                    selectedBoundary.value!.name.toString(),
                              ),
                              dialogType: DigitProgressDialogType.checkFailed,
                              isPop: false,
                            ),
                            insufficientStorage: () => showDownloadDialog(
                              context,
                              model: DownloadBeneficiary(
                                title: localizations.translate(
                                  i18.beneficiaryDetails.insufficientStorage,
                                ),
                                projectId: context.projectId,
                                boundary:
                                    selectedBoundary!.value!.code.toString(),
                                primaryButtonLabel: localizations.translate(
                                  i18.syncDialog.closeButtonLabel,
                                ),
                                secondaryButtonLabel: localizations.translate(
                                  i18.beneficiaryDetails
                                      .proceedWithoutDownloading,
                                ),
                                boundaryName:
                                    selectedBoundary.value!.name.toString(),
                              ),
                              dialogType:
                                  DigitProgressDialogType.insufficientStorage,
                              isPop: false,
                            ),
                          );
                        },
                        child: DigitCard(
                          margin:
                              const EdgeInsets.only(left: 0, right: 0, top: 10),
                          child: SafeArea(
                            child: BlocListener<SyncBloc, SyncState>(
                              listener: (context, syncState) {
                                setState(() {
                                  pendingSyncCount = syncState.maybeWhen(
                                    orElse: () => 0,
                                    pendingSync: (count) => count,
                                  );
                                });
                              },
                              child: DigitElevatedButton(
                                onPressed: selectedBoundary == null
                                    ? null
                                    : () async {
                                        setState(() {
                                          shouldPop = true;
                                        });

                                        context.read<BoundaryBloc>().add(
                                              const BoundarySubmitEvent(),
                                            );
                                        bool isOnline = await getIsConnected();

                                        if (context.mounted) {
                                          if (isOnline) {
                                            context
                                                .read<BeneficiaryDownSyncBloc>()
                                                .add(
                                                  DownSyncCheckTotalCountEvent(
                                                    projectId:
                                                        context.projectId,
                                                    boundaryCode:
                                                        selectedBoundary
                                                            .value!.code
                                                            .toString(),
                                                    pendingSyncCount:
                                                        pendingSyncCount,
                                                    boundaryName:
                                                        selectedBoundary
                                                            .value!.name
                                                            .toString(),
                                                  ),
                                                );
                                          } else {
                                            Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () => context.router.pop(),
                                            );
                                          }
                                        }
                                      },
                                child: const Text('Submit'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void resetChildDropdowns(String parentLabel, BoundaryState state) {
    final labelList = state.selectedBoundaryMap.keys.toList();
    final parentIndex = labelList.indexOf(parentLabel);

    for (int i = parentIndex + 1; i < labelList.length; i++) {
      final label = labelList[i];
      formControls[label]?.updateValue(null);
    }
  }

  FormGroup buildForm(BoundaryState state) {
    formControls = {};
    final labelList = state.selectedBoundaryMap.keys.toList();

    for (final label in labelList) {
      formControls[label] = FormControl<BoundaryModel>(
        validators: [],
        value: state.selectedBoundaryMap[label],
      );
    }

    return fb.group(formControls);
  }
}
