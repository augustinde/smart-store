import 'package:dio/dio.dart';
import 'package:smart_store/services/jwtService.dart';

class RqInterceptors extends Interceptor {

  final JwtService jwtService = JwtService();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    if (options.path.contains('/auth/login') || options.path.contains('/auth/register') || options.path.contains('/auth/refresh')) {
      return super.onRequest(options, handler);
    }

    String? token = jwtService.getToken() as String?;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    print('Request sent to: ${options.uri}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Do something with response data
    print('Response received from: ${response.requestOptions.uri}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {

    if(err.response?.statusCode == 401) {
      RequestOptions options = err.requestOptions;
      try {
        String? refreshToken = jwtService.getRefreshToken() as String?;

        if(refreshToken != null) {
          var newToken = jwtService.refreshToken(refreshToken);

          if(newToken != null) {
            String newAccessToken = newToken['accessToken'];
            String newRefreshToken = newToken['refreshToken'];

            jwtService.setToken(newAccessToken);
            jwtService.setRefreshToken(newRefreshToken);
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            var retryResponse = Dio().fetch(options);
            return handler.resolve(retryResponse as Response);

          }
        }

      } catch (e) {
        print('Error refreshing token: $e');
      }
    }

    print('Error received from: ${err.requestOptions.uri}');
    return super.onError(err, handler);
  }
}