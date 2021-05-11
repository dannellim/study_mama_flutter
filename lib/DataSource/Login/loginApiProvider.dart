
import 'package:dio/dio.dart';

import '../networkProvider.dart';

class LoginApiProvider{

  final String _LOGIN_REGISTER = "/register";
  final String _LOGIN_AUTHENTICATE = "/authenticate";

  NetworkProvider networkProvider=NetworkProvider();

  Future<Response> register(Map<String,dynamic> data){
    return networkProvider.dio.post(_LOGIN_REGISTER, data: data);
  }

  Future<Response> login(Map<String,dynamic> data){
    return networkProvider.dio.post(_LOGIN_AUTHENTICATE, data: data);
  }

}