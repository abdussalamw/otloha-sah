import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart' as local;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ntp/ntp.dart';
import 'package:otloha_sah_flutter/data_source/remote/firebase_service.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/onboard_page.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retry_queue_manager/retry_queue_manager.dart';

import 'refresh_token_model.dart';
import '../utils/services/navigator_service.dart';
import '../../data_source/user_services_data.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import '../error/exceptions.dart';
import '../utils/constant/constants.dart';
import 'network_info.dart';

Future checkNetwork({RequestOptions? requestOptions}) async {
  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkConnectionException();
    }
  } catch (e) {
    if (e is NetworkConnectionException) rethrow;
  }
  return true;
}

enum DioTypes { authRequired, noAuthRequired }

class ApiBaseHelper implements ApiQueueHandler {
  ApiBaseHelper() {
    opts = BaseOptions(
        baseUrl: Constants.baseUrl,
        responseType: ResponseType.json,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': local.Get.locale?.languageCode,
        });
    dio = createDio();
    authDio = createDio();
    baseAPI = addInterceptors(dio);
    authBaseAPI = addAuthInterceptors(authDio);
  }

  late BaseOptions opts;

  Dio createDio() {
    var dio = Dio(opts);
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    return dio;
  }

  static Dio addAuthInterceptors(Dio dio) {
    return dio
      ..interceptors.addAll([
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) {
            try {
              checkNetwork(requestOptions: options);
            } catch (e) {
              handler.reject(DioException(requestOptions: options));
            }
            return handler.next(options);
          },
          onError: (DioException e, handler) async {
            log(e.requestOptions.path);
            if (e.response != null && e.response!.statusCode == 401 && e.requestOptions.path != '${Constants.baseUrl}/api/v2/token/') {
              // Removed forced navigation to OnBoardPage.routeName
            }
            return handler.next(e);
          },
        ),
        PrettyDioLogger(),
      ]);
  }

  Dio addInterceptors(Dio dio) {
    return dio
      ..interceptors.addAll([
        InterceptorsWrapper(
          onRequest: (RequestOptions options, handler) async {
            try {
              await checkNetwork(requestOptions: options);
            } catch (e) {
              return handler.reject(DioException(requestOptions: options));
            }

            String currentToken = UserDataServices.instance.getToken ?? '';
            String? refreshToken = UserDataServices.instance.getTokenRefresh;

            if (refreshToken == null) {
              await FirebaseService.instance.deleteToken();
              UserDataServices.instance.signOut();
            } else {
              final refreshExpiryDate =
                  Jwt.getExpiryDate(refreshToken)!.difference(DateTime.now());
              if (refreshExpiryDate.inSeconds < 60) {
                await FirebaseService.instance.deleteToken();
                UserDataServices.instance.signOut();
              }
            }

            if (currentToken.isEmpty) {
              return handler.reject(
                  DioException(requestOptions: options, error: AuthError));
            } else {
              final expiryDate = Jwt.getExpiryDate(currentToken)!
                  .difference(DateTime.now())
                  .inSeconds;
              if (expiryDate < 60) {
                String refreshToken =
                    UserDataServices.instance.getTokenRefresh ?? '';

                var response = await authBaseAPI.post('/api/v2/token/refresh/',
                    data: {'refresh': refreshToken});

                RefreshTokenModel? t =
                    RefreshTokenModel.fromJson(response.data);
                await UserDataServices.instance.updateUser(t);
              }
            }

            String accessToken = UserDataServices.instance.getToken ?? '';
            if (accessToken.isNotEmpty) {
              options.headers[HttpHeaders.authorizationHeader] =
                  'Bearer $accessToken';
            }
            return handler.next(options);
          },
          onError: (DioException e, handler) async {
            return handler.next(e);
          },
        ),
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      ]);
  }

  late Dio dio;
  late Dio authDio;

  late Dio baseAPI;
  late Dio authBaseAPI;

  baseDio(DioTypes dioTypes) {
    if (dioTypes == DioTypes.authRequired) {
      return baseAPI;
    }
    return authBaseAPI;
  }

  Future<Response?> getHTTP(
    String url, {
    Map<String, dynamic>? queryParameters,
    required DioTypes dioTypes,
  }) async {
    Response? response;
    try {
      response =
          await baseDio(dioTypes).get(url, queryParameters: queryParameters);

      return response;
    } on DioException catch (e) {
      ExceptionHandling.handleDioExceprion(e);
    }

    return response;
  }

  Future<Response> postHTTP(
    String url,
    dynamic data,
    DioTypes dioType,
  ) async {
    try {
      print(data);
      Response response = await baseDio(dioType).post(url, data: data);
      return response;
    } on DioException catch (e) {
      throw ExceptionHandling.handleDioExceprion(e);
    }
  }

  Future<Response> postPhotoHTTP(
    String url,
    dynamic data,
    DioTypes dio,
  ) async {
    try {
      print(data);

      FormData formData = FormData.fromMap(data);
      Response response = await baseDio(dio).post(url, data: formData);
      return response;
    } on DioException catch (e) {
      print(e);
      ExceptionHandling.handleDioExceprion(e);
      rethrow;
    }
  }

  Future<Response> putHTTP(
    String url,
    dynamic data,
    DioTypes dio,
  ) async {
    try {
      Response response = await baseDio(dio).put(url, data: data);
      return response;
    } on DioException catch (e) {
      ExceptionHandling.handleDioExceprion(e);
      rethrow;
    }
  }

  Future<Response> patchHTTP(
    String url,
    dynamic data,
    DioTypes dioType,
  ) async {
    try {
      Response response = await baseDio(dioType).patch(url, data: data);
      return response;
    } on DioException catch (e) {
      ExceptionHandling.handleDioExceprion(e);
      rethrow;
    }
  }

  Future<Response> deleteHTTP(String url, DioTypes dioType) async {
    try {
      Response response = await baseDio(dioType).delete(url);

      return response;
    } on DioException catch (e) {
      ExceptionHandling.handleDioExceprion(e);
      rethrow;
    }
  }

  @override
  Future<Response> sendRequest(
    String url,
    data,
  ) async {
    FormData formData = FormData.fromMap(data);
    Response response =
        await baseDio(DioTypes.authRequired).post(url, data: formData);
    return response;
  }
}
