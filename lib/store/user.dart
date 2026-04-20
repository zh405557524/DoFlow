import 'package:doflow/models/index.dart';
import 'package:get/get.dart';

/// Stores the local profile used by Profile and UserProfile pages.
class UserStore extends GetxService {
  static UserStore get to => Get.find<UserStore>();

  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();

  /// Replaces the current profile snapshot.
  void setProfile(ProfileModel value) {
    profile.value = value;
  }
}
