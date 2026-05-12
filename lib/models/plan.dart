/// Stores a single editable task inside a phase.
class PlanTaskModel {
  const PlanTaskModel({
    required this.id,
    required this.title,
    required this.note,
    required this.sortOrder,
    this.isOptional = false,
  });

  final String id;
  final String title;
  final String note;
  final int sortOrder;
  final bool isOptional;

  PlanTaskModel copyWith({
    String? id,
    String? title,
    String? note,
    int? sortOrder,
    bool? isOptional,
  }) {
    return PlanTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      sortOrder: sortOrder ?? this.sortOrder,
      isOptional: isOptional ?? this.isOptional,
    );
  }

  factory PlanTaskModel.fromMap(Map<dynamic, dynamic> map) {
    return PlanTaskModel(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      note: map['note'] as String? ?? '',
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
      isOptional: map['isOptional'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap({String? planId, String? phaseId}) {
    return <String, dynamic>{
      'id': id,
      'planId': planId,
      'phaseId': phaseId,
      'title': title,
      'note': note,
      'sortOrder': sortOrder,
      'isOptional': isOptional,
    };
  }
}

/// Stores a single phase and its tasks.
class PlanPhaseModel {
  const PlanPhaseModel({
    required this.id,
    required this.title,
    required this.goal,
    required this.startAt,
    required this.endAt,
    required this.sortOrder,
    required this.tasks,
  });

  final String id;
  final String title;
  final String goal;
  final DateTime startAt;
  final DateTime endAt;
  final int sortOrder;
  final List<PlanTaskModel> tasks;

  PlanPhaseModel copyWith({
    String? id,
    String? title,
    String? goal,
    DateTime? startAt,
    DateTime? endAt,
    int? sortOrder,
    List<PlanTaskModel>? tasks,
  }) {
    return PlanPhaseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      goal: goal ?? this.goal,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      sortOrder: sortOrder ?? this.sortOrder,
      tasks: tasks ?? this.tasks,
    );
  }

  factory PlanPhaseModel.fromMap(
    Map<dynamic, dynamic> map, {
    List<PlanTaskModel> tasks = const <PlanTaskModel>[],
  }) {
    return PlanPhaseModel(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      goal: map['goal'] as String? ?? '',
      startAt:
          DateTime.tryParse(map['startAt'] as String? ?? '') ?? DateTime.now(),
      endAt: DateTime.tryParse(map['endAt'] as String? ?? '') ?? DateTime.now(),
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
      tasks: tasks,
    );
  }

  Map<String, dynamic> toMap({String? planId}) {
    return <String, dynamic>{
      'id': id,
      'planId': planId,
      'title': title,
      'goal': goal,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'sortOrder': sortOrder,
    };
  }
}

/// Stores a full plan aggregate that the UI can render directly.
class PlanModel {
  const PlanModel({
    required this.id,
    required this.title,
    required this.planType,
    required this.summary,
    required this.startAt,
    required this.endAt,
    required this.colorHex,
    required this.createdAt,
    required this.updatedAt,
    required this.phases,
  });

  final String id;
  final String title;
  final String planType;
  final String summary;
  final DateTime startAt;
  final DateTime endAt;
  final String colorHex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PlanPhaseModel> phases;

  int get phaseCount => phases.length;
  int get taskCount =>
      phases.fold<int>(0, (sum, phase) => sum + phase.tasks.length);

  PlanModel copyWith({
    String? id,
    String? title,
    String? planType,
    String? summary,
    DateTime? startAt,
    DateTime? endAt,
    String? colorHex,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<PlanPhaseModel>? phases,
  }) {
    return PlanModel(
      id: id ?? this.id,
      title: title ?? this.title,
      planType: planType ?? this.planType,
      summary: summary ?? this.summary,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      phases: phases ?? this.phases,
    );
  }

  factory PlanModel.fromMap(
    Map<dynamic, dynamic> map, {
    List<PlanPhaseModel> phases = const <PlanPhaseModel>[],
  }) {
    return PlanModel(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      planType: map['planType'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      startAt:
          DateTime.tryParse(map['startAt'] as String? ?? '') ?? DateTime.now(),
      endAt: DateTime.tryParse(map['endAt'] as String? ?? '') ?? DateTime.now(),
      colorHex: map['colorHex'] as String? ?? '#2563EB',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      phases: phases,
    );
  }

  Map<String, dynamic> toOverviewMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'planType': planType,
      'summary': summary,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'colorHex': colorHex,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
