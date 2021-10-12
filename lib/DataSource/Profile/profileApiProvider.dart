
import 'dart:convert';

import 'package:dio/dio.dart';

import '../networkProvider.dart';
import 'package:crypto/crypto.dart' as crypto;

class ProfileApiProvider{

  final String _GET_PROFILE = "/getProfile";
  final String _UPDATE_PROFILE = "/updateProfile";

  NetworkProvider networkProvider=NetworkProvider();

  Future<Response> getProfile(Map<String,dynamic> data){

    String  jsonData= jsonEncode(data);
    print("data"+jsonData);

    var sign=generateMd5(jsonData).toUpperCase();
    var dio = networkProvider.dioWithAuth(data["token"]);
    return dio.post(_GET_PROFILE+"?sign=$sign", data: data);
  }

  Future<Response> updateProfile(Map<String,dynamic> data){

    String  jsonData= jsonEncode(data);
    print("data"+jsonData);

    var sign=generateMd5(jsonData).toUpperCase();
    var dio = networkProvider.dioWithAuth(data["token"]);
    return networkProvider.dio.post(_UPDATE_PROFILE+"?sign=$sign", data: data,);
  }
  String generateMd5(String input) {
    return crypto.md5.convert(utf8.encode(input)).toString();
  }
}