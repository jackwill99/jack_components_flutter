// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class JackApi {
  late String baseUrl;
  //  const baseUrl = "";
  late Dio _baseDio;

  JackApi({required this.baseUrl, int? connectTimeout, int? receiveTimeout}) {
    _baseDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
      ),
    );
  }

  Future getDio({
    required String path,
    String? token,
    String? basePath,
    VoidCallback Function(int, int)? onReceiveProgress,
  }) async {
    if (basePath != null) _baseDio.options.baseUrl = basePath;
    if (token != null) {
      _baseDio.options.headers['Content-Type'] = "application/json";
      _baseDio.options.headers['Authorization'] = "Bearer $token";
    }
    try {
      final Response<Map> response = await _baseDio.get(
        path,
        onReceiveProgress: onReceiveProgress,
      );
      final responseData = response.data as Map<String, dynamic>;
      return responseData;
    } on DioError catch (e) {
      return e;
    }
  }

  Future postDio({
    required String path,
    required data,
    String? token,
    String? basePath,
    void Function(int, int)? onSendProgress,
  }) async {
    if (basePath != null) _baseDio.options.baseUrl = basePath;
    if (token != null) {
      _baseDio.options.headers['Content-Type'] = "application/json";
      _baseDio.options.headers['Authorization'] = "Bearer $token";
    }
    try {
      final Response<Map> response = await _baseDio.post(
        path,
        data: data,
        onSendProgress: onSendProgress,
      );
      final responseData = response.data as Map<String, dynamic>;
      return responseData;
    } on DioError catch (e) {
      print(e);
      return e;
    }
  }
}
