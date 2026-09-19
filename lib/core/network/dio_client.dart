import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Accept': 'application/json'},
          ),
        );

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) {
    return _dio.get(path, queryParameters: query);
  }
}