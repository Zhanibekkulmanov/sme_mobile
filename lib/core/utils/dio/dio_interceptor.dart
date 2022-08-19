import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:sme_mobile/core/injection_container.dart';
import 'dio_wrapper.dart';

class DioInterceptor extends Interceptor {
  final Box? tokens;
  final Dio? dio;

  DioInterceptor({
    this.tokens,
    this.dio,
  });

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = Hive.box('tokens').get('access');
    if (accessToken != null) {
      if (!options.path.contains('oauth/token') && !options.uri.toString().contains('auth/refresh')) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    return handler.next(options);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    // if(err.response!.statusCode == 401) {
    //   if(tokens!.containsKey('refresh')) {
    //     await refreshToken();
    //     return handler.resolve(await _retry(err.requestOptions));
    //   }
    // }
    return handler.next(err);
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
        method: requestOptions.method,
        headers: requestOptions.headers
    );

    return DioWrapper(sl(), sl()).request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options
    );
  }

  Future<void> refreshToken() async {
    String username1 = 'browser';
    String password = '';

    var basicAuth = 'Basic ${base64Encode(utf8.encode('$username1:$password'))}';

    final refreshToken = tokens!.get('refresh');
    Response response = await Dio().post(
      'https://workplace.kitapp.space/uaa/oauth/token',
      data: {
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      },
      options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"authorization": basicAuth}
      ),
    );
    log(response.toString());
    // if(response.statusCode == 200) {
    //   tokens!.put('access', response.data['access_token']);
    //   tokens!.put('refresh', response.data['refresh_token']);
    // } else {
    //   tokens!.clear();
    //   navigatorKey.currentState!.pushReplacementNamed('/auth');
    // }
  }
}
