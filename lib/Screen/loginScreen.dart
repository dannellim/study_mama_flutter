import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:study_mama_flutter/DataSource/Login/loginRemoteRepository.dart';
import 'package:study_mama_flutter/Model/loginModel.dart';
import 'package:study_mama_flutter/Screen/profileDialog.dart';
import 'package:study_mama_flutter/util/color.dart';
import 'package:study_mama_flutter/util/constant.dart';
import 'package:study_mama_flutter/util/widget.dart';
import 'package:toast/toast.dart';
class Login extends StatefulWidget {
  @override
  _GetLoginState createState() => _GetLoginState();
}

class _GetLoginState extends State<Login> {
  bool showLoadingBar = false;
  final key = new GlobalKey<ScaffoldState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  LoginRemoteRepository loginRemoteRepository = LoginRemoteRepository();

  BehaviorSubject<bool> isSignUp_BS = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> isVerify = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> emailVerify = BehaviorSubject.seeded(false);
  BehaviorSubject<String> qrSTring = BehaviorSubject.seeded("");
  BehaviorSubject<bool> userDisable = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> isUser_BS = BehaviorSubject.seeded(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController.text = "admin";
    passwordController.text = "admin";

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isSignUp_BS.close();
    isUser_BS.close();
  }

  @override
  Widget build(BuildContext context) {
    double spacer = MediaQuery.of(context).size.height / 20;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: key,
        backgroundColor: backgroundColor,
        body: Row(
          children: [

          SizedBox(
              width: 15,
            ),
            width <= 800
                ? Container()
                : Expanded(
                    flex: width <= 1100 ? 6 : 8,
                    child: Card(
                        margin: EdgeInsets.all(20),
                        color: themeColor,
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child:
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset("assets/images/img1.jpeg"),
                        )),
                  ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: width <= 800 ? 6 : 3,
              child: StreamBuilder<bool>(
                  stream: isSignUp_BS.stream,
                  initialData: false,
                  builder: (context, isSignUpSnap) {
                    return StreamBuilder<bool>(
                      stream: isVerify.stream,
                      initialData: false,
                      builder: (context, snap) {
                        return SingleChildScrollView(

                          child:snap.data!? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "STUDY",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800, fontSize: 22),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "MAMA",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300, fontSize: 22),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: spacer / 3 *2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(25, 10, 25, 8),
                                    width: 25,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: isSignUpSnap.data!
                                            ? themeColor.withAlpha(50)
                                            : themeColor,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(25, 10, 25, 8),
                                    width: 25,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: isSignUpSnap.data!
                                            ? themeColor
                                            : themeColor.withAlpha(50),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    child: Text("Sign In"),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    child: Text("Sign Up"),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: spacer / 3 * 2,
                              ),
                              getTextField("Enter OTP", otpController,
                                  otpFocusNode, context,
                                  nextFocusNode: null,
                                  prefixIcon: Icon(Icons.account_circle)),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text("Scan with Google Authenticator to get the OTP"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<String>(
                                stream: qrSTring.stream,
                                initialData: "",
                                builder: (context, snapqr) {
                                  return QrImage(
                                    data: snapqr.data.toString(),
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  );
                                }
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: showLoadingBar,
                                child: CircularProgressIndicator(
                                  backgroundColor: themeDarkColor.withAlpha(25),
                                  valueColor:AlwaysStoppedAnimation<Color>(themeDarkColor),
                                  strokeWidth: 5,
                                ),
                              ),
                              SizedBox(
                                height: spacer / 2,
                              ),
                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  onPressed: () {
                                    Map<String, dynamic> map2 = {
                                      "otp": otpController.value.text,
                                      "secret": loginRequest.username,
                                    };
                                    loginRemoteRepository.verifyOTP(map2).then((value)  {
                                      print("otp verify string"+value.data.toString());
                                      if(value.data.toString().contains("true")){
                                        Toast.show("Login Successfully", context,
                                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                        Navigator.pop(context);
                                        loginData.add(loginRequest);


                                      }else{
                                        Toast.show("Wrong OTP ", context,
                                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);


                                      }


                                    });

                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  padding: EdgeInsets.fromLTRB(10, 18, 10, 20),
                                  color: themeDarkColor,
                                  child: Text(
                                    "Verify",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: spacer / 3 * 2,
                              ),
                              Divider(
                                height: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(isSignUpSnap.data!
                                      ? "Already have an account?"
                                      : "Don't have an account?"),
                                  InkWell(
                                      onTap: () => changeScreen(!isSignUpSnap.data!),
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          isSignUpSnap.data! ? "Sign In" : "Sign Up",
                                          style: TextStyle(
                                              color: themeColor,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      )),
                                ],
                              ),
                              width <= 800
                                  ? Container()
                                  : SizedBox(
                                height: spacer * 2,
                              ),
                            ],
                          ):Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "STUDY",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800, fontSize: 22),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "MAMA",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300, fontSize: 22),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: spacer / 3 *2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(25, 10, 25, 8),
                                    width: 25,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: isSignUpSnap.data!
                                            ? themeColor.withAlpha(50)
                                            : themeColor,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(25, 10, 25, 8),
                                    width: 25,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: isSignUpSnap.data!
                                            ? themeColor
                                            : themeColor.withAlpha(50),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    child: Text("Sign In"),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    child: Text("Sign Up"),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: spacer / 3 * 2,
                              ),
                              getTextField("Enter UserName", usernameController,
                                  usernameFocusNode, context,
                                  nextFocusNode: passwordFocusNode,
                                  prefixIcon: Icon(Icons.account_circle)),
                              SizedBox(
                                height: 10,
                              ),
                              getTextField("Enter Password", passwordController,
                                  passwordFocusNode, context,
                                  prefixIcon: Icon(Icons.vpn_key),
                                  isObscure: true),
                              SizedBox(
                                height: 18,
                              ),
                              isSignUpSnap.data!?getTextField("Enter email address", emailController,
                                  emailFocusNode, context,
                                  prefixIcon: Icon(Icons.email),
                                  isObscure: false):Container(),
                              SizedBox(
                                height: 18,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<bool>(
                                  stream: userDisable.stream,
                                  initialData: false,
                                  builder: (context, userDisableSnapshot) {
                                    return userDisableSnapshot.data!?Container(
                                      alignment: Alignment.center,
                                      child: Text("User have been disable for attempting over 3 times in 10 min.",style: TextStyle(color: Colors.red),),
                                    ):Container();
                                  }
                              ),
                              isSignUpSnap.data!
                                  ? StreamBuilder<bool>(
                                  stream: isUser_BS.stream,
                                  initialData: false,
                                  builder: (context, snapShot) {
                                    return Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        getRadioButton("Admin", !snapShot.data!,
                                            onTapFun: () {
                                              isUser_BS.add(false);
                                            }),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        getRadioButton("User", snapShot.data!,
                                            onTapFun: () {
                                              isUser_BS.add(true);
                                            }),
                                      ],
                                    );
                                  })
                                  : Container(),

                              Visibility(
                                visible: showLoadingBar,
                                child: CircularProgressIndicator(
                                  backgroundColor: themeDarkColor.withAlpha(25),
                                  valueColor:AlwaysStoppedAnimation<Color>(themeDarkColor),
                                  strokeWidth: 5,
                                ),
                              ),
                              SizedBox(
                                height: spacer / 2,
                              ),
                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      showLoadingBar = true;
                                    });
                                    getLogin(usernameController.text,
                                        passwordController.text);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  padding: EdgeInsets.fromLTRB(10, 18, 10, 20),
                                  color: themeDarkColor,
                                  child: Text(
                                    isSignUpSnap.data! ? "Register" : "Login",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: spacer / 3 * 2,
                              ),
                              Divider(
                                height: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(isSignUpSnap.data!
                                      ? "Already have an account?"
                                      : "Don't have an account?"),
                                  InkWell(
                                      onTap: () => changeScreen(!isSignUpSnap.data!),
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          isSignUpSnap.data! ? "Sign In" : "Sign Up",
                                          style: TextStyle(
                                              color: themeColor,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      )),
                                ],
                              ),
                              width <= 800
                                  ? Container()
                                  : SizedBox(
                                height: spacer * 2,
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  }),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ));
  }

  void changeScreen(bool isSignUp) {
    isSignUp_BS.add(isSignUp);
    isVerify.add(false);
    userDisable.add(false);

  }

  void getLogin(
    String username,
    String password,
  ) {
    if (username == "" || password == "") {
      Toast.show("Enter UserName/Password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      setState(() {
        showLoadingBar = false;
      });
    } else {

      if(isSignUp_BS.value){

        Map<String, dynamic> map = {
          "username": username,
          "password": password,
          "email":emailController.value.text,
          "role": isUser_BS.value? "ROLE_USER" : "ROLE_ADMIN" ,
        };
        loginRemoteRepository.register(map).then((value) {
          setState(() {
            showLoadingBar = false;
          });
          if (value.statusCode == 200) {

            Toast.show("Register Success and Email verification have been sent to your email address", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            isSignUp_BS.add(false);
            emailVerify.add(true);
          } else {
            Toast.show("Register Fail", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        },onError:(exception) {

          setState(() {
            showLoadingBar = false;
          });

          DioError dioError = exception ;
          Toast.show("Error : "+dioError.response!.data["error"].toString() , context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      }
      else{
        Map<String, dynamic> map = {
          "password": password,
          "username": username,
        };

        loginRemoteRepository.login(map).then((value) {
          setState(() {
            showLoadingBar = false;
          });
          if (value.statusCode == 200) {

            loginRequest = LoginRequest.fromJson(map);
            token = LoginResponse.fromJson(value.data).token;
            print("token"+token);
            Map<String, dynamic> map2 = {
              "secret": username,
              "username": username,
            };
            isVerify.add(true);

             loginRemoteRepository.otpQRString(map2).then((value)  {
               var qr=value.data.toString();
               print("qr string"+value.data.toString());

               qrSTring.add(qr);

             });

            Toast.show("Login Success", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return Profile();
              //     });
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => Login()));
          } else {
            Toast.show("Wrong Username or Password", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        },onError: (e){
          setState(() {
            showLoadingBar = false;
          });
          DioError dioError = e ;
          if(dioError.response!.data["message"].toString().toLowerCase().contains("disable")){
            userDisable.add(true);

          }else{

            Toast.show("Error : "+dioError.response!.data["message"].toString() , context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        });

      }

      // setState(() {
      //   showLoadingBar = false;
      // });
      // if (username == "admin" && password == "admin") {
      //   Toast.show("Login Success", context,
      //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //     Map<String, dynamic> map = {
      //       "username": username,
      //       "password": password,
      //     };
      //   loginRequest = LoginRequest.fromJson(map);
      //   // isSignUp_BS.add(false);
      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         return Profile();
      //       });
      // } else {
      //   Toast.show("Wrong Username or Password", context,
      //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      // }
    }
  }
}
