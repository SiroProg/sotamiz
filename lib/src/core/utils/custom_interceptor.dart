import 'package:dio/dio.dart';
import 'logger.dart';

class CustomInterceptor extends Interceptor {
  const CustomInterceptor({required this.token});
  final String token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({"X-Api-Token": token});
    info('''
------------------------------------------------------------
        === Request (${options.method}) ===
        === Url: ${options.uri} ===
        === Headers: ${options.headers} ===
        === Data: ${options.data}
------------------------------------------------------------''');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    info('''
------------------------------------------------------------
=== Response (${response.statusCode}) ===
=== Url: ${response.realUri} ===
=== Method (${response.requestOptions.method}) ===
=== Data: ${response.data}
------------------------------------------------------------''');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    info('''
------------------------------------------------------------
=== Error (${err.response?.statusCode}) ===
=== Url: ${err.response?.realUri} ===
=== Method (${err.response?.requestOptions.method}) ===
=== Data: ${err.response?.data}
------------------------------------------------------------''');
    super.onError(err, handler);
  }
}
