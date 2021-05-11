import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:rxdart/rxdart.dart';
import 'package:study_mama_flutter/Model/loginModel.dart';
import 'package:study_mama_flutter/Screen/manage_post_screen.dart';
import 'package:study_mama_flutter/util/color.dart';
import 'package:study_mama_flutter/util/constant.dart';
import 'package:study_mama_flutter/util/rating.dart';
import 'package:study_mama_flutter/util/widget.dart';

import 'Screen/loginScreen.dart';
import 'Screen/profileDialog.dart';
import 'model.dart';

void main() {
  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color(0xffE6E6EB),
  100: Color(0xffC1C1CC),
  200: Color(0xff9797AA),
  300: Color(0xff6D6D88),
  400: Color(0xff4E4E6F),
  500: Color(0xff2F2F55),
  600: Color(0xff2A2A4E),
  700: Color(0xff232344),
  800: Color(0xff1D1D3B),
  900: Color(0xff12122A),
};
MaterialColor myColor = MaterialColor(0xFF880E4F, color);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMama',
      theme: ThemeData(primaryColor: themeColor, fontFamily: 'Montserrat'),
      home: MyHomePage(title: 'Welcome to StudyMama'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dio = getDio();
  BehaviorSubject<List<Post>> posts = BehaviorSubject();
  BehaviorSubject<Post> selectedPost = BehaviorSubject();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController geoController = TextEditingController();
  loc.LocationData? locationData;
  final GlobalKey<FormState> _postFormKey = GlobalKey<FormState>();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController webTextController = TextEditingController();
  TextEditingController locTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController contactTextController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  BehaviorSubject<List<RecommendPost>> recomendationPost = BehaviorSubject();

  late AlertDialog postFormDialog;

  @override
  void initState() {
    super.initState();
    postFormDialog = AlertDialog(
      title: Text("Create New Post"),
      content: Form(
        key: _postFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleTextController,
              validator: (val) {
                print("title txt" + titleTextController.value.text);
                return val!.isEmpty ? "Enter Title here" : null;
              },
              decoration: InputDecoration(
                labelText: 'Post Title',
                labelStyle: TextStyle(
                  color: Color(0xFF6200EE),
                ),
                helperText: 'Enter post title here',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
            ),
            TextFormField(
              controller: descTextController,
              validator: (val) {
                return val!.isEmpty ? "Enter description here" : null;
              },
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(
                  color: Color(0xFF6200EE),
                ),
                helperText: 'Enter description here',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
            ),
            TextFormField(
              controller: priceTextController,
              validator: (val) {
                return val!.isEmpty ? "Enter price here" : null;
              },
              decoration: InputDecoration(
                labelText: 'Price in SGD',
                labelStyle: TextStyle(
                  color: Color(0xFF6200EE),
                ),
                helperText: 'Enter price here',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
            ),
            TextFormField(
              controller: categoryController,
              validator: (val) {
                return val!.isEmpty ? "Enter Category here" : null;
              },
              decoration: InputDecoration(
                labelText: 'Category ',
                labelStyle: TextStyle(
                  color: Color(0xFF6200EE),
                ),
                helperText: 'Enter category  here',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
            ),
            TextFormField(
              controller: contactTextController,
              validator: (val) {
                return val!.isEmpty ? "Enter Contact Number here" : null;
              },
              decoration: InputDecoration(
                labelText: 'Contact Number ',
                labelStyle: TextStyle(
                  color: Color(0xFF6200EE),
                ),
                helperText: 'Enter contact number  here',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
            ),
            TextFormField(
              controller: webTextController,
              decoration: InputDecoration(
                labelText: 'website',
                labelStyle: TextStyle(
                  color: Color(0xFF6200EE),
                ),
                helperText: 'Enter website',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
            ),
            TextFormField(
              controller: locTextController,
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: "1.3369103,103.697898",
                labelStyle: TextStyle(
                  color: Color(0xFF6200EE),
                ),
                helperText: 'Enter locations here',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: TextButton(
                  onPressed: () {
                    if (_postFormKey.currentState!.validate()) {
                      var title = titleTextController.value.text;
                      var desc = descTextController.value.text;
                      var category = categoryController.value.text;
                      var contact = contactTextController.value.text;
                      var price = priceTextController.value.text;
                      var web = webTextController.value.text;
                      var loc = locTextController.value.text;
                      var locCation = loc != null && loc.split(",").length == 2
                          ? {
                        "lat": double.parse(loc.split(",")[0]),
                        "lon": double.parse(loc.split(",")[1]),
                      }
                          : {"": ""};
                      var map = {
                        "title": title,
                        "description": desc,
                        "website": web,
                        "location": locCation,
                        "category": category,
                        "accountId": accountID,
                        "status": "0",
                        "contact": contact,
                        "price": price,
                      };

                      // }
                      Post post = Post.fromJson(map);
                      postFormSubmit(post);

                      Navigator.pop(context);
                      final snackBar =
                      SnackBar(content: Text('Successfully created'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text("submit"),
                ))
          ],
        ),
      ),
    );
    // dio.get('http://www.google.com').then((value) => print(value));
    //

    getAllPost();
    fetchRecommendation();
  }

  void getAllPost() {
    var options = Options(headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": true
    });
    dio
        .get("/postService/allPost",
        queryParameters: {"currentPage": 0, "pageSize": 100},
        options: options)
        .then((value) {
      PostPage postPage = PostPage.fromJson(value.data);
      posts.add(postPage.posts);
      print("size" + postPage.posts.length.toString());
      print("post" + postPage.posts[0].toJson().toString());
    }).catchError((onError) {
      print("Error error $onError");
    });

  }

  void searchPost() {
    posts.add(null);
    if (searchTextController.value.text.isNotEmpty) {
      dio.get("/postService/searchPostByKeywordInTitleDescCategory",
          queryParameters: {
            "currentPage": 0,
            "keyword": searchTextController.value.text,
            "pageSize": 100
          }).then((value) {
        PostPage postPage = PostPage.fromJson(value.data);
        posts.add(postPage.posts);
      }).catchError((onError) {
        print("Error error $onError");
      });
    } else {
      getAllPost();
    }
  }

  void postFormSubmit(Post post) {
    dio.post("/postFormSubmit", data: post.toJson()).then((value) {
      print("Value" + value.toString());
    }).catchError((onError) {
      print("Error error $onError");
    });
  }

  Future<loc.LocationData?> _determinePosition() async {
    loc.Location location = loc.Location();

    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }
    print("lcaion ");

    _locationData = await location.getLocation();
    print("after lcaion ");

    return _locationData;
  }

  Future<void> searchPostNearMe() async {
    posts.add(null);
    if (locationData == null) {
      locationData = await _determinePosition();
    }

    print("Location ${locationData?.latitude} ${locationData?.longitude}");
    dio.get("/postService/postNearMe", queryParameters: {
      "currentPage": 0,
      "lat": locationData?.latitude,
      "lon": locationData?.longitude,
      "distance": geoController.value.text,
      "unit": "km",
      "pageSize": 100
    }).then((value) {
      PostPage postPage = PostPage.fromJsonGeo(value.data);
      posts.add(postPage.posts);
      print("size" + postPage.posts.length.toString());
    }).catchError((onError) {
      print("Error error $onError");
    });
  }

  void fetchRecommendation() {
    print("new select");

    dio.get("/Recommendation").then((value) {
      print("size" + value.toString());

      List<dynamic> va = value.data as List<dynamic>;

      List<RecommendPost> rp = [];
      va.forEach((element) {
        rp.add(RecommendPost.fromJson(element));
      });
      recomendationPost.add(rp);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 18, 30, 20),
                    child: StreamBuilder<LoginRequest>(
                        stream: loginData,
                        builder: (context, snapshot) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                              Spacer(),
                              snapshot.hasData
                                  ? Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManagePostsScreen()));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5, 10, 5, 10),
                                      child: Text(
                                        "MANAGE POST(s)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: themeDarkColor),
                                      ),
                                    )),
                              )
                                  : Container(),
                              snapshot.hasData
                                  ? Container()
                                  : RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(5)),
                                color: themeDarkColor,
                                child: Padding(
                                  padding:
                                  EdgeInsets.fromLTRB(8, 9, 8, 10),
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              snapshot.hasData
                                  ? RaisedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Profile();
                                      });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(5)),
                                color: themeDarkColor,
                                child: Padding(
                                  padding:
                                  EdgeInsets.fromLTRB(3, 8, 8, 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        snapshot.data!.username,
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  : Container(),
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    runSpacing: 10,
                    spacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                      ),

                      Text("Search Your Post : "),
                      getSearchTextField(
                          "By Keyword", searchTextController, searchPost),
                      getSearchTextField(
                          "By Distance (km)", geoController, searchPostNearMe),
                    ],
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(30, 50, 15, 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
//                           Container(width: 250,child: Column(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Text("Search Your Post"),
//                               SizedBox(
//                                 height: 13,
//                               ),
//                               getSearchTextField("By Keyword",searchTextController,searchPost),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               getSearchTextField("By Distance (km)",geoController,searchPostNearMe),
//                               // TextField(
//                               //   controller: searchTextController,
//                               //   onSubmitted: (text) {
//                               //     searchPost();
//                               //   },
//                               //   textAlign: TextAlign.left,
//                               //   textAlignVertical: TextAlignVertical.center,
//                               //   decoration: InputDecoration(
//                               //       border: InputBorder.none,
//                               //       hintText: "By keyword "),
//                               // )
//                             ],
//                           ),),
// SizedBox(width: 15,),
                          Expanded(
                            flex: 1,
                            child: StreamBuilder<List<Post>>(
                                stream: posts.stream,
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? snapshot.data!.length > 0
                                      ? SingleChildScrollView(
                                    child: Wrap(
                                      runSpacing: 10,
                                      spacing: 10,
                                      alignment: WrapAlignment.center,
                                      children: snapshot.data!
                                          .map((e) => PostList(
                                          e,
                                              (post){
                                                selectedPost
                                                    .add(post);
                                                fetchRecommendation();
                                              }))
                                          .toList(),
                                    ),
                                  )
                                      : Center(
                                    child: Text(
                                      "No Post",
                                      style: TextStyle(
                                          color: Colors.grey),
                                    ),
                                  )
                                      : Center(child: spinkit);
                                }),
                          ),
                          // Flexible(
                          //   flex: 1,
                          //   child: Container(
                          //     child: StreamBuilder<List<Post>>(
                          //         stream: posts.stream,
                          //         builder: (context, snapshot) {
                          //           return snapshot.hasData
                          //               ? ListView.builder(
                          //                   itemCount: snapshot.hasData
                          //                       ? snapshot.data?.length
                          //                       : 0,
                          //                   itemBuilder: (BuildContext context,
                          //                       int index) {
                          //                     return PostList(
                          //                         snapshot.data![index],
                          //                         (post) {
                          //                       selectedPost.add(post);
                          //                     });
                          //                   },
                          //                 )
                          //               : spinkit;
                          //         }),
                          //   ),
                          // ),

                          SizedBox(
                            width: 10,
                          ),
                          // Container(
                          //   width: 400,
                          //   child: PostDetailPage(
                          //     title: 'Detail',
                          //     post: Post("1","title","description","www.title.com",null,"1",1,1,"200 SGD","category","122","464","+959656245",[]),
                          //   ),
                          // ),
                          StreamBuilder<Post>(
                              stream: selectedPost.stream,
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? PostDetailPage(
                                  title: 'Detail',
                                  post: snapshot.data!,
                                )
                                    : Container();
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 280,
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("Recommended for You"),
                                SizedBox(
                                  height: 13,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: StreamBuilder<List<RecommendPost>>(
                                      stream: recomendationPost.stream,
                                      builder: (context, snapshot) {
                                        return snapshot.hasData
                                            ? SingleChildScrollView(
                                          child: Column(
                                              children: snapshot.data!
                                                  .map(
                                                    (e) =>
                                                    getRecommendedItemView(
                                                        e),
                                              )
                                                  .toList()),
                                        )
                                            : Padding(
                                          padding:
                                          EdgeInsets.only(top: 50),
                                          child: Text(
                                            "No Recommended Post",
                                            style: TextStyle(
                                                color: Colors.grey),
                                          ),
                                        );
                                      }),
                                ),
                                // SizedBox(
                                //   height: 13,
                                // ),
                                // RaisedButton(
                                //     color: backgroundColor,
                                //     shape: RoundedRectangleBorder(
                                //         side: BorderSide(
                                //             color: themeColor, width: 1),
                                //         borderRadius: BorderRadius.circular(5)),
                                //     onPressed: () {},
                                //     child: Padding(
                                //       padding: EdgeInsets.all(10),
                                //       child: Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: [
                                //           Icon(
                                //             Icons.logout,
                                //             color: themeColor,
                                //           ),
                                //           SizedBox(
                                //             width: 8,
                                //           ),
                                //           Text(
                                //             "Sign Out",
                                //             style: TextStyle(
                                //                 fontSize: 15,
                                //                 fontWeight: FontWeight.w800,
                                //                 color: themeColor),
                                //           )
                                //         ],
                                //       ),
                                //     ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Positioned(
            //   right: 10,
            //   top: 40,
            //   child: StreamBuilder<LoginRequest>(
            //     stream: loginData.stream,
            //     builder: (context, snapshot) {
            //       return Container(
            //         margin: EdgeInsets.only(right: 10),
            //         padding: EdgeInsets.all(10),
            //         alignment: Alignment.bottomRight,
            //         decoration: BoxDecoration(
            //             border: Border.all(color: snapshot.hasData?themeColor:Colors.white),
            //             borderRadius: BorderRadius.all(Radius.circular(20))
            //         ),
            //         child: snapshot.hasData?GestureDetector(
            //           onTap: (){
            //             Navigator.push(context,
            //                 MaterialPageRoute(builder: (context) => Profile()));
            //           },
            //           child: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Text(snapshot.data!.username),
            //               Container(
            //                child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(8.0),
            //                   child:Icon(
            //                  Icons.person_outline_rounded,
            //                  size: 20,)),
            //                 )
            //             ],
            //           ),
            //         ):RaisedButton(
            //           onPressed: () {
            //             Navigator.push(context,
            //                 MaterialPageRoute(builder: (context) => Login()));
            //           },
            //           color: themeColor,
            //           child: Text("Sign in",style: TextStyle(color: Colors.white),),),
            //       );
            //     }
            //   ),
            // ),
            // Positioned(
            //   right: 10,
            //   bottom: 20,
            //   child: FloatingActionButton(
            //     backgroundColor: const Color(0xff03dac6),
            //     foregroundColor: Colors.black,
            //     onPressed: () {
            //       showDialog(
            //           context: context,
            //           builder: (con) {
            //             return postFormDialog;
            //           });
            //     },
            //     child: Icon(Icons.add),
            //   ),
            // )
          ],
        ));
  }
}

Widget getRecommendedItemView(RecommendPost post) {
  return Card(
    margin: EdgeInsets.only(bottom: 7),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            post.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          SizedBox(
            height: 3,
          ),
          Text(post.description)
        ],
      ),
    ),
  );
}

class PostList extends StatelessWidget {
  Post post;
  Function(Post) onSelect;

  PostList(this.post, this.onSelect);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final f = new DateFormat('dd-MMMM-yyyy');

    return GestureDetector(
      onTap: () {
        onSelect(post);
      },
      child: Card(
        child: Stack(
          children: [
            Positioned(
                top: 60,
                right: 20,
                child: Text(post.status.contains("1") ? "CLOSED" : "ACTIVE",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: post.status.contains("1")
                            ? Colors.redAccent
                            : Colors.lightGreen,
                        fontSize: 10))),
            Container(
                width: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(13),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5))),
                      child: Text(
                        post.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Image.asset(
                      'assets/images/post.png',
                      width: 28,
                      height: 28,
                      color: themeColor,
                    ),
                    Container(
                      constraints: BoxConstraints(minHeight: 50),
                      padding: EdgeInsets.fromLTRB(10, 12, 10, 10),
                      alignment: Alignment.center,
                      child: Text(
                        post.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Text(
                      "Post Date : ${post.postDt.toString().contains("null") ? "Not Available" : f.format(DateTime.fromMillisecondsSinceEpoch(post.postDt))}",
                      style: TextStyle(fontSize: 11),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Divider(
                      height: 1,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "\$ ${post.price} SGD",
                      style:
                      TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class PostDetailPage extends StatefulWidget {
  Post post;
  var dio = getDio();
  BehaviorSubject<Post> loadPost = BehaviorSubject();
  TextEditingController commentController = TextEditingController();

  PostDetailPage({Key? key, required this.title, required this.post}) {
    fetchPost();
    // fetchRecommendation();
    print("POST" + post.status);
  }

  void submitComment(Function onSuccess, Function onFail) {
    dio.post("/commentSubmit", data: {
      "postId": post.id,
      "accountId": accountID,
      "accountName": loginAccName,
      "description": commentController.value.text
    }).then((value) {
      print("value." + value.toString());
      fetchPost();
      commentController.clear();
      onSuccess();
    }).catchError((onError) {
      print("error." + onError.toString());
      onFail();
    });
  }

  final String title;

  void fetchPost() {
    print("POST ID" + post.id);
    dio.get("/post/${post.id}").then((value) {
      Post post = Post.fromJson(value.data);
      print("POST value" + value.toString());

      loadPost.add(post);
    });
  }

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  var rate = 1.0;

  @override
  void initState() {
    super.initState();
  }

  void submitRating(Function onSuccess, Function onFail) {
    print("on submit" + widget.post.id);
    widget.dio.post("/rateSubmit", data: {
      "postId": widget.post.id,
      "accountId": accountID,
      "accountName":loginAccName,
      "rateScore": rate,
    }).then((value) {
      print("Rate" + rate.toString());
      widget.fetchPost();
      rate = 0;
      onSuccess();
    }).catchError((onError) {
      print("error." + onError.toString());
      onFail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('dd-MMMM-yyyy');

    return Container(
      padding: EdgeInsets.only(bottom: 12),
      width: 400,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child: Text(
                widget.post.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: themeColor),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  minHeight: 40,
                ),
                child: Text(
                  widget.post.description,
                  style: TextStyle(height: 1.5),
                )),
            SizedBox(
              height: 15,
            ),
            StreamBuilder<Post>(
                stream: widget.loadPost.stream,
                builder: (context, snapshot) {
                  var score = 0.0;
                  try {
                    score = double.parse(snapshot.data!.score);
                  } catch (Exception) {}
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
                  return Container(
                      margin: EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Rating  : "),
                          GestureDetector(onTap: () {}, child: rating)
                        ],
                      ));
                }),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 5),
                child: Text("Category  : ${widget.post.category}")),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 5),
                child: Text("Websites  : ${widget.post.website}")),
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
                          color: widget.post.status.contains("1")
                              ? Colors.redAccent
                              : Colors.lightGreen),
                      child: Text(
                          " ${widget.post.status.contains("1") ? "CLOSED" : "ACTIVE"}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 5),
                child: Text("Price  : ${widget.post.price} SGD")),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 10),
                child: Text(
                    "Post Date  : ${widget.post.postDt.toString().contains("null") ? "Not Available" : f.format(DateTime.fromMillisecondsSinceEpoch(widget.post.postDt))}")),

            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Divider(height: 1,),
            ),

            widget.post.location != null
                ?
            Container(
              height: 150,
              padding:
              EdgeInsets.fromLTRB(20,15,20,10),
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(1.3368959, 103.6978811),
                  zoom: 12.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(widget.post.location?.lat,
                            widget.post.location?.lon),
                        builder: (ctx) => Container(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
                : Container(),

            SizedBox(
              height: 5,
            ),

            Row(
              children: [
                SizedBox(width: 15,),
                Expanded(
                  flex :1,
                  child: RaisedButton(
                    onPressed: () {

                      showDialog(
                          context: context,
                          builder: (con) {
                            return AlertDialog(
                              title: Text("Comment"),
                              content: Column(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: widget
                                        .commentController,
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 5),
                                      child: TextButton(
                                        onPressed: () {
                                          widget
                                              .submitComment(
                                                  () {
                                                Navigator.pop(
                                                    con);
                                              }, () {});
                                        },
                                        child: Text(
                                            "Comment now"),
                                      ))
                                ],
                              ),
                            );
                          });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5)),
                    padding: EdgeInsets.fromLTRB(10, 18, 10, 20),
                    color: themeDarkColor,
                    child: Text(
                      "Comment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),),
                SizedBox(width: 10,),
                Expanded(
                  flex :1,
                  child: RaisedButton(
                    onPressed: () {
                      var rating = RatingBar.builder(
                        initialRating: 3,
                        itemCount: 5,
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
                        onRatingUpdate: (rating) {
                          print(rating);
                          rate = rating;
                        },
                      );
                      showDialog(
                          context: context,
                          builder: (con) {
                            return AlertDialog(
                              title: Text("Rating"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  rating,
                                  Container(
                                    margin:
                                    EdgeInsets.only(top: 5),
                                    child: TextButton(
                                        onPressed: () {
                                          submitRating(() {
                                            Navigator.pop(con);
                                          }, () {
                                            Navigator.pop(con);
                                          });
                                        },
                                        child: Text("Rate now")),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5)),
                    padding: EdgeInsets.fromLTRB(10, 18, 10, 20),
                    color: themeDarkColor,
                    child: Text(
                      "Rate",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),),
                SizedBox(width: 15,),
              ],
            ),


            SizedBox(
              height: 10,
            ),

            StreamBuilder<Post>(
                stream: widget.loadPost.stream,
                builder: (context, snapshot) {
                  return Container(
                    height: snapshot.data==null? 0:
                    (snapshot.data!.comments.length * 57),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.hasData
                          ? snapshot.data!.comments.length
                          : 0,
                      itemBuilder:
                          (BuildContext context, int index) {
                        var data = snapshot
                            .data!.comments[index].accountName;
                        var accName =
                        (data != null && data.isNotEmpty)
                            ? snapshot.data!.comments[index]
                            .accountName
                            : "anonymous";
                        return Container(
                            height: 47,
                            margin:
                            EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                color: themeColor.withAlpha(40),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))),
                            padding: EdgeInsets.only(
                                top: 5, left: 10, bottom: 5),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  accName!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 5, left: 5),
                                    child: Text(snapshot
                                        .data!
                                        .comments[index]
                                        .description)),
                              ],
                            ));
                      },
                    ),
                  );
                }),

            // Flexible(
            //   flex: 1,
            //   child: Row(
            //     children: [
            //       Flexible(
            //         flex: 2,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Row(children: [
            //               Expanded(
            //                 child: Container(
            //                     alignment: Alignment.centerLeft,
            //                     height: 50,
            //                     padding: EdgeInsets.only(left: 10),
            //                     color: Colors.white,
            //                     child: Container(
            //                         alignment: Alignment.centerLeft,
            //                         height: 50,
            //                         color: Colors.white,
            //                         child: FractionallySizedBox(
            //                           widthFactor: 1.0, // width w.r.t to parent
            //                           heightFactor: 1.0,
            //                           child: TextButton(
            //                             onPressed: () {
            //                               showDialog(
            //                                   context: context,
            //                                   builder: (con) {
            //                                     return AlertDialog(
            //                                       title: Text("Comment"),
            //                                       content: Column(
            //                                         mainAxisSize:
            //                                             MainAxisSize.min,
            //                                         children: [
            //                                           TextField(
            //                                             controller: widget
            //                                                 .commentController,
            //                                           ),
            //                                           Container(
            //                                               margin: EdgeInsets.only(
            //                                                   top: 5),
            //                                               child: TextButton(
            //                                                 onPressed: () {
            //                                                   widget
            //                                                       .submitComment(
            //                                                           () {
            //                                                     Navigator.pop(
            //                                                         con);
            //                                                   }, () {});
            //                                                 },
            //                                                 child: Text(
            //                                                     "Comment now"),
            //                                               ))
            //                                         ],
            //                                       ),
            //                                     );
            //                                   });
            //                             },
            //                             child: Text("Comment"),
            //                           ),
            //                         ))),
            //               ),
            //               Container(
            //                 color: Colors.black12,
            //                 width: 2,
            //               ),
            //               Expanded(
            //                 child: Container(
            //                     alignment: Alignment.centerLeft,
            //                     height: 50,
            //                     color: Colors.white,
            //                     child: FractionallySizedBox(
            //                       widthFactor: 1.0, // width w.r.t to parent
            //                       heightFactor: 1.0,
            //                       child: TextButton(
            //                         onPressed: () {
            //                           var rating = RatingBar.builder(
            //                             initialRating: 3,
            //                             itemCount: 5,
            //                             itemBuilder: (context, index) {
            //                               switch (index) {
            //                                 case 0:
            //                                   return Icon(
            //                                     Icons.sentiment_very_dissatisfied,
            //                                     color: Colors.red,
            //                                   );
            //                                 case 1:
            //                                   return Icon(
            //                                     Icons.sentiment_dissatisfied,
            //                                     color: Colors.redAccent,
            //                                   );
            //                                 case 2:
            //                                   return Icon(
            //                                     Icons.sentiment_neutral,
            //                                     color: Colors.amber,
            //                                   );
            //                                 case 3:
            //                                   return Icon(
            //                                     Icons.sentiment_satisfied,
            //                                     color: Colors.lightGreen,
            //                                   );
            //                                 case 4:
            //                                   return Icon(
            //                                     Icons.sentiment_very_satisfied,
            //                                     color: Colors.green,
            //                                   );
            //                                 default:
            //                                   return Icon(Icons.add);
            //                               }
            //                             },
            //                             onRatingUpdate: (rating) {
            //                               print(rating);
            //                               rate = rating;
            //                             },
            //                           );
            //                           showDialog(
            //                               context: context,
            //                               builder: (con) {
            //                                 return AlertDialog(
            //                                   title: Text("Rating"),
            //                                   content: Column(
            //                                     mainAxisSize: MainAxisSize.min,
            //                                     children: [
            //                                       rating,
            //                                       Container(
            //                                         margin:
            //                                             EdgeInsets.only(top: 5),
            //                                         child: TextButton(
            //                                             onPressed: () {
            //                                               submitRating(() {
            //                                                 Navigator.pop(con);
            //                                               }, () {
            //                                                 Navigator.pop(con);
            //                                               });
            //                                             },
            //                                             child: Text("Rate now")),
            //                                       )
            //                                     ],
            //                                   ),
            //                                 );
            //                               });
            //                         },
            //                         child: Text("Rate"),
            //                       ),
            //                     )),
            //               )
            //             ]),
            //             Flexible(
            //               flex: 2,
            //               child: Container(
            //                 padding: EdgeInsets.only(left: 10, top: 20),
            //                 child: StreamBuilder<Post>(
            //                     stream: widget.loadPost.stream,
            //                     builder: (context, snapshot) {
            //                       return ListView.builder(
            //                         itemCount: snapshot.hasData
            //                             ? snapshot.data!.comments.length
            //                             : 0,
            //                         itemBuilder:
            //                             (BuildContext context, int index) {
            //                           var data = snapshot
            //                               .data!.comments[index].accountName;
            //                           var accName =
            //                               (data != null && data.isNotEmpty)
            //                                   ? snapshot.data!.comments[index]
            //                                       .accountName
            //                                   : "anonymous";
            //                           return Container(
            //                               margin:
            //                                   EdgeInsets.only(top: 5, bottom: 5),
            //                               decoration: BoxDecoration(
            //                                   color: Colors.black12,
            //                                   borderRadius: BorderRadius.all(
            //                                       Radius.circular(20))),
            //                               padding: EdgeInsets.only(
            //                                   top: 5, left: 10, bottom: 5),
            //                               child: Column(
            //                                 crossAxisAlignment:
            //                                     CrossAxisAlignment.start,
            //                                 mainAxisSize: MainAxisSize.min,
            //                                 children: [
            //                                   Text(
            //                                     accName!,
            //                                     style: TextStyle(
            //                                         fontWeight: FontWeight.bold,
            //                                         fontStyle: FontStyle.italic,
            //                                         fontSize: 12),
            //                                   ),
            //                                   Container(
            //                                       margin: EdgeInsets.only(
            //                                           top: 5, left: 5),
            //                                       child: Text(snapshot
            //                                           .data!
            //                                           .comments[index]
            //                                           .description)),
            //                                 ],
            //                               ));
            //                         },
            //                       );
            //                     }),
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

Dio getDio() {
  var options = BaseOptions(
    // baseUrl: 'http://localhost:8080/',
      baseUrl:
      'http://studymama-load-balancer-795957589.ap-southeast-1.elb.amazonaws.com:8080',
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": true,
        "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE"
      });
  var dio = Dio(options);
  // dio.interceptors.add(LoggingInterceptor());

  return dio;
} // with default Options
