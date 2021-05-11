import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:study_mama_flutter/Model/loginModel.dart';
import 'package:study_mama_flutter/Screen/PostForm.dart';
import 'package:study_mama_flutter/Screen/profileDialog.dart';
import 'package:study_mama_flutter/util/color.dart';
import 'package:study_mama_flutter/util/constant.dart';
import 'package:study_mama_flutter/util/rating.dart';

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
      if (posts.isNotEmpty) {
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
    dio.post(
      "/postDelete",
      queryParameters: {
        "postId": postId,
      },
    ).then((value) {
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
        .then((value) {})
        .catchError((onError) {
      print("Error error $onError");
    });
  }

  @override
  Widget build(BuildContext context) {
    double tableWidth = MediaQuery.of(context).size.width- 480;
    final spinkit = SpinKitCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Color(0xff2F2F55) : Color(0xffCBCBE2),
          ),
        );
      },
    );
    return Scaffold(
        key: key,
        backgroundColor: backgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 18, 30, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 24,
                                color: themeColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "STUDY",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 25),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "MAMA",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 25),
                              ),
                            ],
                          )),
                    ),
                    Container(
                      child: StreamBuilder<LoginRequest>(
                          stream: loginData.stream,
                          builder: (context, snapshot) {
                            return snapshot.hasData? PopupMenuButton(
                              initialValue: 0,
                              onSelected: (int index) {
                                if(index==0){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => Profile()));
                                }else{
                                  loginData.add(null);
                                  loginRequest=LoginRequest();
                                  token="";
                                  accountID="";
                                  loginAccName="";

                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => MyHomePage(title: "title")));
                                }
                              },
                              child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: themeColor), borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Padding(
                                      padding:
                                      EdgeInsets.fromLTRB(8, 8, 8, 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: themeColor,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            snapshot.data!.username,
                                            style: TextStyle(
                                                color: themeColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                              itemBuilder: (context) {
                                return List.generate(2, (index) {
                                  return index==1?PopupMenuItem(
                                      value: index,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.logout),
                                          Text('Sign Out'),
                                        ],
                                      )):PopupMenuItem(
                                    value: index,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.person),
                                        Text('Profile'),
                                      ],
                                    ),
                                  );
                                });
                              },
                            ):Container();
                          }),
                    )
                  ],
                ),
              ),
              // Container(
              //     margin: EdgeInsets.only(left: 20),
              //     child: Text(
              //       "My Posts",
              //       style: TextStyle(
              //           color: themeColor,
              //           fontSize: 18,
              //           fontWeight: FontWeight.w500),
              //     )),
              Container(
                child: StreamBuilder<List<Post>>(
                    stream: myPosts.stream,
                    builder: (context, snapshot) {
                      return snapshot.hasData ? snapshot.data!.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding:EdgeInsets.only(left: 25,right: 25),
                                  height: MediaQuery.of(context).size.height-100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "My Posts",
                                        style: TextStyle(
                                            color: themeColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),),
                                      StreamBuilder<List<Post>>(
                                          stream: myPosts.stream,
                                          initialData: [],
                                          builder: (context, snapshot) {
                                            return Scrollbar(
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Container(
                                                  child: DataTable(
                                                    showCheckboxColumn: false,
                                                    columns: <DataColumn>[
                                                      DataColumn(
                                                        label: Text(
                                                          'Title',
                                                          style: TextStyle(
                                                              fontStyle: FontStyle
                                                                  .italic),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Description',
                                                          style: TextStyle(
                                                              fontStyle: FontStyle
                                                                  .italic),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Price (SGD)',
                                                          style: TextStyle(
                                                              fontStyle: FontStyle
                                                                  .italic),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'status',
                                                          style: TextStyle(
                                                              fontStyle: FontStyle
                                                                  .italic),
                                                        ),
                                                      ),
                                                    ],
                                                    rows: snapshot.hasData
                                                        ? snapshot.data!
                                                        .map(
                                                          (post) => DataRow(
                                                          onSelectChanged:
                                                              (selected) {
                                                            if (selected
                                                                .toString()
                                                                .contains(
                                                                "true")) {
                                                              selectedPost
                                                                  .add(
                                                                  post);
                                                            }
                                                          },
                                                          cells: [
                                                            DataCell(
                                                              Container(
                                                                width:
                                                                tableWidth/8,
                                                                constraints: BoxConstraints(minWidth: 50),
                                                                child: Text(post
                                                                    .title),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Container(
                                                                  width:
                                                                  tableWidth/8*3,
                                                                  constraints: BoxConstraints(minWidth: 150),
                                                                  child:
                                                                  Text(
                                                                    post.description,
                                                                    overflow:
                                                                    TextOverflow.ellipsis,
                                                                  )),
                                                            ),
                                                            DataCell(
                                                              Container(
                                                                width:
                                                                tableWidth/4,
                                                                constraints: BoxConstraints(minWidth: 70),
                                                                child: Text(post
                                                                    .price),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Container(
                                                                width:
                                                                tableWidth/8,
                                                                constraints: BoxConstraints(minWidth: 50),
                                                                child: Text(post
                                                                    .status),
                                                              ),
                                                            ),
                                                          ]),
                                                    )
                                                        .toList()
                                                        : <DataRow>[],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                      SizedBox(height: 10,),
                                      RaisedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return PostForm(
                                                  onSuccess: () {
                                                    getAllPost();
                                                  },
                                                );
                                              });
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             PostForm(
                                          //               onSuccess: () {
                                          //                 getAllPost();
                                          //               },
                                          //             )));
                                        },
                                        color: themeColor,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: 10,
                                                top: 10,
                                                left: 12,
                                                right: 12),
                                            child: Text(
                                              "Create Post",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5)),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: StreamBuilder<Post>(
                                      stream: selectedPost.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var score = !snapshot.data!.score
                                              .toString()
                                              .contains("null")
                                              ? double.parse(
                                              snapshot.data!.score)
                                              : 0.0;
                                          var rating = MRatingBar.builder(
                                            initialRating: score,
                                            itemCount: 5,
                                            itemSize: 25,
                                            itemBuilder: (context, index) {
                                              switch (index) {
                                                case 0:
                                                  return Icon(
                                                    Icons
                                                        .sentiment_very_dissatisfied,
                                                    color: Colors.red,
                                                  );
                                                case 1:
                                                  return Icon(
                                                    Icons
                                                        .sentiment_dissatisfied,
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
                                                    Icons
                                                        .sentiment_very_satisfied,
                                                    color: Colors.green,
                                                  );
                                                default:
                                                  return Icon(Icons.add);
                                              }
                                            },
                                            onRatingUpdate: (double value) {},
                                          );
                                          return Container(
                                            width: 400,
                                            margin: EdgeInsets.only(right: 25),
                                            padding: EdgeInsets.only(bottom: 12),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: Colors.white),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 20,),
                                                Text(
                                                  snapshot.data!.title,
                                                  style: TextStyle(fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: themeColor),
                                                ),
                                                Container(
                                                    padding: EdgeInsets.only(top: 10, left: 20, right: 20,bottom: 10),
                                                    alignment: Alignment.center,
                                                    constraints: BoxConstraints(
                                                      minHeight: 40,
                                                    ),
                                                    child: Text(
                                                      snapshot
                                                          .data!.description,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(height: 1.5),
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text("Rating  : "),
                                                        GestureDetector(onTap: () {}, child: rating)
                                                      ],
                                                    )),
                                                Container(
                                                    margin: EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 5),
                                                    child: Text("Category  : ${snapshot.data!.category}")),
                                                Container(
                                                    margin: EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text("Status  :  "),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.all(Radius.circular(5)),
                                                              color: snapshot.data!.status.contains("1")
                                                                  ? Colors.redAccent
                                                                  : Colors.lightGreen),
                                                          child: Text(
                                                              "${snapshot.data!.status.contains("1") ? "CLOSED" : "ACTIVE"}",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500)),
                                                        ),
                                                      ],
                                                    )),
                                                Container(
                                                    margin: EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 5),
                                                    child: Text("Price  : \$ ${snapshot.data!.price} SGD")),

                                                SizedBox(
                                                  height: 15,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(width: 15,),
                                                    RaisedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return PostForm(
                                                                onSuccess: () {
                                                                  getAllPost();
                                                                },
                                                              );
                                                            });
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder:
                                                        //             (context) =>
                                                        //             PostForm(
                                                        //               post: snapshot.data,
                                                        //               onSuccess: () {
                                                        //                 getAllPost();
                                                        //               },
                                                        //             )));
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(5)),
                                                      padding: EdgeInsets.fromLTRB(10, 18, 10, 20),
                                                      color: themeDarkColor,
                                                      child: Text(
                                                        "Edit",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    RaisedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context:
                                                            context,
                                                            builder:
                                                                (dcontext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Do you want to delete this post " ${snapshot.data!.title} " ?'),
                                                                content: Text(
                                                                    'This will be done permanently and cannot be undo.'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          dcontext);
                                                                    },
                                                                    child:
                                                                    Text(
                                                                      'CANCEL',
                                                                      style:
                                                                      TextStyle(color: Color(0xFF6200EE)),
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          dcontext);
                                                                      deletePost(snapshot
                                                                          .data!
                                                                          .id);
                                                                    },
                                                                    child: Text(
                                                                        'Confirm',
                                                                        style:
                                                                        TextStyle(color: Color(0xFF6200EE))),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(5)),
                                                      padding: EdgeInsets.fromLTRB(10, 18, 10, 20),
                                                      color: themeDarkColor,
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(width: 15,),
                                                  ],
                                                ),

                                                SizedBox(height: 5,),
                                                // Container(
                                                //   margin: EdgeInsets.only(
                                                //       top: 10),
                                                //   padding: EdgeInsets.only(
                                                //       top: 10),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .spaceBetween,
                                                //     children: [
                                                //       Text(
                                                //           "Price  : ${snapshot.data!.price} SGD"),
                                                //     ],
                                                //   ),
                                                // ),
                                                // Container(
                                                //   margin: EdgeInsets.only(
                                                //       top: 10),
                                                //   padding: EdgeInsets.only(
                                                //       top: 10),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .spaceBetween,
                                                //     children: [
                                                //       Text(
                                                //           "Status  : ${snapshot.data!.status} "),
                                                //     ],
                                                //   ),
                                                // ),
                                                // Container(
                                                //   margin: EdgeInsets.only(
                                                //       top: 10),
                                                //   padding: EdgeInsets.only(
                                                //       top: 10),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .spaceBetween,
                                                //     children: [
                                                //       Text(
                                                //           "Category  : ${snapshot.data!.category} "),
                                                //     ],
                                                //   ),
                                                // ),
                                                // Container(
                                                //   padding: EdgeInsets.only(
                                                //       top: 10),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .spaceBetween,
                                                //     children: [
                                                //       Row(
                                                //         mainAxisSize:
                                                //         MainAxisSize.min,
                                                //         children: [
                                                //           Text("Rating  : "),
                                                //           Container(
                                                //               margin: EdgeInsets
                                                //                   .only(
                                                //                   left:
                                                //                   5),
                                                //               child: rating)
                                                //         ],
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                                // Container(
                                                //   margin: EdgeInsets.only(
                                                //       top: 50),
                                                //   child: Row(
                                                //     children: [
                                                //       RaisedButton(
                                                //         onPressed: () {
                                                //           Navigator.push(
                                                //               context,
                                                //               MaterialPageRoute(
                                                //                   builder:
                                                //                       (context) =>
                                                //                       PostForm(
                                                //                         post: snapshot.data,
                                                //                         onSuccess: () {
                                                //                           getAllPost();
                                                //                         },
                                                //                       )));
                                                //         },
                                                //         color: themeColor,
                                                //         child: Text(
                                                //           "Edit",
                                                //           style: TextStyle(
                                                //               color: Colors
                                                //                   .white),
                                                //         ),
                                                //         shape: RoundedRectangleBorder(
                                                //             borderRadius:
                                                //             BorderRadius
                                                //                 .circular(
                                                //                 20)),
                                                //       ),
                                                //       SizedBox(
                                                //         width: 20,
                                                //       ),
                                                //       RaisedButton(
                                                //         onPressed: () {
                                                //           showDialog(
                                                //               context:
                                                //               context,
                                                //               builder:
                                                //                   (dcontext) {
                                                //                 return AlertDialog(
                                                //                   title: Text(
                                                //                       'Do you want to delete this post " ${snapshot.data!.title} " ?'),
                                                //                   content: Text(
                                                //                       'This will be done permanently and cannot be undo.'),
                                                //                   actions: [
                                                //                     TextButton(
                                                //                       onPressed:
                                                //                           () {
                                                //                         Navigator.pop(
                                                //                             dcontext);
                                                //                       },
                                                //                       child:
                                                //                       Text(
                                                //                         'CANCEL',
                                                //                         style:
                                                //                         TextStyle(color: Color(0xFF6200EE)),
                                                //                       ),
                                                //                     ),
                                                //                     TextButton(
                                                //                       onPressed:
                                                //                           () {
                                                //                         Navigator.pop(
                                                //                             dcontext);
                                                //                         deletePost(snapshot
                                                //                             .data!
                                                //                             .id);
                                                //                       },
                                                //                       child: Text(
                                                //                           'Confirm',
                                                //                           style:
                                                //                           TextStyle(color: Color(0xFF6200EE))),
                                                //                     ),
                                                //                   ],
                                                //                 );
                                                //               });
                                                //         },
                                                //         color: themeColor,
                                                //         child: Text(
                                                //           "Delete",
                                                //           style: TextStyle(
                                                //               color: Colors
                                                //                   .white),
                                                //         ),
                                                //         shape: RoundedRectangleBorder(
                                                //             borderRadius:
                                                //             BorderRadius
                                                //                 .circular(
                                                //                 20)),
                                                //       )
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                ),
                              ],
                            )
                          : Flexible(
                              child: Container(
                                alignment: Alignment.center,
                                child:
                                RaisedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return PostForm(
                                            onSuccess: () {
                                              getAllPost();
                                            },
                                          );
                                        });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  color: themeDarkColor,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                    child: Text(
                                      "+  Create Your First Post Here",
                                      style: TextStyle(color: Colors.white,fontSize: 18),
                                    ),
                                  ),
                                ),
                                // Center(
                                //   child: OutlinedButton(
                                //     onPressed: () {
                                //       showDialog(
                                //           context: context,
                                //           builder: (context) {
                                //             return PostForm(
                                //               onSuccess: () {
                                //                 getAllPost();
                                //               },
                                //             );
                                //           });
                                //       // Navigator.push(
                                //       //     context,
                                //       //     MaterialPageRoute(
                                //       //         builder: (context) => PostForm(
                                //       //               onSuccess: () {
                                //       //                 getAllPost();
                                //       //               },
                                //       //             )));
                                //     },
                                //     style: ButtonStyle(
                                //       shape: MaterialStateProperty.all(
                                //           RoundedRectangleBorder(
                                //               borderRadius:
                                //                   BorderRadius.circular(30.0))),
                                //     ),
                                //     child: Container(
                                //       padding:
                                //           EdgeInsets.only(top: 10, bottom: 10),
                                //       child: Text(
                                //         "Create your first post here",
                                //         style: TextStyle(fontSize: 20),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ),
                            )
                      : Expanded(
                          flex: 1,
                          child: Center(child: spinkit));
                    }),
              )
            ],
          ),
        ));
  }
}
