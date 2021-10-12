// import 'package:flutter/material.dart';
// import 'package:study_mama/DataSource/Login/loginRemoteRepository.dart';
// import 'package:study_mama/Screen/loginScreen.dart';
// import 'package:study_mama/Util/color.dart';
// import 'package:toast/toast.dart';
//
// class LoginRegister extends StatefulWidget {
//   @override
//   _GetLoginRegisterState createState() => _GetLoginRegisterState();
// }
//
// class _GetLoginRegisterState extends State<LoginRegister> {
//   bool showLoadingBar = false;
//   final key = new GlobalKey<ScaffoldState>();
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController roleController = TextEditingController();
//
//   LoginRemoteRepository loginRemoteRepository = LoginRemoteRepository();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     usernameController.text = "admin";
//     passwordController.text = "admin";
//     roleController.text = "admin";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: key,
//       backgroundColor: themeColor,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Center(
//             child: Card(
//               color: Colors.white,
//               elevation: 10,
//               child: Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       'Register',
//                       style: TextStyle(
//                           color: themeDarkColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20),
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     SizedBox(
//                       width: 400,
//                       child: TextField(
//                         controller: usernameController,
//                         decoration: InputDecoration(
//                             prefixIcon: Icon(Icons.account_circle),
//                             hintText: 'Enter UserName'),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                       width: 400,
//                       child: TextField(
//                         controller: passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                             prefixIcon: Icon(Icons.vpn_key),
//                             hintText: 'Enter Password'),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                       width: 400,
//                       child: TextField(
//                         controller: roleController,
//                         decoration: InputDecoration(
//                             prefixIcon: Icon(Icons.settings_applications),
//                             hintText: 'Enter Role'),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         RaisedButton(
//                           onPressed: () {
//                             setState(() {
//                               showLoadingBar = true;
//                             });
//                             getLogin(usernameController.text,
//                                 passwordController.text,
//                                 roleController.text);
//                           },
//                           color: themeDarkColor,
//                           child: Text(
//                             'Register',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Visibility(
//                       visible: showLoadingBar,
//                       child: CircularProgressIndicator(
//                         backgroundColor: Colors.white,
//                         strokeWidth: 5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void getLogin(String username, String password, String role) {
//     if (username == "" || password == "" || role == "") {
//       Toast.show("Enter UserName/Password/Role", context,
//           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//       setState(() {
//         showLoadingBar = false;
//       });
//     } else {
//
//       // Map<String, dynamic> loginMap = {
//       //   "username": username,
//       //   "password": password,
//       //   "role": role,
//       // };
//       // loginRemoteRepository.login(loginMap).then((value) {
//       //   print("PPP " + value.toString());
//       //   setState(() {
//       //     showLoadingBar = false;
//       //   });
//       //   if (value.statusCode == 200) {
//       //     Toast.show("Register Success", context,
//       //         duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//       //     Navigator.pop(context);
//       //     Navigator.push(context,
//       //         MaterialPageRoute(builder: (context) => Login()));
//       //   } else {
//       //     Toast.show("Register Fail", context,
//       //         duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//       //   }
//       // });
//
//       setState(() {
//         showLoadingBar = false;
//       });
//       if (username=="admin" && password=="admin" && role=="admin") {
//         Toast.show("Register Success", context,
//             duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//         Navigator.pop(context);
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => Login()));
//       } else {
//         Toast.show("Register Fail", context,
//             duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//       }
//
//     }
//   }
// }
