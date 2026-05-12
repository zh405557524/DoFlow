/// Stores a local sync record for pending or failed remote sync work.
class SyncRecordModel {
  const SyncRecordModel({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.status,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String entityType;
  final String entityId;
  final String status;
  final String message;
  final DateTime createdAt;

  factory SyncRecordModel.fromMap(Map<dynamic, dynamic> map) {
    return SyncRecordModel(
      id: map['id'] as String,
      entityType: map['entityType'] as String? ?? '',
      entityId: map['entityId'] as String? ?? '',
      status: map['status'] as String? ?? '',
      message: map['message'] as String? ?? '',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'entityType': entityType,
      'entityId': entityId,
      'status': status,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
