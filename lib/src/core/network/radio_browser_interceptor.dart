import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';

class RadioBrowserInterceptor extends Interceptor {
  static List<String> _servers = [];
  static final Random _random = Random();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_servers.isEmpty) {
      try {
        await _discoverServers();
      } on DioException {
        final error = DioException(
          requestOptions: options,
          error: 'Failed to discover API servers. Check network connection.',
        );
        return handler.reject(error);
      }
    }

    // Select a server and set it as the base URL for this request.
    final server = _servers[_random.nextInt(_servers.length)];
    options.baseUrl = 'https://$server';
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retries = (err.requestOptions.extra['retries'] as int?) ?? 0;
    if (retries < 1) {
      try {
        final response = await Dio().fetch<Map<String, dynamic>>(
          err.requestOptions..extra['retries'] = retries + 1,
        );
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }
    return handler.next(err);
  }

  static Future<void> _discoverServers() async {
    final addresses = await InternetAddress.lookup(
      'all.api.radio-browser.info',
    );
    _servers = addresses.map((addr) => addr.address).toList();
  }
}
