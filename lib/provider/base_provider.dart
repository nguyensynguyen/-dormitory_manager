// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:dormitory_manager/contrains/api_url.dart';
//
// class BaseProvider {
//   // String _accessToken = AppBloc.singleton.token;
//   String _baseURL = ApiUrl.baseUrl;
//
//   // DioCacheManager _dioCacheManager;
//   Dio _dio;
//
//   // DioCacheManager get dioCacheManager {
//   //   _dioCacheManager ??= DioCacheManager(CacheConfig(baseUrl: _baseURL));
//   //   return _dioCacheManager;
//   // }
//
//   BaseProvider() {
//     _dio = Dio()
//       ..options = BaseOptions(
//           sendTimeout: 60 * 1000, // 1 minute,
//           receiveDataWhenStatusError: true,
//           connectTimeout: 15 * 1000, // 15 seconds
//           receiveTimeout: 18 * 1000 // 18 seconds
//       )
//       ..interceptors
//           .add(LogInterceptor(requestBody: true, responseBody: true))
//     /*..interceptors.add(dioCacheManager.interceptor)*/;
//   }
//
//   // Map<String, dynamic> getHeader() {
//   //   if (_accessToken?.isEmpty ?? true) return {};
//   //   return {
//   //     HttpHeaders.authorizationHeader: "Bearer $_accessToken",
//   //     HttpHeaders.contentTypeHeader: 'application/json'
//   //   };
//   // }
//
//   // ErrorResponse getErrorResponse(DioError e) {
//   //   if (e.error is SocketException) {
//   //     if ((e.error as SocketException).osError.errorCode == 7) {
//   //       return NoInternetResponse();
//   //     }
//   //   }
//   //   return ExceptionResponse()
//   //     ..error = {
//   //       'statusCode': e?.response?.statusCode ?? -1,
//   //       'statusMessage': e?.response?.statusMessage ?? ""
//   //     }
//   //     ..errorCode = e?.response?.statusMessage ?? "";
//   // }
//
//   // getRequestTimeoutResponse() {
//   //   return {
//   //     'success': false,
//   //     'errorCode': Errors.REQUEST_TIMEOUT,
//   //     'message': "Request timeout"
//   //   };
//   // }
//
//   // dynamic _checkExpiredToken(final response) {
//   //   try {
//   //     var mapResponse;
//   //     if (response.data is String) {
//   //       mapResponse = jsonDecode(response?.data ?? "");
//   //     } else {
//   //       mapResponse = response?.data ?? {};
//   //     }
//   //     if (mapResponse['success'] == false) {
//   //       if (mapResponse['errorCode'] == Errors.EXPIRED_ACCESS_TOKEN) {
//   //         // return ExpiredAccessToken();
//   //       }
//   //       return ErrorResponse(error: {
//   //         'success': mapResponse['success'],
//   //         'errorCode': mapResponse['errorCode']
//   //       })
//   //         ..errorCode = mapResponse['errorCode'];
//   //     }
//   //     return mapResponse;
//   //   } catch (_) {
//   //     return FormatSyntaxJsonError();
//   //   }
//   // }
//
//   static const Duration _durationMaxAgeCache = const Duration(minutes: 20);
//
//   // Options _buildOptions(Options options) {
//   //   return buildCacheOptions(_durationMaxAgeCache,
//   //       options: options, forceRefresh: true);
//   // }
//
//   Future<dynamic> get(
//       String uri, {
//         Map<String, dynamic> headers,
//         CancelToken cancelToken,
//         Duration duration,
//       }) async {
//     try {
//       if (headers != null) {
//         // headers..addAll(getHeader());
//       } else {
//         // headers = getHeader();
//       }
//       final response = await _dio.get(
//         "${_getUrl(uri)}",
//         // options: _buildOptions(Options(headers: headers)),
//         options: Options(headers: headers),
//         cancelToken: cancelToken,
//       );
//       return _checkExpiredToken(response);
//     } on TimeoutException {
//       return TimeOutResponse()..errorCode = Errors.REQUEST_TIMEOUT;
//     } catch (e) {
//       return getErrorResponse(e);
//     }
//   }
//
//   Future<dynamic> post(
//       String uri,
//       Map data, {
//         Map<String, dynamic> headers,
//         CancelToken cancelToken,
//         Duration duration,
//       }) async {
//     try {
//       if (headers != null) {
//         headers..addAll(getHeader());
//       } else {
//         headers = getHeader();
//       }
//       Response response = await _dio
//           .post(
//         "${_getUrl(uri)}",
//         data: jsonEncode(data),
//         options: Options(headers: headers),
//         cancelToken: cancelToken,
//       )
//           .timeout(const Duration(minutes: 1));
//       return _checkExpiredToken(response);
//     } on TimeoutException {
//       return TimeOutResponse()..errorCode = Errors.REQUEST_TIMEOUT;
//     } catch (e) {
//       return getErrorResponse(e);
//     }
//   }
//
//   Future<dynamic> postForm(String uri, Map<String, dynamic> data) async {
//     try {
//       FormData formData = new FormData.fromMap(data);
//       Response response = await _dio.post("${_getUrl(uri)}",
//           data: formData, options: Options(headers: getHeader()));
//       return response.data;
//     } catch (e) {
//       return getErrorResponse(e);
//     }
//   }
//
//   Future<dynamic> put(String uri, Map data) async {
//     try {
//       Response response = await _dio.put("${_getUrl(uri)}",
//           data: jsonEncode(data), options: Options(headers: getHeader()));
//       return response.data;
//     } catch (e) {
//       return getErrorResponse(e);
//     }
//   }
//
//   Future<dynamic> putForm(String uri, Map<String, dynamic> data) async {
//     try {
//       FormData formData = new FormData.fromMap(data);
//       Response response = await _dio.put("${_getUrl(uri)}",
//           data: formData, options: Options(headers: getHeader()));
//       return response.data;
//     } catch (e) {
//       return getErrorResponse(e);
//     }
//   }
//
//   Future<dynamic> delete(String uri, {Map<String, dynamic> data}) async {
//     try {
//       Response response = await _dio.delete(
//         "${_getUrl(uri)}",
//         data: data,
//         options: Options(
//           headers: getHeader(),
//         ),
//       );
//       return _checkExpiredToken(response);
//     } on TimeoutException {
//       return TimeOutResponse();
//     } catch (e) {
//       return getErrorResponse(e);
//     }
//   }
//
//   String _getUrl(uri) {
//     var url = uri;
//     if (!uri.startsWith('http')) {
//       url = "$_baseURL/$uri";
//     }
//     print(url);
//     return url;
//   }
// }
