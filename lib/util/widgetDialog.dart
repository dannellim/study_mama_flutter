
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_mama_flutter/util/color.dart';

Widget showAlertDialog(String title, String description, BuildContext context,
    {required Function onConfirmFun}) {
  return CupertinoAlertDialog(
    title: Text(title),
    content: Text(description),
    actions: [
      CupertinoDialogAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Cancel',
          style: TextStyle(color: themeDarkColor),
        ),
      ),
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
          onConfirmFun();
        },
        child: Text('Confirm', style: TextStyle(color: themeDarkColor)),
      ),
    ],
  );
}

