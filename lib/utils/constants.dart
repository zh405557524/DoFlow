/// Stores app-wide storage keys.
abstract class AppStorageKeys {
  static const String installationId = 'installation_id';
}

/// Stores Hive box names used across the app.
abstract class AppHiveBoxes {
  static const String plans = 'plans';
  static const String planPhases = 'plan_phases';
  static const String planTasks = 'plan_tasks';
  static const String taskInstances = 'task_instances';
  static const String chatMessages = 'chat_messages';
  static const String planDrafts = 'plan_drafts';
  static const String profiles = 'profiles';
  static const String noteFolders = 'note_folders';
  static const String noteFiles = 'note_files';
  static const String syncRecords = 'sync_records';

  static const List<String> all = <String>[
    plans,
    planPhases,
    planTasks,
    taskInstances,
    chatMessages,
    planDrafts,
    profiles,
    noteFolders,
    noteFiles,
    syncRecords,
  ];
}

/// Stores supported task instance statuses.
abstract class TaskInstanceStatus {
  static const String pending = 'pending';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
  static const String postponed = 'postponed';
  static const String dropped = 'dropped';
}

/// Stores supported draft statuses.
abstract class DraftStatus {
  static const String generated = 'generated';
  static const String applied = 'applied';
}

/// Stores supported sync states.
abstract class SyncStatus {
  static const String pending = 'pending_sync';
  static const String failed = 'sync_failed';
}

/// Stores plan type options for the editor UI.
abstract class PlanTypes {
  static const List<String> all = <String>[
    'Focus',
    'Learning',
    'Life',
    'Project',
  ];
}

/// Stores profile mode options.
abstract class ProfileModes {
  static const List<String> all = <String>['focus', 'balance', 'explore'];
}

/// Stores profile energy options.
abstract class ProfileEnergyLevels {
  static const List<String> all = <String>['steady', 'calm', 'sprint'];
}

/// Stores a small palette for local plans.
abstract class AppPlanColors {
  static const List<String> all = <String>[
    '#2563EB',
    '#0F766E',
    '#CA8A04',
    '#C2410C',
    '#7C3AED',
  ];
}
