import 'package:doflow/pages/profile/index.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the personal summary page.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      global: false,
      builder: (ProfileController controller) {
        final profile = controller.profile;

        return CustomScaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: SafeArea(
            child: profile == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(18.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                profile.bio,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              SizedBox(height: 12.h),
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 8.h,
                                children: profile.tags
                                    .map((tag) => Chip(label: Text(tag)))
                                    .toList(),
                              ),
                              SizedBox(height: 16.h),
                              CustomButton(
                                label: 'Edit profile',
                                icon: Icons.edit_rounded,
                                onPressed: () {
                                  context
                                      .pushNamed(RouteName.userProfile)
                                      .then((_) => controller.loadProfile());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: _ProfileMetric(
                              label: 'Plans',
                              value: '${controller.planCount}',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _ProfileMetric(
                              label: 'Pending sync',
                              value: '${controller.pendingSyncCount}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

/// Renders a compact metric tile in the profile summary.
class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          children: [
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8.h),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
