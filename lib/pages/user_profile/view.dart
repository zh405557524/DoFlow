import 'package:doflow/pages/user_profile/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Renders the editable profile screen.
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(
      init: UserProfileController(),
      global: false,
      builder: (UserProfileController controller) {
        return CustomScaffold(
          appBar: AppBar(title: const Text('User profile')),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              children: [
                TextField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: controller.bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: controller.cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: controller.tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'focus, notes, planning',
                  ),
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  initialValue: controller.selectedMode,
                  decoration: const InputDecoration(labelText: 'Mode'),
                  items: ProfileModes.all
                      .map(
                        (String mode) => DropdownMenuItem<String>(
                          value: mode,
                          child: Text(mode),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    if (value == null) {
                      return;
                    }
                    controller.selectedMode = value;
                    controller.update();
                  },
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  initialValue: controller.selectedEnergyLevel,
                  decoration: const InputDecoration(labelText: 'Energy level'),
                  items: ProfileEnergyLevels.all
                      .map(
                        (String level) => DropdownMenuItem<String>(
                          value: level,
                          child: Text(level),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    if (value == null) {
                      return;
                    }
                    controller.selectedEnergyLevel = value;
                    controller.update();
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: CustomButton(
              label: controller.isSaving ? 'Saving...' : 'Save profile',
              icon: Icons.save_rounded,
              onPressed: controller.isSaving
                  ? null
                  : () async {
                      await controller.saveProfile();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
            ),
          ),
        );
      },
    );
  }
}
