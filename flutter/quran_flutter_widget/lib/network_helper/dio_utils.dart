import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:quran_widget_flutter/helper/q.dart';
import 'package:quran_widget_flutter/helper/utils.dart';
import 'package:quran_widget_flutter/network_helper/network_exception.dart';
import 'package:quran_widget_flutter/plugin_auth/quran_widget_init.dart';

import 'apis.dart';

class DioUtils {
  static Dio? dio;
  static Options? authOptions;
  static CacheOptions cacheOptions =
      CacheOptions(store: MemCacheStore(), policy: CachePolicy.noCache);

  static const String requestGET = 'get';
  static const String requestPOST = 'post';
  static const String requestPUT = 'put';
  static const String requestDELETE = 'delete';
  static const String requestDownload = 'download';

  static void initDio() {
    if (dio == null) {
      dio = Dio();
      dio?.interceptors.add(DioCacheInterceptor(options: cacheOptions));
      dio?.interceptors.add(InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.queryParameters['appname'] = Q.appName;
        options.queryParameters['version'] = Q.versionName;
        var url = options.path;

        print('$url : REQUEST : METHOD : ${options.method}');
        print('$url : REQUEST : HEADERS : ${options.headers}');
        print('$url : REQUEST : QPARAMS : ${options.queryParameters}');

        return handler.next(options);
      }, onResponse:
          (Response response, ResponseInterceptorHandler handler) async {
        var url = response.realUri.path;
        print('$url : RESPONSE : ${response.statusCode}');
        print('$url : RESPONSE : ${response.statusMessage}');
        print("$url : RESPONSE : ${response.data ?? "null"}");

        return handler.next(response);
      }, onError: (DioError e, ErrorInterceptorHandler handler) async {
        var url = '${e.response?.realUri.path}';
        print('$url : ERROR : ${e.error}');
        print('$url : ERROR : ${e.message}');
        print('$url : ERROR : ${e.response?.data}');
        print('$url : ERROR : ${e.response?.statusCode}');
        print('$url : ERROR : ${e.response?.statusMessage}');

        return handler.next(e);
      }));
    }
    authOptions = Options(headers: {
      'authorization': Apis.authorization,
    });
  }

  static Dio instance() {
    initDio();
    return dio!;
  }

  static Future<Response?>? request(
    String requestType,
    String url, {
    String? contentType,
    String? savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic body,
    Options? requestOption,
    bool isToCache = true,
    bool forceRefresh = true,
    int daysToCache = 30,
    int hoursToCache = 0,
    Function(int, int)? onDownloadProgress,
  }) async {
    await isNetwordConnected();

    initDio();

    if (Apis.authorization.isEmpty) {
      authOptions?.headers = {};
    }

    authOptions?.headers?['X-App-Version'] = Q.versionName;
    authOptions?.headers?['X-Os-Version'] = Platform.operatingSystemVersion;
    authOptions?.headers?['X-Platform'] = Platform.operatingSystem;
    // authOptions?.headers?['Authorization'] = Apis.authorization;

    if (headers != null && headers.isNotEmpty) {
      for (var key in headers.keys) {
        authOptions?.headers?[key] = headers[key];
      }
    }

    if (contentType != null) {
      authOptions?.headers?[Headers.contentTypeHeader] = contentType;
    }

    print('Apis.TOKEN_VALUE ${Apis.authorization}');
    print('$url : headers : ${jsonEncode(authOptions?.headers)}');
    if (body != null) Utils.printLongLine('$url : body : ${body.toString()}');

    var options = isToCache
        ? cacheOptions
            .copyWith(
              policy: forceRefresh
                  ? CachePolicy.refreshForceCache
                  : CachePolicy.forceCache,
              maxStale:
                  Nullable(Duration(days: daysToCache, hours: hoursToCache)),
            )
            .toOptions()
        : authOptions;

    if (isToCache) {
      options?.headers ??= {};
      options?.headers?.addAll(authOptions!.headers!);
    }

    Response? response;

    try {
      switch (requestType) {
        case requestGET:
          response = await dio!.get(
            url,
            queryParameters: queryParameters,
            options: options,
            onReceiveProgress: onDownloadProgress,
          );
          break;
        case requestPOST:
          response = await dio!.post(
            url,
            options: requestOption ?? options,
            queryParameters: queryParameters,
            data: body,
            onSendProgress: (int sent, int total) =>
                print('$url : sent : $sent/$total'),
            onReceiveProgress: (recieved, total) {
              onDownloadProgress?.call(recieved, total);
              print('$url : recieved : $recieved/$total');
            },
          );
          break;
        case requestPUT:
          response = await dio!.put(
            url,
            options: options,
            queryParameters: queryParameters,
            data: body,
            onSendProgress: (int sent, int total) =>
                print('$url : sent : $sent/$total'),
            onReceiveProgress: (recieved, total) =>
                print('$url : recieved : $recieved/$total'),
          );
          break;
        case requestDELETE:
          response = await dio!.delete(
            url,
            options: options,
            queryParameters: queryParameters,
            data: body,
          );
          break;
        case requestDownload:
          response = await dio!.download(
            url,
            savePath,
            options: options,
            queryParameters: queryParameters,
            data: body,
            onReceiveProgress: (recieved, total) {
              onDownloadProgress?.call(recieved, total);
              print('$url : recieved : $recieved/$total');
            },
          );
          break;
      }
    } catch (e) {
      var error = e as DioError;
      response = error.response;
    }

    // printResponse(url, response);

    if (response != null && response.statusCode == 401) {
      await QuranWidgetInit.init(
          clientId: Apis.clientId, clientSecret: Apis.clientSecret);
      return request(
        requestType,
        url,
        contentType: contentType,
        queryParameters: queryParameters,
        headers: headers,
        body: body,
        requestOption: requestOption,
        isToCache: isToCache,
        forceRefresh: forceRefresh,
        daysToCache: daysToCache,
        hoursToCache: hoursToCache,
      );
    }

    print('uri of api ${response?.realUri}');

    return response;
  }

  // static printResponse(String url, Response? response) {
  //   if (response != null) {
  //     print('$url : ${response.statusCode} ${response.data}');
  //   } else {
  //     print('$url : response == null');
  //   }
  // }

  static clearCache() {
    dio?.interceptors.clear();
  }
}
