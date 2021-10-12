import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:study_mama_flutter/DataSource/Profile/profileRemoteRepository.dart';
import 'package:study_mama_flutter/Model/getProfileModel.dart';
import 'package:study_mama_flutter/util/color.dart';
import 'package:study_mama_flutter/util/constant.dart';
import 'package:study_mama_flutter/util/widget.dart';

import 'package:toast/toast.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode contactFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();

  BehaviorSubject<bool> showLoadingBar_BS = BehaviorSubject.seeded(false);

  ProfileRemoteRepository _profileRemoteRepository = ProfileRemoteRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firstNameController.text = "";
    lastNameController.text = "";
    contactController.text = "";
    addressController.text = "";

    Map<String, dynamic> map = {
      "username": loginRequest.username,
      "password": loginRequest.password,
      "token":token
    };
    _profileRemoteRepository.getProfile(map).then((value) {
      print('value'+value.toString());
      showLoadingBar_BS.add(false);
      if (value.statusCode == 200) {
        GetProfileResponse response = GetProfileResponse.fromJson(value.data);
        firstNameController.text = response.firstName;
        lastNameController.text = response.lastName;
        contactController.text = response.contact;
        addressController.text = response.address;
      } else {
        Toast.show("Get Profile Fail", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((onError) {

      showLoadingBar_BS.add(false);
      Toast.show("Error : " + onError.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    showLoadingBar_BS.close();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: 350),
          width: MediaQuery.of(context).size.width * 0.9,
          child: StreamBuilder<bool>(
              stream: showLoadingBar_BS.stream,
              initialData: false,
              builder: (context, showLoadingBarSnap) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    getImage(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(loginRequest.username),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: getTextField("Enter First Name",
                          firstNameController, firstNameFocusNode, context,
                          nextFocusNode: lastNameFocusNode),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: getTextField(
                        "Enter Last Name",
                        lastNameController,
                        lastNameFocusNode,
                        context,
                        nextFocusNode: contactFocusNode,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: getTextField("Enter Contact", contactController,
                          contactFocusNode, context,
                          nextFocusNode: addressFocusNode, keyboardType: 1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: getTextField("Enter Address", addressController,
                          addressFocusNode, context),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: showLoadingBarSnap.data!,
                      child: CircularProgressIndicator(
                        backgroundColor: themeDarkColor.withAlpha(25),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(themeDarkColor),
                        strokeWidth: 5,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      height: 1,
                    ),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        padding: EdgeInsets.all(height <= 900 ? 15 : 25),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: showLoadingBarSnap.data!
                                  ? dialogCancelBtnTxtColor.withAlpha(150)
                                  : dialogCancelBtnTxtColor,
                              fontWeight: FontWeight.w800),
                        ),
                        onPressed: showLoadingBarSnap.data!
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        padding: EdgeInsets.all(height <= 900 ? 15 : 25),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Text(
                          "Update",
                          style: TextStyle(
                              color: showLoadingBarSnap.data!
                                  ? themeDarkColor.withAlpha(150)
                                  : themeDarkColor,
                              fontWeight: FontWeight.w800),
                        ),
                        onPressed: showLoadingBarSnap.data!
                            ? null
                            : () {
                                updateProfile();
                              },
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  void updateProfile() {
    showLoadingBar_BS.add(true);

    Map<String, dynamic> map = {
      "username": loginRequest.username,
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "contact": contactController.text,
      "address": addressController.text,
    };

    _profileRemoteRepository.updateProfile(map).then((value) {
      showLoadingBar_BS.add(false);
      if (value.statusCode == 200) {
        Toast.show("Update Profile Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Update Profile Fail", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      Navigator.of(context).pop();

    }).catchError((onError) {
      Navigator.of(context).pop();

      showLoadingBar_BS.add(false);
      Toast.show("Error : " + onError.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }
}
