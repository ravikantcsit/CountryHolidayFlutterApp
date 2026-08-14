import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'dio_adapter_stub.dart'
    if (dart.library.io) 'dio_adapter_io.dart'
    if (dart.library.js_interop) 'dio_adapter_web.dart';

/// Configured Dio singleton client for network communication
class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'User-Agent': ApiConstants.userAgent,
          'Accept': 'application/json, text/json, */*',
        },
      ),
    );

    // Apply platform-specific transport & SSL certificate configuration
    configureDioAdapter(dio);

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );

    return dio;
  }
}
