import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:study_mama_flutter/Model/loginModel.dart';
import 'package:study_mama_flutter/Screen/PostForm.dart';
import 'package:study_mama_flutter/Screen/profileDialog.dart';
import 'package:study_mama_flutter/util/color.dart';
import 'package:study_mama_flutter/util/constant.dart';
import 'package:study_mama_flutter/util/rating.dart';
import 'package:study_mama_flutter/util/widget.dart';
import 'package:toast/toast.dart';

import '../main.dart';
import '../model.dart';
import 'loginScreen.dart';

class ManagePostsScreen extends StatefulWidget {
  @override
  _GetManagePostsState createState() => _GetManagePostsState();
}

class _GetManagePostsState extends State<ManagePostsScreen> {
  bool showLoadingBar = false;
  final key = new GlobalKey<ScaffoldState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  var dio = getDio();

  BehaviorSubject<bool> isSignUp_BS = BehaviorSubject.seeded(false);
  BehaviorSubject<List<Post>> myPosts = BehaviorSubject();
  BehaviorSubject<Post> selectedPost = BehaviorSubject();
  BehaviorSubject<bool> isUser_BS = BehaviorSubject.seeded(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController.text = "admin";
    passwordController.text = "admin";
    getAllPost();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isSignUp_BS.close();
    isUser_BS.close();
  }

  void getAllPost() {
    var options = Options(headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": true
    });
    dio
        .get("/postData",
            queryParameters: {
              "accountId": accountID,
            },
            options: options)
        .then((value) {
      List<Post> posts = [];
      value.data.forEach((v) {
        posts.add(Post.fromJsonDB(v));
      });
      myPosts.add(posts);
      if(posts.isNotEmpty){
        selectedPost.add(posts[0]);
      }
    }).catchError((onError) {
      print("Error error $onError");
    });
  }
  void deletePost(String postId) {
    var options = Options(headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": true
    });
    dio.post("/postDelete",
        queryParameters: {
          "postId": postId,
        },)
        .then((value) {

      final snackBar = SnackBar(content: Text('Successfully deleted'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      getAllPost();
    }).catchError((onError) {
      print("Error error $onError");
    });
    dio
        .post("/postService/postDelete",
        queryParameters: {
          "id": postId,
        },
        options: options)
        .then((value) {
    }).catchError((onError) {
      print("Error error $onError");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                            child: Row(
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
                            )),
                      ),
                      Container(
                        child: StreamBuilder<LoginRequest>(
                            stream: loginData.stream,
                            builder: (context, snapshot) {
                              return Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10, top: 10),
                                    child: InkWell(
                                      onTap: () {
                                        if (snapshot.hasData) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Profile()));
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: snapshot.hasData
                                                    ? themeColor
                                                    : Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: snapshot.hasData
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Profile()));
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(snapshot.data!.username),
                                                    Container(
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8.0),
                                                          child: Icon(
                                                            Icons
                                                                .person_outline_rounded,
                                                            size: 20,
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : RaisedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Login()));
                                                },
                                                color: themeColor,
                                                child: Text(
                                                  "Sign in",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20,top: 50),
                    child: Text(
                      "My Posts",
                      style: TextStyle(color: themeColor, fontSize: 18),
                    )),
                Container(
                  child: StreamBuilder<List<Post>>(
                      stream: myPosts.stream,
                    builder: (context, snapshot) {
                      return (snapshot.hasData&&snapshot.data!.isNotEmpty)?Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width/2,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [

                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: RaisedButton(onPressed: (){

                                  }, color: themeColor,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => PostForm(onSuccess: (){
                                              getAllPost();
                                            },)));
                                      },
                                      child: Container(
                                          padding: EdgeInsets.only(bottom: 15,top: 15,left: 5,right: 5),
                                          child: Text("Create Post",style: TextStyle(color: Colors.white),)),
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 30),
                                    child: StreamBuilder<List<Post>>(
                                        stream: myPosts.stream,
                                        initialData: [],
                                        builder: (context, snapshot) {

                                          return DataTable(

                                            showCheckboxColumn: false,
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Text(
                                                  'Title',
                                                  style: TextStyle(
                                                      fontStyle: FontStyle.italic),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Description',
                                                  style: TextStyle(
                                                      fontStyle: FontStyle.italic),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Price (SGD)',
                                                  style: TextStyle(
                                                      fontStyle: FontStyle.italic),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'status',
                                                  style: TextStyle(
                                                      fontStyle: FontStyle.italic),
                                                ),
                                              ),
                                            ],
                                            rows: snapshot.hasData
                                                ? snapshot.data!
                                                .map(
                                                  (post) => DataRow(
                                                  onSelectChanged: (selected) {
                                                    if (selected
                                                        .toString()
                                                        .contains("true")) {
                                                      selectedPost.add(post);
                                                    }
                                                  },
                                                  cells: [
                                                    DataCell(
                                                      Text(post.title),
                                                    ),
                                                    DataCell(
                                                      Container(
                                                          width: 300,
                                                          child: Text(post.description,
                                                            overflow: TextOverflow.ellipsis,)),
                                                    ),
                                                    DataCell(
                                                      Text(post.price),
                                                    ),
                                                    DataCell(
                                                      Text(post.status),
                                                    ),
                                                  ]),
                                            )
                                                .toList()
                                                : <DataRow>[],
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 40,top: 20),
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                border:Border(
                                  top: BorderSide(width: 2.0, color: themeColor,),
                                  left: BorderSide(width: 2.0, color: themeColor),
                                )
                              ),
                              child: StreamBuilder<Post>(
                                  stream: selectedPost.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var score = !snapshot.data!.score.toString().contains("null")
                                          ? double.parse(snapshot.data!.score)
                                          : 0.0;
                                      var rating = MRatingBar.builder(
                                        initialRating: score,
                                        itemCount: 5,
                                        itemSize: 25,
                                        itemBuilder: (context, index) {
                                          switch (index) {
                                            case 0:
                                              return Icon(
                                                Icons.sentiment_very_dissatisfied,
                                                color: Colors.red,
                                              );
                                            case 1:
                                              return Icon(
                                                Icons.sentiment_dissatisfied,
                                                color: Colors.redAccent,
                                              );
                                            case 2:
                                              return Icon(
                                                Icons.sentiment_neutral,
                                                color: Colors.amber,
                                              );
                                            case 3:
                                              return Icon(
                                                Icons.sentiment_satisfied,
                                                color: Colors.lightGreen,
                                              );
                                            case 4:
                                              return Icon(
                                                Icons.sentiment_very_satisfied,
                                                color: Colors.green,
                                              );
                                            default:
                                              return Icon(Icons.add);
                                          }
                                        },
                                        onRatingUpdate: (double value) {},
                                      );
                                      return Flexible(
                                        flex: 1,
                                        child: Container(

                                          padding: EdgeInsets.all(10),
                                          child: Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data!.title,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(top: 15),
                                                  padding: EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    snapshot.data!.description,
                                                    style: TextStyle(height: 1.5),
                                                  )),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                padding: EdgeInsets.only(top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                        "Price  : ${snapshot.data!.price} SGD"),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                padding: EdgeInsets.only(top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                        "Status  : ${snapshot.data!.status} "),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                padding: EdgeInsets.only(top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                        "Category  : ${snapshot.data!.category} "),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text("Rating  : "),
                                                        Container(
                                                            margin:
                                                            EdgeInsets.only(left: 5),
                                                            child: rating)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 50),
                                                child: Row(
                                                  children: [
                                                    RaisedButton(onPressed: (){

                                                      Navigator.push(context,
                                                          MaterialPageRoute(builder: (context) => PostForm(post: snapshot.data,onSuccess: (){
                                                            getAllPost();
                                                          },)));

                                                    }, color: themeColor,
                                                      child: Text("Edit",style: TextStyle(color: Colors.white),),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),),

                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    RaisedButton(onPressed: (){
                                                      showDialog(
                                                          context: context,
                                                          builder: (dcontext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Do you want to delete this post " ${snapshot.data!.title } " ?'),
                                                              content: Text(
                                                                  'This will be done permanently and cannot be undo.'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(dcontext);
                                                                  },
                                                                  child: Text(
                                                                    'CANCEL',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF6200EE)),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(dcontext);
                                                                    deletePost(snapshot.data!.id);
                                                                  },
                                                                  child: Text('Confirm',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFF6200EE))),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    }, color: themeColor,
                                                      child: Text("Delete",style: TextStyle(color: Colors.white),),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),)
                                                  ],
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                            ),
                          )
                        ],
                      )
                          :Container(
                            height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child: OutlinedButton(
                          onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => PostForm(onSuccess: (){
                                  getAllPost();
                                },)));

                          },

                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(top: 10,bottom: 10),
                            child: const Text("Create your first post here",style: TextStyle(
                              fontSize: 20
                            ),),
                          ),
                        ),
                      );

                    }
                  ),
                )
              ],
            ),

          ],
        ));
  }
}
