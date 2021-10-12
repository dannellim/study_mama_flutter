import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'color.dart';

Widget getTextField(String hintTxt, TextEditingController txtController,
    FocusNode focusNode, BuildContext context,
    {FocusNode? nextFocusNode,
    Icon? prefixIcon,
    bool isObscure = false,
    int keyboardType = 0}) {
  return TextFormField(
    controller: txtController,
    focusNode: focusNode,
    obscureText: isObscure,
    keyboardType: keyboardType == 1
        ? TextInputType.phone
        : keyboardType == 2
            ? TextInputType.number
            : TextInputType.text,
    textInputAction:
        nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(style: BorderStyle.none, width: 0),
      ),
      contentPadding: EdgeInsets.fromLTRB(20, 0, 15, 0),
      filled: true,
      fillColor: themeDarkColor.withAlpha(20),
      prefixIcon: prefixIcon == null ? null : prefixIcon,
      hintText: hintTxt,
    ),
    onFieldSubmitted: (value) {
      if (nextFocusNode != null)
        FocusScope.of(context).requestFocus(nextFocusNode);
    },
  );
}

Widget getSearchTextField(String hintTxt,
    TextEditingController textEditingController, Function onFieldSubmittedFun) {
  return Container(
    width: 300,
    child: TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      controller: textEditingController,
      enableInteractiveSelection: true,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
          hintText: hintTxt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(style: BorderStyle.none, width: 0),
          ),
          suffixIcon: Container(
            padding: EdgeInsets.only(right: 5),
            child: FlatButton(
                color: themeColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5))),
                onPressed: () {
                  onFieldSubmittedFun();
                },
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 0, 0, 0),
          filled: true,
          fillColor: Colors.white),
      onFieldSubmitted: (value) {
        onFieldSubmittedFun();
      },
    ),
  );
}

Widget getRadioButton(
  String rdoTxt,
  bool isActive, {
  bool isTextRight = true,
  double txtFontSize = 16,
  required Function onTapFun,
}) {
  return InkWell(
    onTap: () {
      onTapFun();
    },
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isTextRight
              ? Container()
              : Text(
                  rdoTxt,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: txtFontSize,
                  ),
                ),
          isTextRight
              ? Container()
              : SizedBox(
                  width: 7,
                ),
          Icon(
            isActive
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isActive ? themeColor : Colors.black54,
            size: 23,
          ),
          isTextRight
              ? SizedBox(
                  width: 7,
                )
              : Container(),
          isTextRight
              ? Text(
                  rdoTxt,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: txtFontSize,
                  ),
                )
              : Container(),
        ],
      ),
    ),
  );
}

Widget getImage() {
  return Container(
    padding: EdgeInsets.all(5),
    child: CachedNetworkImage(
      alignment: Alignment.topLeft,
      height: 53,
      width: 53,
      imageUrl: "",
      imageBuilder: (context, imageProvider) => Container(
        height: 53,
        width: 53,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: Colors.white, style: BorderStyle.solid, width: 2),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        height: 53,
        width: 53,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            // border: Border.all(
            //     color: Colors.white,
            //     style: BorderStyle.solid,
            //     width: 2),
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.3), BlendMode.dstATop),
                image: AssetImage('assets/images/profile.png'))),
      ),
      errorWidget: (context, url, error) => Container(
        height: 53,
        width: 53,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            // border: Border.all(
            //     color: Colors.white,
            //     style: BorderStyle.solid,
            //     width: 2),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/profile.png'))),
      ),
    ),
  );
}
