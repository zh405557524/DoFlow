import 'package:doflow/models/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';

/// Stores local sync records so UI can render pending or failed states.
class SyncStore extends GetxService {
  static SyncStore get to => Get.find<SyncStore>();

  final RxList<SyncRecordModel> syncRecords = <SyncRecordModel>[].obs;

  /// Replaces the current sync record list.
  void setRecords(List<SyncRecordModel> items) {
    syncRecords.assignAll(items);
  }

  /// Returns true when a specific entity still has pending sync work.
  bool hasPendingFor(String entityId) {
    return syncRecords.any(
      (SyncRecordModel record) =>
          record.entityId == entityId && record.status == SyncStatus.pending,
    );
  }

  /// Returns true when a specific entity currently has a failed sync record.
  bool hasFailedFor(String entityId) {
    return syncRecords.any(
      (SyncRecordModel record) =>
          record.entityId == entityId && record.status == SyncStatus.failed,
    );
  }
}
