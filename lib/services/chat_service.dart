import 'package:doflow/models/index.dart';
import 'package:doflow/services/sync_service.dart';
import 'package:doflow/store/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// Handles local chat history and mock plan draft generation.
class ChatService extends GetxService {
  final Uuid _uuid = const Uuid();

  Box<dynamic> get _messagesBox => Hive.box<dynamic>(AppHiveBoxes.chatMessages);
  Box<dynamic> get _draftsBox => Hive.box<dynamic>(AppHiveBoxes.planDrafts);

  /// Loads existing drafts so the editor can consume them later.
  Future<void> bootstrap() async {
    final List<PlanDraftModel> drafts =
        _draftsBox.values
            .map(
              (dynamic item) =>
                  PlanDraftModel.fromMap(item as Map<dynamic, dynamic>),
            )
            .toList()
          ..sort(
            (PlanDraftModel a, PlanDraftModel b) =>
                b.updatedAt.compareTo(a.updatedAt),
          );
    DraftStore.to.setDrafts(drafts);
  }

  /// Reads the full local chat history.
  Future<List<ChatMessageModel>> fetchMessages() async {
    final List<ChatMessageModel> messages =
        _messagesBox.values
            .map(
              (dynamic item) =>
                  ChatMessageModel.fromMap(item as Map<dynamic, dynamic>),
            )
            .toList()
          ..sort(
            (ChatMessageModel a, ChatMessageModel b) =>
                a.createdAt.compareTo(b.createdAt),
          );
    return messages;
  }

  /// Appends a local assistant message without generating a new draft.
  Future<void> addAssistantMessage(String content, {String? draftId}) async {
    final ChatMessageModel message = ChatMessageModel(
      id: _uuid.v4(),
      role: 'assistant',
      content: content.trim(),
      createdAt: DateTime.now(),
      draftId: draftId,
    );
    await _messagesBox.put(message.id, message.toMap());
  }

  /// Returns a single draft for the editor route.
  PlanDraftModel? getDraftById(String draftId) {
    return DraftStore.to.getDraftById(draftId);
  }

  /// Generates a mock assistant reply plus a plan draft from free-form text.
  Future<void> sendMessage(String content) async {
    final DateTime now = DateTime.now();
    final ChatMessageModel userMessage = ChatMessageModel(
      id: _uuid.v4(),
      role: 'user',
      content: content.trim(),
      createdAt: now,
    );
    final PlanDraftModel draft = _buildDraftFromMessage(content.trim(), now);
    final ChatMessageModel assistantMessage = ChatMessageModel(
      id: _uuid.v4(),
      role: 'assistant',
      content:
          'I created a draft plan for this idea. Review it and apply the draft when it feels right.',
      createdAt: now.add(const Duration(milliseconds: 200)),
      draftId: draft.id,
    );

    await _messagesBox.put(userMessage.id, userMessage.toMap());
    await _draftsBox.put(draft.id, draft.toMap());
    await _messagesBox.put(assistantMessage.id, assistantMessage.toMap());
    await bootstrap();
    await Get.find<SyncService>().recordPending(
      entityType: 'chat',
      entityId: userMessage.id,
      message: 'Chat message stored locally.',
    );
  }

  /// Marks a draft as consumed once the editor saves it as a plan.
  Future<void> markDraftApplied(String draftId) async {
    final PlanDraftModel? draft = getDraftById(draftId);
    if (draft == null) {
      return;
    }

    final Map<String, dynamic> updated = draft.toMap();
    updated['status'] = DraftStatus.applied;
    await _draftsBox.put(draft.id, updated);
    await bootstrap();
  }

  /// Builds a simple multi-phase plan draft from a natural language prompt.
  PlanDraftModel _buildDraftFromMessage(String content, DateTime now) {
    final String normalized = content.isEmpty ? 'New focus plan' : content;
    final String title = normalized.length > 28
        ? '${normalized.substring(0, 28)}...'
        : normalized;
    final List<String> taskSeeds = normalized
        .split(RegExp(r'[,.，。;；\n]'))
        .map((String item) => item.trim())
        .where((String item) => item.isNotEmpty)
        .toList();
    final List<String> fallbackTasks = taskSeeds.isEmpty
        ? <String>[
            'Clarify the goal',
            'Break the goal into smaller steps',
            'Review the result',
          ]
        : taskSeeds;

    final List<PlanPhaseModel> phases = <PlanPhaseModel>[
      PlanPhaseModel(
        id: _uuid.v4(),
        title: 'Define',
        goal: 'Make the goal concrete.',
        startAt: now,
        endAt: now.add(const Duration(days: 3)),
        sortOrder: 0,
        tasks: <PlanTaskModel>[
          PlanTaskModel(
            id: _uuid.v4(),
            title: fallbackTasks.first,
            note: 'Capture the main intent in one sentence.',
            sortOrder: 0,
          ),
        ],
      ),
      PlanPhaseModel(
        id: _uuid.v4(),
        title: 'Execute',
        goal: 'Move the work forward every day.',
        startAt: now.add(const Duration(days: 3)),
        endAt: now.add(const Duration(days: 10)),
        sortOrder: 1,
        tasks: fallbackTasks
            .skip(1)
            .take(2)
            .toList()
            .asMap()
            .entries
            .map(
              (MapEntry<int, String> entry) => PlanTaskModel(
                id: _uuid.v4(),
                title: entry.value,
                note: 'Turn this into a visible action.',
                sortOrder: entry.key,
              ),
            )
            .toList(),
      ),
      PlanPhaseModel(
        id: _uuid.v4(),
        title: 'Review',
        goal: 'Capture what worked and what changes next.',
        startAt: now.add(const Duration(days: 10)),
        endAt: now.add(const Duration(days: 14)),
        sortOrder: 2,
        tasks: <PlanTaskModel>[
          PlanTaskModel(
            id: _uuid.v4(),
            title: 'Review progress',
            note: 'Decide what to keep, change, or archive.',
            sortOrder: 0,
          ),
        ],
      ),
    ];

    return PlanDraftModel(
      id: _uuid.v4(),
      title: title,
      planType: PlanTypes.all.first,
      summary: 'Draft generated from chat input.',
      source: 'chat',
      status: DraftStatus.generated,
      createdAt: now,
      updatedAt: now,
      phases: phases,
    );
  }
}
