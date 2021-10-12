
import 'package:dio/dio.dart';

abstract class LoginDataSource{
  Future<Response> register(Map<String,dynamic> data);
  Future<Response> login(Map<String,dynamic> data);
}