import 'package:dio/dio.dart';
import 'package:study_mama_flutter/DataSource/Profile/profileApiProvider.dart';
import 'package:study_mama_flutter/DataSource/Profile/profileDataSource.dart';


class ProfileRemoteRepository implements ProfileDataSource {

  ProfileApiProvider _profileApiProvider = ProfileApiProvider();

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    Response response = await _profileApiProvider.updateProfile(data);
    return response;
  }

  Future<Response> getProfile(Map<String, dynamic> data) async {
    Response response = await _profileApiProvider.getProfile(data);
    return response;
  }
}
