import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_by_phonenumber/models/send_code_model.dart';
import 'package:login_by_phonenumber/models/send_phone_model.dart';

class AuthRepo {
  final Dio dio;
  AuthRepo({required this.dio});

  String basicAuth = 'Basic ${base64.encode(
    utf8.encode('testEmil12:11223344'),
  )}';

  final storage = const FlutterSecureStorage();

  Future<SendPhoneModel> sendPhone({
    required String phoneNumber,
  }) async {
    final response = await dio.get(
      'generateUserId/test?',
      queryParameters: {'msisdn': phoneNumber},
      options: Options(
        headers: {'authorization': basicAuth},
      ),
    );
    final result = SendPhoneModel.fromJson(response.data);
    await storage.write(key: 'token', value: result.object);

    return result;
  }

  Future<SendCodeModel> sendCode({required String code}) async {
    final response = await dio.get(
      'checkCode/test?',
      queryParameters: {
        'code': code,
        'uuId': '${await storage.read(key: 'token')}',
      },
      options: Options(
        headers: {'authorization': basicAuth},
      ),
    );

    return SendCodeModel.fromJson(response.data);
  }
}
