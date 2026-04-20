import 'package:dio/dio.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';

/// Provides a single Dio client so later sync work uses one entry point.
class HttpService extends GetxService {
  HttpService() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: <String, dynamic>{
          'X-Installation-Id': Get.find<InstallationService>().installationId,
        },
      ),
    );

    // Always refresh the installation header before a request leaves the app.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-Installation-Id'] =
              Get.find<InstallationService>().installationId;
          handler.next(options);
        },
      ),
    );
  }

  late final Dio dio;
}
