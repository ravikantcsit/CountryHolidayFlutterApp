import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Configures IOHttpClientAdapter with SSL certificate verification bypass for openholidaysapi.org
void configureDioAdapter(Dio dio) {
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    },
  );
}
