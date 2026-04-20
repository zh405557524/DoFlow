import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Wraps GetStorage so all lightweight local keys share one access layer.
class StorageService extends GetxService {
  late final GetStorage _box;

  /// Initializes the local lightweight key-value store.
  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  /// Reads a typed value from storage.
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Writes a value to storage.
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Removes a single key from storage.
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// Clears the whole lightweight storage box.
  Future<void> clear() async {
    await _box.erase();
  }
}
