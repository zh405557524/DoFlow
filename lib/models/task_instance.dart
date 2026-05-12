/// Stores a runnable task instance derived from a plan task.
class TaskInstanceModel {
  const TaskInstanceModel({
    required this.id,
    required this.planId,
    required this.planTitle,
    required this.phaseId,
    required this.phaseTitle,
    required this.taskId,
    required this.taskTitle,
    required this.taskNote,
    required this.scheduledAt,
    required this.status,
    required this.resolution,
    required this.updatedAt,
    required this.priority,
  });

  final String id;
  final String planId;
  final String planTitle;
  final String phaseId;
  final String phaseTitle;
  final String taskId;
  final String taskTitle;
  final String taskNote;
  final DateTime scheduledAt;
  final String status;
  final String resolution;
  final DateTime updatedAt;
  final int priority;

  TaskInstanceModel copyWith({
    String? id,
    String? planId,
    String? planTitle,
    String? phaseId,
    String? phaseTitle,
    String? taskId,
    String? taskTitle,
    String? taskNote,
    DateTime? scheduledAt,
    String? status,
    String? resolution,
    DateTime? updatedAt,
    int? priority,
  }) {
    return TaskInstanceModel(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      planTitle: planTitle ?? this.planTitle,
      phaseId: phaseId ?? this.phaseId,
      phaseTitle: phaseTitle ?? this.phaseTitle,
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      taskNote: taskNote ?? this.taskNote,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      resolution: resolution ?? this.resolution,
      updatedAt: updatedAt ?? this.updatedAt,
      priority: priority ?? this.priority,
    );
  }

  factory TaskInstanceModel.fromMap(Map<dynamic, dynamic> map) {
    return TaskInstanceModel(
      id: map['id'] as String,
      planId: map['planId'] as String? ?? '',
      planTitle: map['planTitle'] as String? ?? '',
      phaseId: map['phaseId'] as String? ?? '',
      phaseTitle: map['phaseTitle'] as String? ?? '',
      taskId: map['taskId'] as String? ?? '',
      taskTitle: map['taskTitle'] as String? ?? '',
      taskNote: map['taskNote'] as String? ?? '',
      scheduledAt:
          DateTime.tryParse(map['scheduledAt'] as String? ?? '') ??
          DateTime.now(),
      status: map['status'] as String? ?? '',
      resolution: map['resolution'] as String? ?? '',
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      priority: (map['priority'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'planId': planId,
      'planTitle': planTitle,
      'phaseId': phaseId,
      'phaseTitle': phaseTitle,
      'taskId': taskId,
      'taskTitle': taskTitle,
      'taskNote': taskNote,
      'scheduledAt': scheduledAt.toIso8601String(),
      'status': status,
      'resolution': resolution,
      'updatedAt': updatedAt.toIso8601String(),
      'priority': priority,
    };
  }
}
