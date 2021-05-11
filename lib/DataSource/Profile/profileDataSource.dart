
import 'package:dio/dio.dart';

abstract class ProfileDataSource{
  Future<Response> getProfile(Map<String,dynamic> data);
  Future<Response> updateProfile(Map<String,dynamic> data);
}