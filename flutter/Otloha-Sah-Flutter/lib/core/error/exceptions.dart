import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization.dart';
import '../utils/constant/utils.dart';
import '../utils/themes/color.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:quran_widget_flutter/network_helper/network_exception.dart'
    as package;

import 'package:otloha_sah_flutter/core/error/failure.dart';
import 'package:slack_logger/slack_logger.dart';

class NetworkConnectionException implements Exception {}

class InvalidData implements Exception {
  final Map<String, dynamic>? _errors;
  String? msg;

  InvalidData(this._errors, this.msg);

  Map<String, dynamic>? get errors => _errors;
}

class ServerError implements Exception {}

class EmptyListException implements Exception {}

class NotFound implements Exception {}

class AuthError implements Exception {
  String error;
  AuthError({
    required this.error,
  });

  @override
  String toString() => 'AuthError(error: $error)';
}

class RefreshTokenError implements Exception {}

class CacheError implements Exception {}

class SomeThingWentWrong implements Exception {}

class ExceptionHandling {
  static handleDioExceprion(DioException e) {
    if (e.type == DioExceptionType.unknown) {
      throw NetworkConnectionException();
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response!.statusCode! == 401) {
        throw AuthError(error: '401 Error ${e.message}');
      }
      if (e.response!.statusCode! == 400 || e.response!.statusCode! == 422) {
        throw InvalidData(e.response?.data, e.response?.data['message']);
      }
      if (e.response!.statusCode! == 403) {
        throw InvalidData(e.response?.data,
            e.response?.data['message'] ?? e.response!.data['detail']);
      }
      if (e.response!.statusCode! == 404) {
        throw NotFound();
      }
      if (e.response!.statusCode! >= 500) {
        try {
          final SlackLogger _slack = SlackLogger(
              webhookUrl:
                  dotenv.env['SLACK_WEBHOOK_URL'] ?? '');
                  
          Map<String, dynamic>? data = e.response?.data is Map<String, dynamic> ? e.response?.data : null;
          
          _slack.sendMarkdownAsAttachment(
              markdownMessageList: [
                '*Request info*',
                '*Path*: `${e.requestOptions.path}`',
                '*Method*: `${data?['request_info']?['method'] ?? 'Unknown'}`',
                '*data*',
                '```${data?['request_info']?['data'] ?? 'Unknown'}```',
                '*Response*',
                '*Traceback*',
                '```${data?['trace_info']?.join('') ?? 'Unknown'}```',
              ], color: 'red',);
        } catch (err) {
          debugPrint('SlackLogger error: $err');
        }
        throw ServerError();
      }
      if (List.generate(100, (index) => 300 + index)
          .contains(e.response!.statusCode ?? 0)) {
        throw NetworkConnectionException();
      } else {
        throw SomeThingWentWrong();
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      throw TimeoutException('time out');
    }

    throw SomeThingWentWrong();
  }

  static handleExceptionToFaliure(Exception e) {
    if (e is NetworkConnectionException) {
      return NetworkFailure();
    } else if (e is InvalidData) {
      return InvalidDataFailure(e.errors!);
    } else if (e is ServerError) {
      return ServerFailure();
    } else if (e is TimeoutException) {
      return NetworkFailure();
    } else if (e is AuthError) {
      return AuthFailure();
    }

    return SomeThingWentWrongFailure();
  }

  static Future<Response?> hanleToastException(
      Function() function, String doneMessage, bool isShow) async {
    try {
      var res = await function();

      if (isShow) {
        Fluttertoast.showToast(
          msg: doneMessage,
          backgroundColor: AppColor.lightBlue,
          timeInSecForIosWeb: 4,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: res.data['message'] ?? doneMessage,
          backgroundColor: AppColor.lightBlue,
          timeInSecForIosWeb: 4,
          gravity: ToastGravity.BOTTOM,
        );
      }
      return res;
    } on InvalidData catch (e) {
      Fluttertoast.showToast(
        msg: e.msg ??
            (e.errors!.containsKey(e.errors!.keys.first)
                ? e.errors![e.errors!.keys.first].toString().substring(
                    1, e.errors![e.errors!.keys.first].toString().length - 1)
                : doneMessage),
        gravity: ToastGravity.BOTTOM,
      );
    } on NetworkConnectionException catch (_) {
      Fluttertoast.showToast(
        msg: translate('Network Error check your Internet'),
        gravity: ToastGravity.BOTTOM,
      );
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(
        msg: 'Time Out',
        gravity: ToastGravity.BOTTOM,
      );
    } on ServerError catch (_) {
      Fluttertoast.showToast(
        msg: 'Server Error',
        gravity: ToastGravity.BOTTOM,
      );
    } on SomeThingWentWrong catch (_) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong',
        gravity: ToastGravity.BOTTOM,
      );
    }
    return null;
  }

  static hanleToastFromException(Exception exception,
      {bool fromPackage = false}) {
    if (fromPackage) {
      exception = convertException(exception);
    }
    if (exception is NetworkConnectionException) {
      Fluttertoast.showToast(
        msg: 'Network Error check your Internet Exception',
        gravity: ToastGravity.BOTTOM,
      );
    }
    if (exception is NetworkConnectionException ||
        exception is package.NetworkConnectionException ||
        exception is package.NetworkConnectionExceptionOnTocken) {
      Fluttertoast.showToast(
        msg: 'Network Error check your Internet Exception',
        gravity: ToastGravity.BOTTOM,
      );
    } else if (exception is InvalidData) {
      Fluttertoast.showToast(
        msg: exception.msg ?? 'Error',
        gravity: ToastGravity.BOTTOM,
      );
    } else if (exception is SomeThingWentWrong) {
      Fluttertoast.showToast(
        msg: 'Something went Wrong',
        gravity: ToastGravity.BOTTOM,
      );
    } else if (exception is NotFound) {
      Fluttertoast.showToast(
        msg: tr('Not Found'),
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: exception.toString(),
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  static Exception convertException(Exception e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.unknown) {
        return NetworkConnectionException();
      } else if (e.type == DioExceptionType.badResponse) {
        if (e.response!.statusCode! == 401) {
          return AuthError(error: '401 Error ${e.message}');
        }
        if (e.response!.statusCode! == 400 || e.response!.statusCode! == 422) {
          return InvalidData(e.response?.data, e.response?.data['message']);
        }
        if (e.response!.statusCode! == 403) {
          return InvalidData(e.response?.data, e.response?.data['message']);
        }
        if (e.response!.statusCode! == 404) {
          return NotFound();
        }
        if (e.response!.statusCode! >= 500) {
          return ServerError();
        }
        if (List.generate(100, (index) => 300 + index)
            .contains(e.response!.statusCode ?? 0)) {
          return NetworkConnectionException();
        } else {
          return SomeThingWentWrong();
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        return TimeoutException('time out');
      }

      return SomeThingWentWrong();
    }
    return e;
  }
}
