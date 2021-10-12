
import 'dart:convert';

import 'package:dio/dio.dart';

import '../networkProvider.dart';
import 'package:crypto/crypto.dart' as crypto;

class LoginApiProvider{

  final String _LOGIN_REGISTER = "/register";
  final String _LOGIN_AUTHENTICATE = "/authenticate";
  final String _LOGIN_OTP_QRSTRING = "/generateQRcodeString";

  final String _OTP_VERIFY = "/verifyOTP";

  NetworkProvider networkProvider=NetworkProvider();

  Future<Response> register(Map<String,dynamic> data){
    var sign=generateMd5(data.toString()).toUpperCase();
    print("sign data $sign");
    return networkProvider.dio.post(_LOGIN_REGISTER+"?sign=$sign", data: data);
  }

  Future<Response> login(Map<String,dynamic> data){
    String  jsonData= jsonEncode(data);
    print("data"+jsonData);

    var sign=generateMd5(jsonData).toUpperCase();
    print("sign data $sign");
    return networkProvider.dio.post(_LOGIN_AUTHENTICATE+"?sign=$sign", data: data,);
  }
  Future<Response> otpQRString(Map<String,dynamic> data){
    String  jsonData= jsonEncode(data).toUpperCase();
    print("data"+jsonData);

    var sign=generateMd5(jsonData);
    print("sign data $sign");
    return networkProvider.dio.get(_LOGIN_OTP_QRSTRING+"?sign=$sign", queryParameters: data);
  }
  Future<Response> verifyOTP(Map<String,dynamic> data){
    String  jsonData= jsonEncode(data);
    print("data"+jsonData);

    var sign=generateMd5(jsonData).toUpperCase();
    print("sign data $sign");
    return networkProvider.dio.get(_OTP_VERIFY+"?sign=$sign", queryParameters: data);
  }

  String generateMd5(String input) {
    return crypto.md5.convert(utf8.encode(input)).toString();
  }
}