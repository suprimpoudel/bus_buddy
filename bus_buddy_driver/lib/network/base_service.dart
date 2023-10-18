import 'dart:convert';
import 'dart:io';

import 'package:bus_buddy_driver/features/model/error.dart';
import 'package:bus_buddy_driver/utils/constants/api_constants.dart';
import 'package:bus_buddy_driver/utils/constants/error_constants.dart';
import 'package:bus_buddy_driver/utils/constants/preference_constants.dart';
import 'package:bus_buddy_driver/utils/helper/custom_exception.dart';
import 'package:bus_buddy_driver/utils/helper/logger.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseService {
  Future<Dio> getDioObject() async {
    var dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
    ));
    dio.interceptors.add(LoggingInterceptor());
    return dio;
  }

  String _getParseErrorMessage(dynamic jsonResponse) {
    try {
      if (jsonResponse is String) {
        return jsonResponse;
      } else if (jsonResponse is Map<String, dynamic>) {
        var error = Error.fromJson(jsonResponse);
        // return error.message ?? defaultError;
        if (error.errors?.isNotEmpty == true) {
          var errorToReturn = "";
          error.errors?.forEach((element) {
            errorToReturn = "$errorToReturn${element.message}\n";
          });
          return errorToReturn.trim();
        } else {
          return error.message ?? defaultError;
        }
      } else {
        return defaultError;
      }
    } catch (e) {
      return defaultError;
    }
  }

  Future<Map<String, dynamic>> getRequest(
      {required String url,
      int? duration,
      Map<String, dynamic>? queryParams}) async {
    try {
      Map<String, String> header = {
        "Content-Type": "application/json; charset=utf-8",
        "Accept": "application/json",
      };
      var sharedPrefs = await SharedPreferences.getInstance();
      var accessToken = sharedPrefs.getString(token) ?? "";
      header["Authorization"] = "Bearer $accessToken";
      var dioObject = await getDioObject();

      var response = await dioObject.get(url,
          options: Options(
              headers: header,
              receiveTimeout: Duration(seconds: duration ?? 20),
              sendTimeout: Duration(seconds: duration ?? 20),
              responseType: ResponseType.json),
          queryParameters: queryParams);
      var result = response.data;
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception(defaultError);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception(e.message);
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        var result = e.response?.data;
        if (result is Map<String, dynamic>) {
          throw Exception(_getParseErrorMessage(result));
        } else {
          throw Exception(defaultError);
        }
      }
    } on SocketException catch (_) {
      throw Exception(connectionIssueError);
    } on IOException catch (_) {
      throw Exception(connectionIssueError);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postRequest(
      {required String url,
      int? duration,
      bool? isAuthorization,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParams}) async {
    try {
      Map<String, String> header = {
        "Content-Type": "application/json; charset=utf-8",
        "Accept": "application/json",
      };
      var sharedPrefs = await SharedPreferences.getInstance();
      var accessToken = sharedPrefs.getString(token) ?? "";
      if (isAuthorization != true) {
        header["Authorization"] = "Bearer $accessToken";
      }
      var dioObject = await getDioObject();

      var response = await dioObject.post(url,
          options: Options(
              headers: header,
              receiveTimeout: Duration(seconds: duration ?? 20),
              sendTimeout: Duration(seconds: duration ?? 20),
              responseType: ResponseType.json),
          queryParameters: queryParams,
          data: body);
      var result = response.data;
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception(defaultError);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception(e.message);
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        var result = e.response?.data;
        if (result is Map<String, dynamic>) {
          throw Exception(_getParseErrorMessage(result));
        } else {
          throw Exception(defaultError);
        }
      }
    } on SocketException catch (_) {
      throw Exception(connectionIssueError);
    } on IOException catch (_) {
      throw Exception(connectionIssueError);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> putRequest(
      {required String url,
      int? duration,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParams}) async {
    try {
      Map<String, String> header = {
        "Content-Type": "application/json; charset=utf-8",
        "Accept": "application/json",
      };
      var sharedPrefs = await SharedPreferences.getInstance();
      var accessToken = sharedPrefs.getString(token) ?? "";
      header["Authorization"] = "Bearer $accessToken";

      var dioObject = await getDioObject();

      var response = await dioObject.put(url,
          options: Options(
              headers: header,
              receiveTimeout: Duration(seconds: duration ?? 20),
              sendTimeout: Duration(seconds: duration ?? 20),
              responseType: ResponseType.json),
          queryParameters: queryParams,
          data: body);
      var result = response.data;
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception(defaultError);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception(noInternetError);
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        var result = e.response?.data;
        if (result is Map<String, dynamic>) {
          throw Exception(_getParseErrorMessage(result));
        } else {
          throw Exception(defaultError);
        }
      }
    } on SocketException catch (_) {
      throw Exception(connectionIssueError);
    } on IOException catch (_) {
      throw Exception(connectionIssueError);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteRequest(
      {required String url, int? duration}) async {
    try {
      Map<String, String> header = {
        "Content-Type": "application/json; charset=utf-8",
        "Accept": "application/json",
      };
      var sharedPrefs = await SharedPreferences.getInstance();
      var accessToken = sharedPrefs.getString(token) ?? "";
      header["Authorization"] = "Bearer $accessToken";
      var dioObject = await getDioObject();

      var response = await dioObject.delete(
        url,
        options: Options(
            headers: header,
            receiveTimeout: Duration(seconds: duration ?? 20),
            sendTimeout: Duration(seconds: duration ?? 20),
            responseType: ResponseType.json),
      );
      var result = response.data;
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception(defaultError);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception(noInternetError);
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        var result = e.response?.data;
        if (result is Map<String, dynamic>) {
          throw Exception(_getParseErrorMessage(result));
        } else {
          throw Exception(defaultError);
        }
      }
    } on SocketException catch (_) {
      throw Exception(connectionIssueError);
    } on IOException catch (_) {
      throw Exception(connectionIssueError);
    } on Exception catch (_) {
      rethrow;
    }
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logging.log('Request: ${options.method} ${options.uri}', isInfo: true);
    Logging.log('Headers: ${options.headers}', isInfo: true);
    Logging.log('Body: ${jsonEncode(options.data)}', isInfo: true);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logging.log(
        'Response: ${response.statusCode} ${response.requestOptions.uri}',
        isInfo: true);
    Logging.log('Headers: ${response.headers}', isInfo: true);
    Logging.log('Body: ${jsonEncode(response.data)}', isInfo: true);

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logging.log('Error: ${err.message}');
    Logging.log('Error: ${err.error?.toString()}');
    Logging.log('Error: ${err.response?.data}');
    super.onError(err, handler);
  }
}
