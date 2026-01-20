import '../utils/connection_exception.dart';
import '../utils/custom_interceptor.dart';
import '../constants/api_constants.dart';
import '../utils/api_exception.dart';
import 'package:dio/dio.dart';
import 'db_service.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:io';

enum Method {
  get,
  post,
  put,
  patch,
  delete,
}

class ApiService {
  const ApiService._();

  static final Dio _dio = Dio()
    ..options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      followRedirects: false,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      maxRedirects: 5,
    )
    ..interceptors.add(
      CustomInterceptor(token: DBService.token),
    );

  static Future<bool> _hasConnection() async {
    try {
      final response = await InternetAddress.lookup('google.com');
      return response.isNotEmpty && response[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  static Future<String> request(
    String path, {
    Method method = Method.get,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParameters,
    Object? body,
    FormData? formData,
  }) async {
    if (!(await _hasConnection())) {
      throw const ConnectionException('No internet connection');
    }

    try {
      final newHeaders = {
        HttpHeaders.contentTypeHeader: formData != null
            ? Headers.multipartFormDataContentType
            : Headers.jsonContentType,
        ...?headers,
      };

      final response = await _dio.request<Object?>(
        path,
        data: formData ?? body,
        queryParameters: queryParameters,
        options: Options(
          method: method.name,
          headers: newHeaders,
        ),
      );

      final decodedData = response.data;
      if (decodedData is Map<String, dynamic>) {
        return jsonEncode(decodedData);
      }
      throw ApiException(response.statusCode, 'Unexpected response format');
    } on DioException catch (e) {
      log('DioError: ${e.message}, Status Code: ${e.response?.statusCode}');
      throw ApiException(e.response?.statusCode, e.toString());
    } catch (e, stackTrace) {
      log('Unhandled error: $e');
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }
}
