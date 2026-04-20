import 'package:doflow/models/index.dart';
import 'package:doflow/store/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// Manages local sync records so the UI can reflect offline-first updates.
class SyncService extends GetxService {
  final Uuid _uuid = const Uuid();

  Box<dynamic> get _box => Hive.box<dynamic>(AppHiveBoxes.syncRecords);

  /// Loads existing sync records into the reactive store.
  Future<void> bootstrap() async {
    final List<SyncRecordModel> records =
        _box.values
            .map(
              (dynamic item) =>
                  SyncRecordModel.fromMap(item as Map<dynamic, dynamic>),
            )
            .toList()
          ..sort(
            (SyncRecordModel a, SyncRecordModel b) =>
                b.createdAt.compareTo(a.createdAt),
          );

    SyncStore.to.setRecords(records);
  }

  /// Appends a pending sync record for a local write.
  Future<void> recordPending({
    required String entityType,
    required String entityId,
    required String message,
  }) async {
    final SyncRecordModel record = SyncRecordModel(
      id: _uuid.v4(),
      entityType: entityType,
      entityId: entityId,
      status: SyncStatus.pending,
      message: message,
      createdAt: DateTime.now(),
    );

    await _box.put(record.id, record.toMap());
    await bootstrap();
  }
}
