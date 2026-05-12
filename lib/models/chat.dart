import 'package:doflow/models/plan.dart';

/// Stores a single chat message in the local conversation history.
class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.draftId,
  });

  final String id;
  final String role;
  final String content;
  final DateTime createdAt;
  final String? draftId;

  factory ChatMessageModel.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] as String,
      role: map['role'] as String? ?? 'assistant',
      content: map['content'] as String? ?? '',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      draftId: map['draftId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'role': role,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'draftId': draftId,
    };
  }
}

/// Stores a generated draft before it becomes a formal plan.
class PlanDraftModel {
  const PlanDraftModel({
    required this.id,
    required this.title,
    required this.planType,
    required this.summary,
    required this.source,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.phases,
  });

  final String id;
  final String title;
  final String planType;
  final String summary;
  final String source;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PlanPhaseModel> phases;

  factory PlanDraftModel.fromMap(Map<dynamic, dynamic> map) {
    final List<dynamic> phasesData =
        map['phases'] as List<dynamic>? ?? <dynamic>[];

    return PlanDraftModel(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      planType: map['planType'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      source: map['source'] as String? ?? '',
      status: map['status'] as String? ?? '',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      phases: phasesData.map((dynamic phaseData) {
        final Map<dynamic, dynamic> phaseMap =
            phaseData as Map<dynamic, dynamic>;
        final List<dynamic> tasksData =
            phaseMap['tasks'] as List<dynamic>? ?? <dynamic>[];

        return PlanPhaseModel.fromMap(
          phaseMap,
          tasks: tasksData
              .map(
                (dynamic taskData) =>
                    PlanTaskModel.fromMap(taskData as Map<dynamic, dynamic>),
              )
              .toList(),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'planType': planType,
      'summary': summary,
      'source': source,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'phases': phases
          .map(
            (PlanPhaseModel phase) => <String, dynamic>{
              ...phase.toMap(),
              'tasks': phase.tasks
                  .map((PlanTaskModel task) => task.toMap())
                  .toList(),
            },
          )
          .toList(),
    };
  }
}
