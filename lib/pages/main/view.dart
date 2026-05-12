import 'package:doflow/pages/main/index.dart';
import 'package:doflow/pages/main/widgets/bottom_nav.dart';
import 'package:doflow/pages/notes/index.dart';
import 'package:doflow/pages/now/index.dart';
import 'package:doflow/pages/plan/index.dart';
import 'package:doflow/pages/profile/index.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Hosts the route-driven shell pages inside an IndexedStack.
class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.initialTab});

  final MainTab initialTab;

  static const List<Widget> _pages = <Widget>[
    NowPage(),
    PlanPage(),
    NotesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(initialTab: initialTab),
      global: false,
      builder: (MainController controller) {
        return CustomScaffold(
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: controller.currentShellIndex,
              children: _pages,
            ),
          ),
          bottomNavigationBar: MainBottomNav(
            currentIndex: controller.currentNavIndex,
            onTap: (int index) {
              if (index == 1) {
                context.pushNamed(RouteName.chat);
                return;
              }

              final MainTab nextTab = switch (index) {
                0 => MainTab.now,
                2 => MainTab.plan,
                3 => MainTab.notes,
                4 => MainTab.profile,
                _ => controller.currentTab,
              };
              controller.changeTab(nextTab);

              switch (nextTab) {
                case MainTab.now:
                  context.goNamed(RouteName.now);
                  return;
                case MainTab.plan:
                  context.goNamed(RouteName.plan);
                  return;
                case MainTab.notes:
                  context.goNamed(RouteName.notes);
                  return;
                case MainTab.profile:
                  context.goNamed(RouteName.profile);
                  return;
              }
            },
          ),
        );
      },
    );
  }
}
