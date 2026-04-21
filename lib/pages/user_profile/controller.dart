import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/store/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Owns the editable profile form.
class UserProfileController extends GetxController {
  static const List<String> avatarOptions = <String>[
    '🙂',
    '😎',
    '🤖',
    '🚀',
    '🧠',
    '🔥',
    '🌟',
    '🦊',
    '🐼',
    '🦁',
    '🎯',
    '💡',
  ];

  static const List<String> avatarBgOptions = <String>[
    '#6366F1',
    '#8B5CF6',
    '#EC4899',
    '#F59E0B',
    '#10B981',
    '#3B82F6',
    '#EF4444',
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  String selectedMode = ProfileModes.all.first;
  String selectedEnergyLevel = ProfileEnergyLevels.all.first;
  String selectedAvatar = avatarOptions.first;
  String selectedAvatarBg = avatarBgOptions.first;
  bool isSaving = false;

  @override
  void onInit() {
    super.onInit();
    final ProfileModel profile = UserStore.to.profile.value!;
    nameController.text = profile.name;
    bioController.text = profile.bio;
    cityController.text = profile.city;
    tagsController.text = profile.tags.join(', ');
    selectedMode = profile.mode;
    selectedEnergyLevel = profile.energyLevel;
    selectedAvatar = profile.avatar;
    selectedAvatarBg = profile.avatarBg;
  }

  @override
  void onClose() {
    nameController.dispose();
    bioController.dispose();
    cityController.dispose();
    tagsController.dispose();
    super.onClose();
  }

  /// Saves the current profile form back into local storage.
  Future<void> saveProfile() async {
    if (isSaving) {
      return;
    }
    isSaving = true;
    update();

    final ProfileModel current = UserStore.to.profile.value!;
    final ProfileModel updated = current.copyWith(
      name: nameController.text.trim(),
      bio: bioController.text.trim(),
      city: cityController.text.trim(),
      avatar: selectedAvatar,
      avatarBg: selectedAvatarBg,
      tags: tagsController.text
          .split(',')
          .map((String item) => item.trim())
          .where((String item) => item.isNotEmpty)
          .toList(),
      mode: selectedMode,
      energyLevel: selectedEnergyLevel,
    );

    await Get.find<ProfileService>().saveProfile(updated);
    isSaving = false;
    update();
  }
}
