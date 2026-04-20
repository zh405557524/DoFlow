import 'package:doflow/models/index.dart';
import 'package:get/get.dart';

/// Stores locally generated plan drafts for the Chat and editor flow.
class DraftStore extends GetxService {
  static DraftStore get to => Get.find<DraftStore>();

  final RxList<PlanDraftModel> drafts = <PlanDraftModel>[].obs;

  /// Replaces the in-memory draft list with the latest values.
  void setDrafts(List<PlanDraftModel> items) {
    drafts.assignAll(items);
  }

  /// Returns a single draft if it exists in memory.
  PlanDraftModel? getDraftById(String draftId) {
    try {
      return drafts.firstWhere((PlanDraftModel draft) => draft.id == draftId);
    } catch (_) {
      return null;
    }
  }
}
