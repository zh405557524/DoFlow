import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Stores reusable local seed scenarios for development and QA.
enum SeedScenario { fullDemo }

/// Resets local business boxes and writes stable demo content for UI testing.
class LocalSeedService extends GetxService {
  Box<dynamic> get _plansBox => Hive.box<dynamic>(AppHiveBoxes.plans);
  Box<dynamic> get _phasesBox => Hive.box<dynamic>(AppHiveBoxes.planPhases);
  Box<dynamic> get _tasksBox => Hive.box<dynamic>(AppHiveBoxes.planTasks);
  Box<dynamic> get _taskInstancesBox =>
      Hive.box<dynamic>(AppHiveBoxes.taskInstances);
  Box<dynamic> get _messagesBox =>
      Hive.box<dynamic>(AppHiveBoxes.chatMessages);
  Box<dynamic> get _draftsBox => Hive.box<dynamic>(AppHiveBoxes.planDrafts);
  Box<dynamic> get _profilesBox => Hive.box<dynamic>(AppHiveBoxes.profiles);
  Box<dynamic> get _noteFoldersBox =>
      Hive.box<dynamic>(AppHiveBoxes.noteFolders);
  Box<dynamic> get _noteFilesBox => Hive.box<dynamic>(AppHiveBoxes.noteFiles);
  Box<dynamic> get _syncRecordsBox =>
      Hive.box<dynamic>(AppHiveBoxes.syncRecords);

  /// Clears business-only boxes without touching installation or config state.
  Future<void> clearBusinessData() async {
    for (final String boxName in AppHiveBoxes.business) {
      await Hive.box<dynamic>(boxName).clear();
    }
  }

  /// Replaces current business data with a stable local demo scenario.
  Future<void> resetAndSeed(SeedScenario scenario) async {
    await clearBusinessData();

    switch (scenario) {
      case SeedScenario.fullDemo:
        await _seedFullDemo();
        break;
    }

    await _refreshAppState();
  }

  Future<void> _seedFullDemo() async {
    final DateTime now = DateTime.now();

    final ProfileModel profile = ProfileModel(
      id: DemoSeedIds.profileDemoUser,
      name: '林知行',
      bio: '把注意力放回真正重要的主线。',
      city: '上海',
      avatar: '🙂',
      avatarBg: '#6366F1',
      tags: const <String>['执行力', '长期主义'],
      energyLevel: ProfileEnergyLevels.all.first,
      mode: ProfileModes.all.first,
    );
    await _profilesBox.put(profile.id, profile.toMap());

    final List<PlanModel> plans = _buildPlans(now);
    for (final PlanModel plan in plans) {
      await _storePlan(plan);
    }

    final List<TaskInstanceModel> instances = _buildTaskInstances(now);
    for (final TaskInstanceModel instance in instances) {
      await _taskInstancesBox.put(instance.id, instance.toMap());
    }

    final List<PlanDraftModel> drafts = _buildDrafts(now);
    for (final PlanDraftModel draft in drafts) {
      await _draftsBox.put(draft.id, draft.toMap());
    }

    final List<ChatMessageModel> messages = _buildMessages(now);
    for (final ChatMessageModel message in messages) {
      await _messagesBox.put(message.id, message.toMap());
    }

    final List<NoteFolderModel> folders = _buildNoteFolders(now);
    for (final NoteFolderModel folder in folders) {
      await _noteFoldersBox.put(folder.id, folder.toMap());
    }

    final List<NoteFileModel> files = _buildNoteFiles(now);
    for (final NoteFileModel file in files) {
      await _noteFilesBox.put(file.id, file.toMap());
    }

    final List<SyncRecordModel> records = _buildSyncRecords(now);
    for (final SyncRecordModel record in records) {
      await _syncRecordsBox.put(record.id, record.toMap());
    }
  }

  Future<void> _storePlan(PlanModel plan) async {
    await _plansBox.put(plan.id, plan.toOverviewMap());

    for (final PlanPhaseModel phase in plan.phases) {
      await _phasesBox.put(phase.id, phase.toMap(planId: plan.id));
      for (final PlanTaskModel task in phase.tasks) {
        await _tasksBox.put(
          task.id,
          task.toMap(planId: plan.id, phaseId: phase.id),
        );
      }
    }
  }

  Future<void> _refreshAppState() async {
    await Get.find<SyncService>().bootstrap();
    await Get.find<PlanService>().bootstrap();
    await Get.find<ChatService>().bootstrap();
    await Get.find<NotesService>().bootstrap();
    await Get.find<ProfileService>().bootstrap();
  }

  List<PlanModel> _buildPlans(DateTime now) {
    final DateTime jobStart = now.subtract(const Duration(days: 12));
    final DateTime jobEnd = now.add(const Duration(days: 18));
    final DateTime loveStart = now.subtract(const Duration(days: 6));
    final DateTime loveEnd = now.add(const Duration(days: 18));
    final DateTime portfolioStart = now.subtract(const Duration(days: 2));
    final DateTime portfolioEnd = now.add(const Duration(days: 18));

    return <PlanModel>[
      PlanModel(
        id: DemoSeedIds.planJobSwitch,
        title: '换工作冲刺',
        planType: 'Focus',
        summary: '把简历、面试题和投递节奏稳定推进到可拿到 offer。',
        startAt: jobStart,
        endAt: jobEnd,
        colorHex: '#2563EB',
        createdAt: jobStart.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        phases: <PlanPhaseModel>[
          PlanPhaseModel(
            id: 'phase_job_prepare',
            title: '准备期',
            goal: '把求职材料整理到可投递状态。',
            startAt: jobStart,
            endAt: now.subtract(const Duration(days: 5)),
            sortOrder: 0,
            tasks: <PlanTaskModel>[
              _task(
                id: 'task_job_resume',
                title: '更新中文简历',
                note: '补齐项目背景、技术栈和量化结果。',
                sortOrder: 0,
              ),
              _task(
                id: 'task_job_story',
                title: '整理 3 个项目故事',
                note: '每个故事覆盖挑战、方案和结果。',
                sortOrder: 1,
              ),
              _task(
                id: 'task_job_targets',
                title: '建立目标公司清单',
                note: '列出岗位、联系人和投递优先级。',
                sortOrder: 2,
              ),
            ],
          ),
          PlanPhaseModel(
            id: 'phase_job_interview',
            title: '面试推进',
            goal: '围绕 Android 面试题保持连续输出。',
            startAt: now.subtract(const Duration(days: 4)),
            endAt: now.add(const Duration(days: 6)),
            sortOrder: 1,
            tasks: <PlanTaskModel>[
              _task(
                id: 'task_job_android',
                title: '复习 Android 基础高频题',
                note: '优先系统设计、性能优化和四大组件。',
                sortOrder: 0,
              ),
              _task(
                id: 'task_job_algorithm',
                title: '完成 2 道算法热身题',
                note: '保持手感，重点数组和双指针。',
                sortOrder: 1,
              ),
              _task(
                id: 'task_job_mock',
                title: '做一轮 45 分钟模拟面试',
                note: '录音后复盘表达节奏。',
                sortOrder: 2,
                isOptional: true,
              ),
            ],
          ),
          PlanPhaseModel(
            id: 'phase_job_offer',
            title: '收尾决策',
            goal: '跟进反馈并完成 offer 比较。',
            startAt: now.add(const Duration(days: 7)),
            endAt: jobEnd,
            sortOrder: 2,
            tasks: <PlanTaskModel>[
              _task(
                id: 'task_job_followup',
                title: '跟进面试反馈',
                note: '统一记录反馈和后续动作。',
                sortOrder: 0,
              ),
              _task(
                id: 'task_job_offer_compare',
                title: '完成 offer 对比清单',
                note: '从成长空间、薪资和团队氛围做判断。',
                sortOrder: 1,
              ),
            ],
          ),
        ],
      ),
      PlanModel(
        id: DemoSeedIds.planLoveProgress,
        title: '恋爱关系推进',
        planType: 'Life',
        summary: '稳定推进关系节奏，让互动更自然也更真诚。',
        startAt: loveStart,
        endAt: loveEnd,
        colorHex: '#C2410C',
        createdAt: loveStart.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 3)),
        phases: <PlanPhaseModel>[
          PlanPhaseModel(
            id: 'phase_love_observe',
            title: '建立节奏',
            goal: '先感受双方舒服的互动方式。',
            startAt: loveStart,
            endAt: now.add(const Duration(days: 2)),
            sortOrder: 0,
            tasks: <PlanTaskModel>[
              _task(
                id: 'task_love_observe',
                title: '记录对方的互动节奏',
                note: '观察聊天频率和回应偏好。',
                sortOrder: 0,
              ),
              _task(
                id: 'task_love_meet',
                title: '安排一次轻松见面',
                note: '优先低压力、能自然聊天的场景。',
                sortOrder: 1,
              ),
            ],
          ),
          PlanPhaseModel(
            id: 'phase_love_build',
            title: '关系升温',
            goal: '增加共同体验和高质量表达。',
            startAt: now.add(const Duration(days: 2)),
            endAt: now.add(const Duration(days: 10)),
            sortOrder: 1,
            tasks: <PlanTaskModel>[
              _task(
                id: 'task_love_topics',
                title: '准备 3 个共同话题',
                note: '围绕近况、兴趣和价值观展开。',
                sortOrder: 0,
              ),
              _task(
                id: 'task_love_date',
                title: '规划周末约会',
                note: '地点、时间和备选方案都提前确定。',
                sortOrder: 1,
              ),
              _task(
                id: 'task_love_message',
                title: '每天发一条轻松问候',
                note: '保持自然，不用刻意输出太多。',
                sortOrder: 2,
                isOptional: true,
              ),
            ],
          ),
          PlanPhaseModel(
            id: 'phase_love_commit',
            title: '关系确认',
            goal: '在舒服的节奏下讨论期待与边界。',
            startAt: now.add(const Duration(days: 10)),
            endAt: loveEnd,
            sortOrder: 2,
            tasks: <PlanTaskModel>[
              _task(
                id: 'task_love_expect',
                title: '讨论关系预期',
                note: '表达想法，也认真听对方感受。',
                sortOrder: 0,
              ),
              _task(
                id: 'task_love_review',
                title: '复盘相处感受',
                note: '记录舒服和别扭的瞬间，避免靠猜。',
                sortOrder: 1,
              ),
            ],
          ),
        ],
      ),
      PlanModel(
        id: DemoSeedIds.planFlutterPortfolio,
        title: 'Flutter作品集发布',
        planType: 'Project',
        summary: '整理代表作品并发布成可分享的线上作品集。',
        startAt: portfolioStart,
        endAt: portfolioEnd,
        colorHex: '#7C3AED',
        createdAt: portfolioStart.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(minutes: 45)),
        phases: <PlanPhaseModel>[
          PlanPhaseModel(
            id: 'phase_portfolio_scope',
            title: '确定范围',
            goal: '先把作品集边界和素材列清楚。',
            startAt: portfolioStart,
            endAt: now.add(const Duration(days: 4)),
            sortOrder: 0,
            tasks: <PlanTaskModel>[
              _task(
                id: 'task_portfolio_list',
                title: '确认作品列表',
                note: '选出 3 个最能代表当前能力的项目。',
                sortOrder: 0,
              ),
              _task(
                id: 'task_portfolio_structure',
                title: '梳理页面结构',
                note: '确定首页、案例页和联系页信息架构。',
                sortOrder: 1,
              ),
            ],
          ),
          PlanPhaseModel(
            id: 'phase_portfolio_build',
            title: '内容打磨',
            goal: '把视觉、文案和截图整理完整。',
            startAt: now.add(const Duration(days: 4)),
            endAt: now.add(const Duration(days: 12)),
            sortOrder: 1,
            tasks: <PlanTaskModel>[
              _task(
                id: 'task_portfolio_visual',
                title: '打磨首页视觉',
                note: '统一字号、留白和强调色。',
                sortOrder: 0,
              ),
              _task(
                id: 'task_portfolio_copy',
                title: '整理项目说明文案',
                note: '每个案例写清目标、过程和结果。',
                sortOrder: 1,
              ),
            ],
          ),
          PlanPhaseModel(
            id: 'phase_portfolio_launch',
            title: '发布分享',
            goal: '把作品集发出去并收第一轮反馈。',
            startAt: now.add(const Duration(days: 12)),
            endAt: portfolioEnd,
            sortOrder: 2,
            tasks: <PlanTaskModel>[
              _task(
                id: 'task_portfolio_publish',
                title: '发布到 GitHub Pages',
                note: '确保移动端和桌面端都能正常访问。',
                sortOrder: 0,
              ),
              _task(
                id: 'task_portfolio_feedback',
                title: '分享给 3 位朋友收反馈',
                note: '记录问题和下一轮优化项。',
                sortOrder: 1,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  List<TaskInstanceModel> _buildTaskInstances(DateTime now) {
    return <TaskInstanceModel>[
      _instance(
        id: 'instance_job_resume',
        planId: DemoSeedIds.planJobSwitch,
        planTitle: '换工作冲刺',
        phaseId: 'phase_job_prepare',
        phaseTitle: '准备期',
        taskId: 'task_job_resume',
        taskTitle: '更新中文简历',
        taskNote: '补齐项目背景、技术栈和量化结果。',
        scheduledAt: now.subtract(const Duration(days: 11)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(days: 10)),
        priority: 10,
      ),
      _instance(
        id: 'instance_job_story',
        planId: DemoSeedIds.planJobSwitch,
        planTitle: '换工作冲刺',
        phaseId: 'phase_job_prepare',
        phaseTitle: '准备期',
        taskId: 'task_job_story',
        taskTitle: '整理 3 个项目故事',
        taskNote: '每个故事覆盖挑战、方案和结果。',
        scheduledAt: now.subtract(const Duration(days: 9)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(days: 8)),
        priority: 11,
      ),
      _instance(
        id: 'instance_job_targets',
        planId: DemoSeedIds.planJobSwitch,
        planTitle: '换工作冲刺',
        phaseId: 'phase_job_prepare',
        phaseTitle: '准备期',
        taskId: 'task_job_targets',
        taskTitle: '建立目标公司清单',
        taskNote: '列出岗位、联系人和投递优先级。',
        scheduledAt: now.subtract(const Duration(days: 7)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(days: 6)),
        priority: 12,
      ),
      _instance(
        id: 'instance_job_android',
        planId: DemoSeedIds.planJobSwitch,
        planTitle: '换工作冲刺',
        phaseId: 'phase_job_interview',
        phaseTitle: '面试推进',
        taskId: 'task_job_android',
        taskTitle: '复习 Android 基础高频题',
        taskNote: '优先系统设计、性能优化和四大组件。',
        scheduledAt: now.subtract(const Duration(hours: 2)),
        status: TaskInstanceStatus.inProgress,
        resolution: '',
        updatedAt: now.subtract(const Duration(minutes: 20)),
        priority: 0,
      ),
      _instance(
        id: 'instance_job_algorithm',
        planId: DemoSeedIds.planJobSwitch,
        planTitle: '换工作冲刺',
        phaseId: 'phase_job_interview',
        phaseTitle: '面试推进',
        taskId: 'task_job_algorithm',
        taskTitle: '完成 2 道算法热身题',
        taskNote: '保持手感，重点数组和双指针。',
        scheduledAt: now.add(const Duration(hours: 2)),
        status: TaskInstanceStatus.pending,
        resolution: '',
        updatedAt: now.subtract(const Duration(minutes: 5)),
        priority: 1,
      ),
      _instance(
        id: 'instance_job_mock',
        planId: DemoSeedIds.planJobSwitch,
        planTitle: '换工作冲刺',
        phaseId: 'phase_job_interview',
        phaseTitle: '面试推进',
        taskId: 'task_job_mock',
        taskTitle: '做一轮 45 分钟模拟面试',
        taskNote: '录音后复盘表达节奏。',
        scheduledAt: now.subtract(const Duration(days: 1)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(hours: 12)),
        priority: 13,
      ),
      _instance(
        id: 'instance_job_followup',
        planId: DemoSeedIds.planJobSwitch,
        planTitle: '换工作冲刺',
        phaseId: 'phase_job_offer',
        phaseTitle: '收尾决策',
        taskId: 'task_job_followup',
        taskTitle: '跟进面试反馈',
        taskNote: '统一记录反馈和后续动作。',
        scheduledAt: now.add(const Duration(days: 7)),
        status: TaskInstanceStatus.dropped,
        resolution: 'dropped',
        updatedAt: now.subtract(const Duration(hours: 3)),
        priority: 14,
      ),
      _instance(
        id: 'instance_job_offer_compare',
        planId: DemoSeedIds.planJobSwitch,
        planTitle: '换工作冲刺',
        phaseId: 'phase_job_offer',
        phaseTitle: '收尾决策',
        taskId: 'task_job_offer_compare',
        taskTitle: '完成 offer 对比清单',
        taskNote: '从成长空间、薪资和团队氛围做判断。',
        scheduledAt: now.add(const Duration(days: 9)),
        status: TaskInstanceStatus.dropped,
        resolution: 'dropped',
        updatedAt: now.subtract(const Duration(hours: 2)),
        priority: 15,
      ),
      _instance(
        id: 'instance_love_observe',
        planId: DemoSeedIds.planLoveProgress,
        planTitle: '恋爱关系推进',
        phaseId: 'phase_love_observe',
        phaseTitle: '建立节奏',
        taskId: 'task_love_observe',
        taskTitle: '记录对方的互动节奏',
        taskNote: '观察聊天频率和回应偏好。',
        scheduledAt: now.subtract(const Duration(days: 5)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(days: 4)),
        priority: 16,
      ),
      _instance(
        id: 'instance_love_meet',
        planId: DemoSeedIds.planLoveProgress,
        planTitle: '恋爱关系推进',
        phaseId: 'phase_love_observe',
        phaseTitle: '建立节奏',
        taskId: 'task_love_meet',
        taskTitle: '安排一次轻松见面',
        taskNote: '优先低压力、能自然聊天的场景。',
        scheduledAt: now.subtract(const Duration(days: 3)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(days: 2)),
        priority: 17,
      ),
      _instance(
        id: 'instance_love_topics',
        planId: DemoSeedIds.planLoveProgress,
        planTitle: '恋爱关系推进',
        phaseId: 'phase_love_build',
        phaseTitle: '关系升温',
        taskId: 'task_love_topics',
        taskTitle: '准备 3 个共同话题',
        taskNote: '围绕近况、兴趣和价值观展开。',
        scheduledAt: now.add(const Duration(hours: 10)),
        status: TaskInstanceStatus.pending,
        resolution: '',
        updatedAt: now.subtract(const Duration(minutes: 15)),
        priority: 2,
      ),
      _instance(
        id: 'instance_love_date',
        planId: DemoSeedIds.planLoveProgress,
        planTitle: '恋爱关系推进',
        phaseId: 'phase_love_build',
        phaseTitle: '关系升温',
        taskId: 'task_love_date',
        taskTitle: '规划周末约会',
        taskNote: '地点、时间和备选方案都提前确定。',
        scheduledAt: now.add(const Duration(days: 4)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(hours: 18)),
        priority: 18,
      ),
      _instance(
        id: 'instance_love_message',
        planId: DemoSeedIds.planLoveProgress,
        planTitle: '恋爱关系推进',
        phaseId: 'phase_love_build',
        phaseTitle: '关系升温',
        taskId: 'task_love_message',
        taskTitle: '每天发一条轻松问候',
        taskNote: '保持自然，不用刻意输出太多。',
        scheduledAt: now.add(const Duration(days: 5)),
        status: TaskInstanceStatus.dropped,
        resolution: 'dropped',
        updatedAt: now.subtract(const Duration(hours: 7)),
        priority: 19,
      ),
      _instance(
        id: 'instance_love_expect',
        planId: DemoSeedIds.planLoveProgress,
        planTitle: '恋爱关系推进',
        phaseId: 'phase_love_commit',
        phaseTitle: '关系确认',
        taskId: 'task_love_expect',
        taskTitle: '讨论关系预期',
        taskNote: '表达想法，也认真听对方感受。',
        scheduledAt: now.add(const Duration(days: 10)),
        status: TaskInstanceStatus.dropped,
        resolution: 'dropped',
        updatedAt: now.subtract(const Duration(hours: 4)),
        priority: 20,
      ),
      _instance(
        id: 'instance_love_review',
        planId: DemoSeedIds.planLoveProgress,
        planTitle: '恋爱关系推进',
        phaseId: 'phase_love_commit',
        phaseTitle: '关系确认',
        taskId: 'task_love_review',
        taskTitle: '复盘相处感受',
        taskNote: '记录舒服和别扭的瞬间，避免靠猜。',
        scheduledAt: now.add(const Duration(days: 12)),
        status: TaskInstanceStatus.dropped,
        resolution: 'dropped',
        updatedAt: now.subtract(const Duration(hours: 3)),
        priority: 21,
      ),
      _instance(
        id: 'instance_portfolio_list',
        planId: DemoSeedIds.planFlutterPortfolio,
        planTitle: 'Flutter作品集发布',
        phaseId: 'phase_portfolio_scope',
        phaseTitle: '确定范围',
        taskId: 'task_portfolio_list',
        taskTitle: '确认作品列表',
        taskNote: '选出 3 个最能代表当前能力的项目。',
        scheduledAt: now.subtract(const Duration(days: 2)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(days: 1)),
        priority: 22,
      ),
      _instance(
        id: 'instance_portfolio_structure',
        planId: DemoSeedIds.planFlutterPortfolio,
        planTitle: 'Flutter作品集发布',
        phaseId: 'phase_portfolio_scope',
        phaseTitle: '确定范围',
        taskId: 'task_portfolio_structure',
        taskTitle: '梳理页面结构',
        taskNote: '确定首页、案例页和联系页信息架构。',
        scheduledAt: now.add(const Duration(days: 1, hours: 2)),
        status: TaskInstanceStatus.postponed,
        resolution: 'postponed',
        updatedAt: now.subtract(const Duration(minutes: 40)),
        priority: 3,
      ),
      _instance(
        id: 'instance_portfolio_visual',
        planId: DemoSeedIds.planFlutterPortfolio,
        planTitle: 'Flutter作品集发布',
        phaseId: 'phase_portfolio_build',
        phaseTitle: '内容打磨',
        taskId: 'task_portfolio_visual',
        taskTitle: '打磨首页视觉',
        taskNote: '统一字号、留白和强调色。',
        scheduledAt: now.add(const Duration(days: 4)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(hours: 10)),
        priority: 23,
      ),
      _instance(
        id: 'instance_portfolio_copy',
        planId: DemoSeedIds.planFlutterPortfolio,
        planTitle: 'Flutter作品集发布',
        phaseId: 'phase_portfolio_build',
        phaseTitle: '内容打磨',
        taskId: 'task_portfolio_copy',
        taskTitle: '整理项目说明文案',
        taskNote: '每个案例写清目标、过程和结果。',
        scheduledAt: now.add(const Duration(days: 5)),
        status: TaskInstanceStatus.dropped,
        resolution: 'dropped',
        updatedAt: now.subtract(const Duration(hours: 8)),
        priority: 24,
      ),
      _instance(
        id: 'instance_portfolio_publish',
        planId: DemoSeedIds.planFlutterPortfolio,
        planTitle: 'Flutter作品集发布',
        phaseId: 'phase_portfolio_launch',
        phaseTitle: '发布分享',
        taskId: 'task_portfolio_publish',
        taskTitle: '发布到 GitHub Pages',
        taskNote: '确保移动端和桌面端都能正常访问。',
        scheduledAt: now.add(const Duration(days: 12)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(hours: 6)),
        priority: 25,
      ),
      _instance(
        id: 'instance_portfolio_feedback',
        planId: DemoSeedIds.planFlutterPortfolio,
        planTitle: 'Flutter作品集发布',
        phaseId: 'phase_portfolio_launch',
        phaseTitle: '发布分享',
        taskId: 'task_portfolio_feedback',
        taskTitle: '分享给 3 位朋友收反馈',
        taskNote: '记录问题和下一轮优化项。',
        scheduledAt: now.add(const Duration(days: 14)),
        status: TaskInstanceStatus.completed,
        resolution: 'completed',
        updatedAt: now.subtract(const Duration(hours: 5)),
        priority: 26,
      ),
    ];
  }

  List<PlanDraftModel> _buildDrafts(DateTime now) {
    return <PlanDraftModel>[
      PlanDraftModel(
        id: DemoSeedIds.draftChatGenerated,
        title: '副业内容日更计划',
        planType: 'Project',
        summary: '把内容输出拆成连续可执行的小步。',
        source: 'chat',
        status: DraftStatus.generated,
        createdAt: now.subtract(const Duration(minutes: 35)),
        updatedAt: now.subtract(const Duration(minutes: 35)),
        phases: <PlanPhaseModel>[
          PlanPhaseModel(
            id: 'draft_phase_content_scope',
            title: '确定题材',
            goal: '先把主题边界收清楚。',
            startAt: now,
            endAt: now.add(const Duration(days: 3)),
            sortOrder: 0,
            tasks: <PlanTaskModel>[
              _task(
                id: 'draft_task_content_topics',
                title: '列出 10 个可写话题',
                note: '优先写最熟悉的领域。',
                sortOrder: 0,
              ),
            ],
          ),
          PlanPhaseModel(
            id: 'draft_phase_content_build',
            title: '连续输出',
            goal: '形成稳定的更新节奏。',
            startAt: now.add(const Duration(days: 3)),
            endAt: now.add(const Duration(days: 10)),
            sortOrder: 1,
            tasks: <PlanTaskModel>[
              _task(
                id: 'draft_task_content_outline',
                title: '每天写 1 个提纲',
                note: '先追求稳定，不追求完美。',
                sortOrder: 0,
              ),
              _task(
                id: 'draft_task_content_publish',
                title: '发布 3 篇短内容',
                note: '优先验证表达节奏和反馈。',
                sortOrder: 1,
              ),
            ],
          ),
          PlanPhaseModel(
            id: 'draft_phase_content_review',
            title: '回看优化',
            goal: '找到最容易坚持的工作流。',
            startAt: now.add(const Duration(days: 10)),
            endAt: now.add(const Duration(days: 14)),
            sortOrder: 2,
            tasks: <PlanTaskModel>[
              _task(
                id: 'draft_task_content_review',
                title: '复盘阅读与互动数据',
                note: '保留有效动作，删掉负担。',
                sortOrder: 0,
              ),
            ],
          ),
        ],
      ),
      PlanDraftModel(
        id: DemoSeedIds.draftChatApplied,
        title: '简历改版冲刺',
        planType: 'Focus',
        summary: '一份已经被转成正式计划的历史草稿。',
        source: 'chat',
        status: DraftStatus.applied,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 6)),
        phases: <PlanPhaseModel>[
          PlanPhaseModel(
            id: 'draft_phase_resume_prepare',
            title: '资料收集',
            goal: '补齐关键项目信息。',
            startAt: now.subtract(const Duration(days: 2)),
            endAt: now.subtract(const Duration(days: 1)),
            sortOrder: 0,
            tasks: <PlanTaskModel>[
              _task(
                id: 'draft_task_resume_collect',
                title: '收集团队项目数据',
                note: '梳理职责和结果。',
                sortOrder: 0,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  List<ChatMessageModel> _buildMessages(DateTime now) {
    return <ChatMessageModel>[
      ChatMessageModel(
        id: 'message_seed_resume_user',
        role: 'user',
        content: '我想在两个月内换工作，重点准备 Android 面试和简历。',
        createdAt: now.subtract(const Duration(days: 2, minutes: 10)),
      ),
      ChatMessageModel(
        id: 'message_seed_resume_assistant',
        role: 'assistant',
        content: '我已经帮你整理了一份求职草稿，不过它已经转成正式计划了，可以继续在计划页推进。',
        createdAt: now.subtract(const Duration(days: 2, minutes: 9)),
        draftId: DemoSeedIds.draftChatApplied,
      ),
      ChatMessageModel(
        id: 'message_seed_content_user',
        role: 'user',
        content: '我想做一个副业内容输出计划，先从轻量日更开始。',
        createdAt: now.subtract(const Duration(minutes: 36)),
      ),
      ChatMessageModel(
        id: 'message_seed_content_assistant',
        role: 'assistant',
        content: '我帮你整理了一份还未应用的草稿，可以直接去编辑器里继续完善。',
        createdAt: now.subtract(const Duration(minutes: 35)),
        draftId: DemoSeedIds.draftChatGenerated,
      ),
    ];
  }

  List<NoteFolderModel> _buildNoteFolders(DateTime now) {
    return <NoteFolderModel>[
      NoteFolderModel(
        id: DemoSeedIds.noteRootProduct,
        name: '产品规划',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      NoteFolderModel(
        id: DemoSeedIds.noteRootAndroid,
        name: 'Android面试',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 18)),
      ),
      NoteFolderModel(
        id: 'note_folder_android_jvm',
        name: 'JVM',
        parentId: DemoSeedIds.noteRootAndroid,
        createdAt: now.subtract(const Duration(days: 2, hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
    ];
  }

  List<NoteFileModel> _buildNoteFiles(DateTime now) {
    return <NoteFileModel>[
      NoteFileModel(
        id: 'note_file_product_roadmap',
        title: 'v1-roadmap.md',
        folderId: DemoSeedIds.noteRootProduct,
        format: NoteFileFormats.markdown,
        content:
            '# v1 路线图\n\n'
            '- 收紧 Now 与 Profile 首屏\n'
            '- 补齐 Notes 主链路\n'
            '- 整理测试数据导入入口\n',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(hours: 20)),
      ),
      NoteFileModel(
        id: 'note_file_android_binder',
        title: 'Binder.md',
        folderId: DemoSeedIds.noteRootAndroid,
        format: NoteFileFormats.markdown,
        content:
            '# Binder 机制\n\n'
            'Binder 是 Android 系统中的一种进程间通信（IPC）机制。\n\n'
            '## 高频点\n'
            '- ServiceManager\n'
            '- Binder Driver\n'
            '- 一次拷贝\n',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 10)),
      ),
      NoteFileModel(
        id: 'note_file_android_handler',
        title: 'Handler.doc',
        folderId: DemoSeedIds.noteRootAndroid,
        format: NoteFileFormats.document,
        content:
            'Handler 面试复盘：\n'
            '1. 先讲消息循环整体结构。\n'
            '2. 再讲 Looper.prepare 与 loop。\n'
            '3. 最后讲常见内存泄漏问题。',
        createdAt: now.subtract(const Duration(days: 2, hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 9)),
      ),
      NoteFileModel(
        id: 'note_file_android_classloader',
        title: 'ClassLoader.md',
        folderId: 'note_folder_android_jvm',
        format: NoteFileFormats.markdown,
        content:
            '# ClassLoader\n\n'
            '- 双亲委派\n'
            '- PathClassLoader 与 DexClassLoader\n'
            '- 热修复场景中的类加载顺序\n',
        createdAt: now.subtract(const Duration(days: 1, hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
      NoteFileModel(
        id: 'note_file_root_weekly',
        title: 'weekly-review.md',
        format: NoteFileFormats.markdown,
        content:
            '# Weekly Review\n\n'
            '这周重点：\n'
            '- 求职推进\n'
            '- 关系节奏\n'
            '- 作品集上线\n',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }

  List<SyncRecordModel> _buildSyncRecords(DateTime now) {
    return <SyncRecordModel>[
      SyncRecordModel(
        id: 'sync_pending_now_focus',
        entityType: 'task_instance',
        entityId: 'instance_job_android',
        status: SyncStatus.pending,
        message: '当前专注中的任务尚未同步到远端。',
        createdAt: now.subtract(const Duration(minutes: 18)),
      ),
      SyncRecordModel(
        id: 'sync_pending_task_resume',
        entityType: 'plan_task',
        entityId: 'task_job_algorithm',
        status: SyncStatus.pending,
        message: '算法热身任务的状态变更等待同步。',
        createdAt: now.subtract(const Duration(minutes: 12)),
      ),
      SyncRecordModel(
        id: 'sync_failed_note_binder',
        entityType: 'note_file',
        entityId: 'note_file_android_binder',
        status: SyncStatus.failed,
        message: 'Binder 笔记最近一次同步失败，请稍后重试。',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }

  PlanTaskModel _task({
    required String id,
    required String title,
    required String note,
    required int sortOrder,
    bool isOptional = false,
  }) {
    return PlanTaskModel(
      id: id,
      title: title,
      note: note,
      sortOrder: sortOrder,
      isOptional: isOptional,
    );
  }

  TaskInstanceModel _instance({
    required String id,
    required String planId,
    required String planTitle,
    required String phaseId,
    required String phaseTitle,
    required String taskId,
    required String taskTitle,
    required String taskNote,
    required DateTime scheduledAt,
    required String status,
    required String resolution,
    required DateTime updatedAt,
    required int priority,
  }) {
    return TaskInstanceModel(
      id: id,
      planId: planId,
      planTitle: planTitle,
      phaseId: phaseId,
      phaseTitle: phaseTitle,
      taskId: taskId,
      taskTitle: taskTitle,
      taskNote: taskNote,
      scheduledAt: scheduledAt,
      status: status,
      resolution: resolution,
      updatedAt: updatedAt,
      priority: priority,
    );
  }
}
