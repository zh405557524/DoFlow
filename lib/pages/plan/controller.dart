import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';

enum PlanSummaryScope { today, week }

class PlanSummaryMetric {
  const PlanSummaryMetric({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;
}

/// Loads plan summaries for the Plan page.
class PlanController extends GetxController {
  bool isLoading = true;
  List<PlanModel> plans = const <PlanModel>[];
  PlanSummaryScope selectedSummaryScope = PlanSummaryScope.today;

  @override
  void onInit() {
    super.onInit();
    loadPlans();
  }

  /// Reloads the local plan list from Hive.
  Future<void> loadPlans() async {
    isLoading = true;
    update();
    plans = await Get.find<PlanService>().fetchPlans();
    isLoading = false;
    update();
  }

  int get totalPhaseCount =>
      plans.fold<int>(0, (int sum, PlanModel plan) => sum + plan.phaseCount);

  int get totalTaskCount =>
      plans.fold<int>(0, (int sum, PlanModel plan) => sum + plan.taskCount);

  int get activePlanCount {
    final DateTime now = DateTime.now();
    return plans.where((PlanModel plan) {
      return !now.isBefore(plan.startAt) && !now.isAfter(plan.endAt);
    }).length;
  }

  int get endingSoonPlanCount {
    final DateTime now = DateTime.now();
    return plans.where((PlanModel plan) {
      final int daysLeft = plan.endAt.difference(now).inDays;
      return daysLeft >= 0 && daysLeft <= 7;
    }).length;
  }

  String get summaryTitle => selectedSummaryScope == PlanSummaryScope.today
      ? '今日进度'
      : '本周推进';

  String get summaryValue {
    if (plans.isEmpty) {
      return '0/0';
    }
    if (selectedSummaryScope == PlanSummaryScope.today) {
      return '$activePlanCount/${plans.length}';
    }
    return '$totalPhaseCount/$totalTaskCount';
  }

  double get summaryProgress {
    if (plans.isEmpty) {
      return 0;
    }
    if (selectedSummaryScope == PlanSummaryScope.today) {
      return activePlanCount / plans.length;
    }
    if (totalTaskCount == 0) {
      return 0;
    }
    return totalPhaseCount / totalTaskCount;
  }

  String get summaryCaption => selectedSummaryScope == PlanSummaryScope.today
      ? '今天优先推进最值得投入的主线'
      : '把阶段拆清楚，本周推进会更稳';

  List<PlanSummaryMetric> get summaryMetrics => selectedSummaryScope ==
          PlanSummaryScope.today
      ? <PlanSummaryMetric>[
          PlanSummaryMetric(
            label: '进行中',
            value: '$activePlanCount',
            caption: '当前处于执行窗口',
          ),
          PlanSummaryMetric(
            label: '总任务',
            value: '$totalTaskCount',
            caption: '本地主线任务数',
          ),
          PlanSummaryMetric(
            label: '即将到期',
            value: '$endingSoonPlanCount',
            caption: '7 天内结束',
          ),
        ]
      : <PlanSummaryMetric>[
          PlanSummaryMetric(
            label: '计划数',
            value: '${plans.length}',
            caption: '已创建主线',
          ),
          PlanSummaryMetric(
            label: '阶段数',
            value: '$totalPhaseCount',
            caption: '所有阶段总和',
          ),
          PlanSummaryMetric(
            label: '任务数',
            value: '$totalTaskCount',
            caption: '继续拆解执行',
          ),
        ];

  void changeSummaryScope(PlanSummaryScope scope) {
    if (selectedSummaryScope == scope) {
      return;
    }
    selectedSummaryScope = scope;
    update();
  }
}
