// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class JackApi {
  late String baseUrl;
  //  const baseUrl = "";
  late Dio _baseDio;

  late VoidCallback logoutFunc;

  JackApi(
      {required this.baseUrl,
      required this.logoutFunc,
      int? connectTimeout,
      int? receiveTimeout}) {
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
    _baseDio.options.headers['Content-Type'] = "application/json";
    if (basePath != null) _baseDio.options.baseUrl = basePath;
    if (token != null) {
      _baseDio.options.headers['Authorization'] = "Bearer $token";
    }
    try {
      final Response response = await _baseDio.get(
        path,
        onReceiveProgress: onReceiveProgress,
      );
      debugPrint(const JsonEncoder().convert(response.data));
      final responseData = response.data as Map<String, dynamic>;
      if (!responseData['authorized']) {
        logoutFunc();
      }
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
    _baseDio.options.headers['Content-Type'] = "application/json";
    if (basePath != null) _baseDio.options.baseUrl = basePath;
    if (token != null) {
      _baseDio.options.headers['Authorization'] = "Bearer $token";
    }
    try {
      final Response response = await _baseDio.post(
        path,
        data: data,
        onSendProgress: onSendProgress,
      );
      debugPrint(const JsonEncoder().convert(response.data));
      final responseData = response.data as Map<String, dynamic>;
      if (!responseData['authorized']) {
        logoutFunc();
      }
      return responseData;
    } on DioError catch (e) {
      print(e);
      return e;
    }
  }
}
