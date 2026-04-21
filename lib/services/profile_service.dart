import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/store/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Handles local profile read/write for the profile flow.
class ProfileService extends GetxService {
  Box<dynamic> get _box => Hive.box<dynamic>(AppHiveBoxes.profiles);

  /// Loads the saved profile or creates a local default profile.
  Future<void> bootstrap() async {
    if (_box.isEmpty) {
      final ProfileModel defaultProfile = ProfileModel(
        id: 'local_profile',
        name: '执行者',
        bio: '把注意力放回真正重要的主线。',
        city: '上海',
        avatar: '🙂',
        avatarBg: '#6366F1',
        tags: const <String>['执行力', '长期主义', '专注推进'],
        energyLevel: ProfileEnergyLevels.all.first,
        mode: ProfileModes.all.first,
      );
      await _box.put(defaultProfile.id, defaultProfile.toMap());
    }

    final ProfileModel profile = ProfileModel.fromMap(
      _box.values.first as Map<dynamic, dynamic>,
    );
    UserStore.to.setProfile(profile);
  }

  /// Returns the currently saved profile snapshot.
  ProfileModel getProfile() {
    return UserStore.to.profile.value!;
  }

  /// Persists a profile update and records it for later sync.
  Future<void> saveProfile(ProfileModel profile) async {
    await _box.put(profile.id, profile.toMap());
    UserStore.to.setProfile(profile);
    await Get.find<SyncService>().recordPending(
      entityType: 'profile',
      entityId: profile.id,
      message: 'Profile updated locally.',
    );
  }
}
