import 'package:digit_components/digit_components.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/search_households/project_beneficiaries_downsync.dart';
import '../../../blocs/sync/sync.dart';
import '../../../models/entities/boundary.dart';
import '../../../models/entities/downsync.dart';
import '../../../router/app_router.dart';
import '../../../utils/i18_key_constants.dart' as i18;
import '../../../utils/utils.dart';
import '../../../widgets/header/back_navigation_help_header.dart';
import '../../../widgets/localized.dart';

class BeneficiariesReportPage extends LocalizedStatefulWidget {
  const BeneficiariesReportPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return BeneficiariesReportState();
  }
}

class BeneficiariesReportState extends LocalizedState<BeneficiariesReportPage> {
  List<DownsyncModel> downSyncList = [];
  int pendingSyncCount = 0;
  BoundaryModel? selectedBoundary;
  @override
  void initState() {
    final syncBloc = context.read<SyncBloc>();
    syncBloc.add(SyncRefreshEvent(context.loggedInUserUuid));

    final bloc = context.read<BeneficiaryDownSyncBloc>();
    bloc.add(
      const BeneficiaryDownSyncEvent.downSyncReport(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ScrollableContent(
        footer: SizedBox(
          height: 100,
          child: DigitCard(
            margin: const EdgeInsets.all(kPadding),
            child: DigitElevatedButton(
              onPressed: () {
                context.router.replace(HomeRoute());
              },
              child: Text(localizations.translate(
                i18.acknowledgementSuccess.goToHome,
              )),
            ),
          ),
        ),
        header: const BackNavigationHelpHeaderWidget(),
        children: [
          BlocListener<SyncBloc, SyncState>(
            listener: (ctx, syncState) {
              setState(() {
                pendingSyncCount = syncState.maybeWhen(
                  orElse: () => 0,
                  pendingSync: (count) => count,
                );
              });
            },
            child:
                BlocListener<BeneficiaryDownSyncBloc, BeneficiaryDownSyncState>(
              listener: (ctx, state) {
                state.maybeWhen(
                  orElse: () => false,
                  report: (downSyncCriteriaList) {
                    setState(() {
                      downSyncList = downSyncCriteriaList;
                    });
                  },
                  pendingSync: () => showDownloadDialog(
                    context,
                    model: DownloadBeneficiary(
                      title: localizations.translate(
                        i18.syncDialog.pendingSyncLabel,
                      ),
                      projectId: context.projectId,
                      boundary: selectedBoundary.toString(),
                      batchSize: 5,
                      totalCount: 0,
                      content: localizations.translate(
                        i18.syncDialog.pendingSyncContent,
                      ),
                      primaryButtonLabel: localizations.translate(
                        i18.acknowledgementSuccess.goToHome,
                      ),
                      boundaryName: selectedBoundary!.name.toString(),
                    ),
                    dialogType: DigitProgressDialogType.pendingSync,
                    isPop: false,
                  ),
                  dataFound: (initialServerCount) => showDownloadDialog(
                    context,
                    model: DownloadBeneficiary(
                      title: localizations.translate(
                        initialServerCount > 0
                            ? i18.beneficiaryDetails.dataFound
                            : i18.beneficiaryDetails.noDataFound,
                      ),
                      projectId: context.projectId,
                      boundary: selectedBoundary.toString(),
                      batchSize: 5,
                      totalCount: initialServerCount,
                      content: localizations.translate(
                        initialServerCount > 0
                            ? i18.beneficiaryDetails.dataFoundContent
                            : i18.beneficiaryDetails.noDataFoundContent,
                      ),
                      primaryButtonLabel: localizations.translate(
                        initialServerCount > 0
                            ? i18.common.coreCommonDownload
                            : i18.common.coreCommonGoback,
                      ),
                      secondaryButtonLabel: localizations.translate(
                        initialServerCount > 0
                            ? i18.beneficiaryDetails.proceedWithoutDownloading
                            : i18.acknowledgementSuccess.goToHome,
                      ),
                      boundaryName: selectedBoundary!.name.toString(),
                    ),
                    dialogType: DigitProgressDialogType.dataFound,
                    isPop: false,
                  ),
                  inProgress: (syncCount, totalCount) => showDownloadDialog(
                    context,
                    model: DownloadBeneficiary(
                      title: localizations.translate(
                        i18.beneficiaryDetails.dataDownloadInProgress,
                      ),
                      projectId: context.projectId,
                      boundary: selectedBoundary.toString(),
                      syncCount: syncCount,
                      totalCount: totalCount,
                      prefixLabel: syncCount.toString(),
                      suffixLabel: totalCount.toString(),
                      boundaryName: selectedBoundary!.name.toString(),
                    ),
                    dialogType: DigitProgressDialogType.inProgress,
                    isPop: true,
                  ),
                  success: (result) {
                    int? epochTime = result.lastSyncedTime;

                    String date =
                        '${DigitDateUtils.getTimeFromTimestamp(epochTime!)} on ${DigitDateUtils.getDateFromTimestamp(epochTime)}';
                    String dataDescription = "${localizations.translate(
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
                      boundary: selectedBoundary.toString(),
                      content: localizations.translate(
                        i18.beneficiaryDetails.dataFoundContent,
                      ),
                      primaryButtonLabel: localizations.translate(
                        i18.syncDialog.retryButtonLabel,
                      ),
                      secondaryButtonLabel: localizations.translate(
                        i18.beneficiaryDetails.proceedWithoutDownloading,
                      ),
                      boundaryName: selectedBoundary!.name.toString(),
                    ),
                    dialogType: DigitProgressDialogType.failed,
                    isPop: true,
                  ),
                  totalCountCheckFailed: () => showDownloadDialog(
                    context,
                    model: DownloadBeneficiary(
                      title: localizations.translate(
                        i18.beneficiaryDetails.unableToCheckDataInServer,
                      ),
                      projectId: context.projectId,
                      pendingSyncCount: pendingSyncCount,
                      boundary: selectedBoundary.toString(),
                      primaryButtonLabel: localizations.translate(
                        i18.syncDialog.retryButtonLabel,
                      ),
                      secondaryButtonLabel: localizations.translate(
                        i18.beneficiaryDetails.proceedWithoutDownloading,
                      ),
                      boundaryName: selectedBoundary!.name.toString(),
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
                      boundary: selectedBoundary.toString(),
                      primaryButtonLabel: localizations.translate(
                        i18.syncDialog.closeButtonLabel,
                      ),
                      secondaryButtonLabel: localizations.translate(
                        i18.beneficiaryDetails.proceedWithoutDownloading,
                      ),
                      boundaryName: selectedBoundary!.name.toString(),
                    ),
                    dialogType: DigitProgressDialogType.insufficientStorage,
                    isPop: false,
                  ),
                );
              },
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      localizations.translate(
                        i18.beneficiaryDetails.datadownloadreport,
                      ),
                      style: theme.textTheme.displayMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ...downSyncList
                    .map(
                      (e) => DigitCard(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  localizations.translate(
                                    i18.beneficiaryDetails.boundary,
                                  ),
                                  style: theme.textTheme.headlineMedium,
                                ),
                                Text(
                                  e.boundaryName!,
                                  style: theme.textTheme.headlineMedium,
                                ),
                                DigitOutLineButton(
                                  label: localizations.translate(
                                    i18.beneficiaryDetails.download,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedBoundary = BoundaryModel(
                                        code: e.locality,
                                        name: e.boundaryName,
                                      );
                                    });
                                    context.read<BeneficiaryDownSyncBloc>().add(
                                          DownSyncCheckTotalCountEvent(
                                            projectId: context.projectId,
                                            boundaryCode: e.locality!,
                                            pendingSyncCount: pendingSyncCount,
                                            boundaryName:
                                                e.boundaryName.toString(),
                                          ),
                                        );
                                  },
                                ),
                              ],
                            ),
                            DigitTableCard(
                              element: {
                                localizations.translate(
                                  i18.beneficiaryDetails.status,
                                ): e.offset == 0 && e.limit == 0
                                    ? localizations.translate(
                                        i18.beneficiaryDetails
                                            .downloadcompleted,
                                      )
                                    : localizations.translate(
                                        i18.beneficiaryDetails
                                            .partialdownloaded,
                                      ),
                                localizations.translate(
                                  i18.beneficiaryDetails.downloadtime,
                                ): e.lastSyncedTime != null
                                    ? '${DigitDateUtils.getTimeFromTimestamp(e.lastSyncedTime!)} on ${DigitDateUtils.getDateFromTimestamp(e.lastSyncedTime!)}'
                                    : '--',
                                localizations.translate(
                                  i18.beneficiaryDetails.totalrecorddownload,
                                ): e.offset == 0 && e.limit == 0
                                    ? '${e.totalCount}/${e.totalCount}'
                                    : '${e.offset}/${e.totalCount}',
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
