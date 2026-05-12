import 'package:get/get.dart';

/// Defines the tab destinations hosted by the main shell.
enum MainTab { now, plan, notes, profile }

/// Holds the active tab index for the main shell.
class MainController extends GetxController {
  MainController({required MainTab initialTab}) : currentTab = initialTab;

  MainTab currentTab;

  int get currentNavIndex => switch (currentTab) {
    MainTab.now => 0,
    MainTab.plan => 2,
    MainTab.notes => 3,
    MainTab.profile => 4,
  };

  int get currentShellIndex => switch (currentTab) {
    MainTab.now => 0,
    MainTab.plan => 1,
    MainTab.notes => 2,
    MainTab.profile => 3,
  };

  /// Synchronizes the shell state with the current route-driven tab.
  void changeTab(MainTab nextTab) {
    if (currentTab == nextTab) {
      return;
    }
    currentTab = nextTab;
    update();
  }
}
