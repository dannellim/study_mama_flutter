
import 'package:dio/dio.dart';

import '../networkProvider.dart';

class ProfileApiProvider{

  final String _GET_PROFILE = "/getProfile";
  final String _UPDATE_PROFILE = "/updateProfile";

  NetworkProvider networkProvider=NetworkProvider();

  Future<Response> getProfile(Map<String,dynamic> data){
    var dio = networkProvider.dioWithAuth(data["token"]);
    return dio.post(_GET_PROFILE, data: data);
  }

  Future<Response> updateProfile(Map<String,dynamic> data){
    return networkProvider.dio.post(_UPDATE_PROFILE, data: data,);
  }

}