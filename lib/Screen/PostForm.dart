import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:study_mama_flutter/main.dart';
import 'package:study_mama_flutter/util/color.dart';
import 'package:study_mama_flutter/util/constant.dart';
import 'package:study_mama_flutter/util/widget.dart';

import '../model.dart';

class PostForm extends StatefulWidget{
   Post? post;
   Function onSuccess;

   PostForm({this.post,required this.onSuccess});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return PostFormState();
  }

}

class PostFormState extends State<PostForm>{
  final GlobalKey<FormState> _postFormKey = GlobalKey<FormState>();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController webTextController = TextEditingController();
  TextEditingController locTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController contactTextController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  BehaviorSubject<bool> status = BehaviorSubject.seeded(true);

  var dio=getDio();

  void postFormSubmit(Post post){

    if(widget.post!=null){
      post.id=widget.post!.id;
    }
    print("json"+post.toJson().toString());
    dio.post("/postFormSubmit",data: post.toJson()).then((value)  {
      print("Value"+value.toString());
      widget.onSuccess();
    }).catchError((onError){
      print("Error error $onError");
    });
  }


  @override
  void initState() {
    super.initState();
    if(widget.post!=null){
      titleTextController.text=widget.post!.title;
      descTextController.text=widget.post!.description;
      webTextController.text=widget.post!.website;

      if(widget.post!.location!=null){
        locTextController.text=widget.post!.location!.lat.toString()+","+widget.post!.location!.lon.toString();
      }
      if(widget.post!.status.contains("CLOSED")){
        status.add(false);
      }else{
        status.add(true);
      }
      priceTextController.text=widget.post!.price;
      contactTextController.text=widget.post!.contact;
      categoryController.text=widget.post!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return AlertDialog(

     contentPadding: EdgeInsets.all(0),
     shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(20))),
     title: Container(
         padding: EdgeInsets.only(left: 5),
         child: Text("Create New Post")),
     content: SingleChildScrollView(
       child: Container(
         constraints: BoxConstraints(minWidth: 350),
         padding: EdgeInsets.only(left: 30,right: 30,top: 50),
         width: MediaQuery.of(context).size.width * 0.9,
         child: Form(
           key: _postFormKey,
           child: Column(
             mainAxisSize: MainAxisSize.max,
             children: [
               TextFormField(
                 controller: titleTextController,
                 validator: (val) {
                   print("title txt"+titleTextController.value.text);
                   return val!.isEmpty ? "Enter Title here" : null;
                 },
                 decoration: InputDecoration(
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(
                       Radius.circular(8),
                     ),
                     borderSide: BorderSide(style: BorderStyle.none, width: 0),
                   ),
                   contentPadding: EdgeInsets.fromLTRB(20,10,15,0),
                   filled: true,
                   fillColor: themeDarkColor.withAlpha(20),
                   labelText: 'Title',
                   hintText: "Enter Title here",
                 ),
               ),
               SizedBox(height: 10,),

               TextFormField(
                 controller: descTextController,
                 maxLines: 5,
                 validator: (val) {
                   return val!.isEmpty ? "Enter description here" : null;
                 },
                 decoration: InputDecoration(
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(
                       Radius.circular(8),
                     ),
                     borderSide: BorderSide(style: BorderStyle.none, width: 0),
                   ),
                   contentPadding: EdgeInsets.fromLTRB(20,60,15,0),
                   filled: true,
                   labelText: 'Description',
                   fillColor: themeDarkColor.withAlpha(20),
                   hintText: "Enter description here",
                 ),
               ),
               SizedBox(height: 10,),

               TextFormField(
                 controller: priceTextController,

                 validator: (val) {
                   return val!.isEmpty ? "Enter price here" : null;
                 },
                 decoration: InputDecoration(
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(
                       Radius.circular(8),
                     ),
                     borderSide: BorderSide(style: BorderStyle.none, width: 0),
                   ),
                   contentPadding: EdgeInsets.fromLTRB(20,10,15,0),
                   filled: true,
                   labelText: 'Price',
                   fillColor: themeDarkColor.withAlpha(20),
                   hintText: "Enter price here",
                 ),
               ),
               SizedBox(height: 10,),

               TextFormField(
                 controller: categoryController,
                 validator: (val) {
                   return val!.isEmpty ? "Enter Category here" : null;
                 },
                 decoration: InputDecoration(
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(
                       Radius.circular(8),
                     ),
                     borderSide: BorderSide(style: BorderStyle.none, width: 0),
                   ),
                   contentPadding: EdgeInsets.fromLTRB(20,10,15,0),
                   filled: true,
                   labelText: 'Category',
                   fillColor: themeDarkColor.withAlpha(20),
                   hintText: "Enter Category here",
                 ),
               ),
               SizedBox(height: 10,),

               TextFormField(
                 controller: contactTextController,

                 validator: (val) {
                   return val!.isEmpty ? "Enter Contact Number here" : null;
                 },
                 decoration: InputDecoration(
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.all(
                         Radius.circular(8),
                       ),
                       borderSide: BorderSide(style: BorderStyle.none, width: 0),
                     ),
                     contentPadding: EdgeInsets.fromLTRB(20,10,15,0),
                     filled: true,
                   labelText: 'Contact Number',
                   fillColor: themeDarkColor.withAlpha(20),
                     hintText: "Enter Contact Number here",
                 ),
               ),
               SizedBox(height: 10,),
               StreamBuilder<bool>(
                   stream: status.stream,
                   initialData: false,
                   builder: (context, snapShot) {
                     return Row(
                       mainAxisAlignment:
                       MainAxisAlignment.center,
                       children: [
                         getRadioButton("OPEN", snapShot.data!,
                             onTapFun: () {
                               status.add(true);
                             }),
                         SizedBox(
                           width: 7,
                         ),
                         getRadioButton("CLOSED", !snapShot.data!,
                             onTapFun: () {
                               status.add(false);
                             }),
                       ],
                     );
                   }),
               SizedBox(height: 10,),
               TextFormField(
                 controller: webTextController,
                 decoration: InputDecoration(
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(
                       Radius.circular(8),
                     ),
                     borderSide: BorderSide(style: BorderStyle.none, width: 0),
                   ),
                   contentPadding: EdgeInsets.fromLTRB(20,10,15,0),
                   filled: true,
                   labelText: 'Website',
                   fillColor: themeDarkColor.withAlpha(20),
                   hintText: "Enter website here",
                 ),
               ),
               SizedBox(height: 10,),
               TextFormField(
                 controller: locTextController,
                 decoration: InputDecoration(
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(
                       Radius.circular(8),
                     ),
                     borderSide: BorderSide(style: BorderStyle.none, width: 0),
                   ),
                   contentPadding: EdgeInsets.fromLTRB(20,10,15,0),
                   filled: true,

                   labelText: 'Location',
                   hintText: "1.3369103,103.697898",
                   fillColor: themeDarkColor.withAlpha(20),
                 ),
               ),
               SizedBox(height: 20,),

               Container(
                 width: double.infinity,
                 child: FlatButton(
                   padding: EdgeInsets.all(25),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.only(
                           bottomLeft: Radius.circular(20),
                           bottomRight: Radius.circular(20))),
                   child: Text(
                     "Cancel",
                     style: TextStyle(
                         color:themeDarkColor,
                         fontWeight: FontWeight.w800),
                   ),
                   onPressed: (){
                     Navigator.pop(context);
                   },
                 ),
               ),
               SizedBox(height: 10,),
               Container(
                 width: double.infinity,
                 child: FlatButton(
                   padding: EdgeInsets.all(25),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.only(
                           bottomLeft: Radius.circular(20),
                           bottomRight: Radius.circular(20))),
                   child: Text(
                     "Submit",
                     style: TextStyle(
                         color:themeDarkColor,
                         fontWeight: FontWeight.w800),
                   ),
                   onPressed: (){
                     if(_postFormKey.currentState!.validate()){
                       var title = titleTextController.value.text;
                       var desc = descTextController.value.text;
                       var category = categoryController.value.text;
                       var contact = contactTextController.value.text;
                       var price = priceTextController.value.text;
                       var web = webTextController.value.text;
                       var loc = locTextController.value.text;
                       var locCation= loc!=null&&loc.split(",").length==2?{
                         "lat":double.parse(loc.split(",")[0]),
                         "lon":double.parse(loc.split(",")[1]),
                       }:{"":""};
                       var map = {
                         "title":title,
                         "description":desc,
                         "website":web,
                         "location":locCation,
                         "category":category,
                         "accountId":accountID,
                         "status":status.value?"1":"0",
                         "contact":contact,
                         "price":price,
                       };

                       // }
                       Post post = Post.fromJson(map);
                       postFormSubmit( post);

                       Navigator.pop(context);
                       final snackBar = SnackBar(content: Text('Successfully created'));
                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                     }

                   },
                 ),
               ),

             ],
           ),
         ),
       ),
     ),
   );
  }

}