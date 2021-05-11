import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:study_mama_flutter/DataSource/Login/loginRemoteRepository.dart';
import 'package:study_mama_flutter/DataSource/Profile/profileRemoteRepository.dart';
import 'package:study_mama_flutter/Model/getProfileModel.dart';
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
  TextEditingController passwordController = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  LoginRemoteRepository loginRemoteRepository = LoginRemoteRepository();

  BehaviorSubject<bool> isSignUp_BS = BehaviorSubject.seeded(false);
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
                        child: Container(
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
                    return SingleChildScrollView(
                      child: Column(
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
          "role": isUser_BS.value? "ROLE_USER" : "ROLE ADMIN" ,
        };

        loginRemoteRepository.register(map).then((value) {
          setState(() {
            showLoadingBar = false;
          });
          if (value.statusCode == 200) {

            Toast.show("Register Success", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            isSignUp_BS.add(false);


          } else {
            Toast.show("Register Fail", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }


        }).catchError((onError){
          setState(() {
            showLoadingBar = false;
          });
          Toast.show("Error : "+onError.toString(), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      }
      else{
        Map<String, dynamic> map = {
          "username": username,
          "password": password,
        };

        loginRemoteRepository.login(map).then((value) {
          setState(() {
            showLoadingBar = false;
          });
          if (value.statusCode == 200) {

            loginRequest = LoginRequest.fromJson(map);
            token = LoginResponse.fromJson(value.data).token;
            loginData.add(loginRequest);
            print("token"+token);
            Toast.show("Login Success", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

            Map<String, dynamic> map1 = {
              "username": loginRequest.username,
              "password": loginRequest.password,
              "token":token
            };
            ProfileRemoteRepository _profileRemoteRepository = ProfileRemoteRepository();

            _profileRemoteRepository.getProfile(map1).then((value) {

              if (value.statusCode == 200) {
                GetProfileResponse response = GetProfileResponse.fromJson(value.data);
                accountID = response.id.toString();
                loginAccName = username;
                print("accoount "+accountID);
                print("name "+loginAccName);

              } else {
                Toast.show("Get Profile Fail", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
            }).catchError((onError) {

              Toast.show("Error : " + onError.toString(), context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            });

              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return Profile();
              //     });
            Navigator.pop(context);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => Login()));
          } else {
            Toast.show("Wrong Username or Password", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }).catchError((onError){
          setState(() {
            showLoadingBar = false;
          });
          print("Error"+onError.toString());
          Toast.show("Error : "+onError.toString(), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
