import 'package:dio/dio.dart';

import 'package:study_mama_flutter/DataSource/Login/loginApiProvider.dart';

import 'loginDataSource.dart';

class LoginRemoteRepository implements LoginDataSource {

  LoginApiProvider _loginApiProvider = LoginApiProvider();

  Future<Response> register(Map<String, dynamic> data) async {
    Response response = await _loginApiProvider.register(data);
    return response;
  }

  Future<Response> login(Map<String, dynamic> data) async {
    Response response = await _loginApiProvider.login(data);
    return response;
  }

}
