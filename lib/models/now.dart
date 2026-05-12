import 'package:doflow/models/task_instance.dart';

/// Stores the data required to render the Now page.
class NowSnapshotModel {
  const NowSnapshotModel({
    required this.greeting,
    required this.statusLabel,
    required this.suggestionText,
    required this.recommendedTask,
    required this.backupTasks,
  });

  final String greeting;
  final String statusLabel;
  final String suggestionText;
  final TaskInstanceModel? recommendedTask;
  final List<TaskInstanceModel> backupTasks;
}
