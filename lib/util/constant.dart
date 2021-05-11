

import 'package:rxdart/rxdart.dart';
import 'package:study_mama_flutter/Model/getProfileModel.dart';
import 'package:study_mama_flutter/Model/loginModel.dart';

late GetProfileResponse getProfileResponse;
 LoginRequest loginRequest=LoginRequest();
 BehaviorSubject<LoginRequest> loginData=BehaviorSubject();
String token="";
String accountID="3";
String loginAccName="";