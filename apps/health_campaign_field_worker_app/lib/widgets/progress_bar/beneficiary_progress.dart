import 'dart:math';

import 'package:collection/collection.dart';
import 'package:digit_components/widgets/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_repository.dart';
import '../../data/repositories/local/project_beneficiary.dart';
import '../../data/repositories/local/task.dart';
import '../../models/data_model.dart';
import '../../utils/utils.dart';
import '../progress_indicator/progress_indicator.dart';

class BeneficiaryProgressBar extends StatefulWidget {
  final String label;
  final String prefixLabel;

  const BeneficiaryProgressBar({
    Key? key,
    required this.label,
    required this.prefixLabel,
  }) : super(key: key);

  @override
  State<BeneficiaryProgressBar> createState() => _BeneficiaryProgressBarState();
}

class _BeneficiaryProgressBarState extends State<BeneficiaryProgressBar> {
  int current = 0;
  @override
  void didChangeDependencies() {
    final repository = context.read<
            LocalRepository<ProjectBeneficiaryModel,
                ProjectBeneficiarySearchModel>>()
        as ProjectBeneficiaryLocalRepository;

    final taskRepository =
        context.read<LocalRepository<TaskModel, TaskSearchModel>>()
            as TaskLocalRepository;

    taskRepository.listenToChanges(
      query: TaskSearchModel(
        projectId: context.projectId,
      ),
      listener: (taskData) async {
        if (mounted) {
          final now = DateTime.now();
          final gte = DateTime(
            now.year,
            now.month,
            now.day,
          );
          final lte = DateTime(
            now.year,
            now.month,
            now.day,
            23,
            59,
            59,
            999,
          );
          ProjectBeneficiarySearchModel beneficiarySearchModel =
              ProjectBeneficiarySearchModel(
            projectId: context.projectId,
          );
          List<ProjectBeneficiaryModel> data =
              await repository.search(beneficiarySearchModel);
          List<ProjectBeneficiaryModel> filteredProjectBeneficiaries = data
              .where((element) =>
                  (element.isDeleted == false || element.isDeleted == null))
              .toList();
          List<String> clientReferenceIdsList = filteredProjectBeneficiaries
              .map((element) => element.clientReferenceId)
              .cast<String>()
              .toList();
          TaskSearchModel taskSearchQuery = TaskSearchModel(
            projectBeneficiaryClientReferenceId: clientReferenceIdsList,
            status: Status.administeredSuccess.toValue(),
          );
          List<TaskModel> results =
              await taskRepository.search(taskSearchQuery);

          results = results
              .where((result) =>
                  DateTime.fromMillisecondsSinceEpoch(
                    result.clientAuditDetails!.createdTime,
                  ).isAfter(gte) &&
                  DateTime.fromMillisecondsSinceEpoch(
                    result.clientAuditDetails!.createdTime,
                  ).isBefore(lte))
              .toList();

          // Grouping results by client reference ID
          Map<String, List<TaskModel>> clientRefIdVsTask = {};
          clientReferenceIdsList.forEach((element) {
            var successfulAdministered = results
                .where((result) =>
                    result.projectBeneficiaryClientReferenceId == element &&
                    result.status == Status.administeredSuccess.toValue())
                .toList();
            clientRefIdVsTask[element] = clientRefIdVsTask[element] ?? [];
            clientRefIdVsTask[element]?.addAll(successfulAdministered);
          });
          setState(() {
            if (mounted) {
              current = clientRefIdVsTask.values
                  .where((value) => value.isNotEmpty)
                  .length;
            }
          });
        }
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final target = 65;

    return DigitCard(
      child: ProgressIndicatorContainer(
        label: '${max(target - current, 0).round()} ${widget.label}',
        prefixLabel: '$current ${widget.prefixLabel}',
        suffixLabel: target.toStringAsFixed(0),
        value: target == 0 ? 0 : min(current / target, 1),
      ),
    );
  }
}
