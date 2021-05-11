import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:study_mama_flutter/logging_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:study_mama_flutter/util/color.dart';
import 'package:study_mama_flutter/util/constant.dart';
import 'package:study_mama_flutter/util/rating.dart';

import 'Screen/loginScreen.dart';
import 'Screen/profileDialog.dart';
import 'model.dart';

void main() {
  runApp(MyApp());
}
Map<int, Color> color =
{
  50:Color(0xffE6E6EB),
  100:Color(0xffC1C1CC),
  200:Color(0xff9797AA),
  300:Color(0xff6D6D88),
  400:Color(0xff4E4E6F),
  500:Color(0xff2F2F55),
  600:Color(0xff2A2A4E),
  700:Color(0xff232344),
  800:Color(0xff1D1D3B),
  900:Color(0xff12122A),
};
MaterialColor myColor = MaterialColor(0xFF880E4F, color);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMama',
      theme: ThemeData(
        primaryColor: themeColor,
        fontFamily: 'Montserrat'
      ),
      home: MyHomePage(title: 'Welcome to StudyMama'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dio=getDio();
  BehaviorSubject<List<Post>> posts= BehaviorSubject();
  BehaviorSubject<Post> selectedPost = BehaviorSubject();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController geoController = TextEditingController();
   loc.LocationData? locationData ;

  @override
  void initState()  {
     super.initState();
     // dio.get('http://www.google.com').then((value) => print(value));
         //

     getAllPost();
  }

  void getAllPost(){
    var options = Options(
        headers: {
          "Access-Control-Allow-Origin":"*",
          "Access-Control-Allow-Credentials":true
        }

    );
    dio.get("/postService/allPost",queryParameters: {
      "currentPage":0,
      "pageSize":100
    },options: options).then((value)  {

      PostPage  postPage = PostPage.fromJson(value.data);
      posts.add(postPage.posts);
      print("size"+postPage.posts.length.toString());
      print("post"+postPage.posts[0].toJson().toString());
    }).catchError((onError){
      posts.add([]);
      print("Error error $onError");
    });
  }

  void searchPost(){
    posts.add(null);
    if(searchTextController.value.text.isNotEmpty){
      dio.get("/postService/searchPostByKeywordInTitleDescCategory",queryParameters: {
        "currentPage":0,
        "keyword":searchTextController.value.text,
        "pageSize":100
      }).then((value)  {
        PostPage  postPage = PostPage.fromJson(value.data);
        posts.add(postPage.posts);
      }).catchError((onError){
        print("Error error $onError");
      });
    }else{
      getAllPost();
    }
  }
  void postFormSubmit(Post post){
    dio.post("/postFormSubmit",data: post.toJson()).then((value)  {
      print("Value"+value.toString());
    }).catchError((onError){
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
    if(locationData==null){
      locationData=await _determinePosition();
    }

    print("Location ${locationData?.latitude} ${locationData?.longitude}");
    dio.get("/postService/postNearMe",queryParameters: {
      "currentPage":0,
      "lat":locationData?.latitude,
      "lon":locationData?.longitude,
      "distance":geoController.value.text,
      "unit":"km",
      "pageSize":100
    }).then((value)  {

      PostPage  postPage = PostPage.fromJsonGeo(value.data);
      posts.add(postPage.posts);
      print("size"+postPage.posts.length.toString());

    }).catchError((onError){
      print("Error error $onError");
    });
  }
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        getAllPost();
        }

    }




@override
  Widget build(BuildContext context) {
    final spinkit = SpinKitCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    );
    return Scaffold(

      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20,right: 20),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
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
                      Container(

                        child: StreamBuilder<LoginRequest>(
                            stream: loginData.stream,
                            builder: (context, snapshot) {
                              return Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10,top: 10),
                                    child: InkWell(
                                      onTap: (){

                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => ManagePostsScreen()));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: snapshot.hasData?themeColor:Colors.white),
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: snapshot.hasData?Text("Manage Posts"):Container(),
                                      ),
                                    ),
                                  ),
                                  Container(

                                    margin: EdgeInsets.only(right: 10,top: 10),
                                    child: InkWell(
                                      onTap: (){
                                        if(snapshot.hasData){
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => Profile()));
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: snapshot.hasData?themeColor:Colors.white),
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: snapshot.hasData?InkWell(
                                          onTap: (){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => Profile()));
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(snapshot.data!.username),
                                              Container(
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    child:Icon(
                                                      Icons.person_outline_rounded,
                                                      size: 20,)),
                                              )
                                            ],
                                          ),
                                        ):RaisedButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => Login()));
                                          },
                                          color: themeColor,
                                          child: Text("Sign in",style: TextStyle(color: Colors.white),),),
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                ],
                              );
                            }
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                width: 300,
                                height: 25,
                                child: TextField(
                                  controller: searchTextController,
                                  onSubmitted: (text){
                                    searchPost();
                                  },
                                  textAlign: TextAlign.left,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search here by keyword "
                                  ),
                                )),
                            RaisedButton(onPressed: () {
                              searchPost();

                            },
                              color: themeDarkColor,
                              child: Text("Search",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                width: 300,
                                height: 25,
                                child: TextField(
                                  controller: geoController,

                                  onSubmitted: (text){
                                    searchPostNearMe();
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search here by distance (km) "
                                  ),
                                )),
                            RaisedButton(onPressed: () {
                              searchPostNearMe();

                            },
                              color: themeDarkColor,
                              child: Text("Search",style: TextStyle(
                                color: Colors.white
                              ),),)
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: StreamBuilder<List<Post>>(
                              stream: posts.stream,
                              builder: (context, snapshot) {
                                return snapshot.hasData?snapshot.data!.length>0?ListView.builder(
                                  itemCount: snapshot.hasData?snapshot.data?.length:0,
                                  itemBuilder: (BuildContext context, int index) {
                                    return PostList(snapshot.data![index],(post){
                                      selectedPost.add(post);
                                    });
                                  },

                                ):Container(
                                  child: Center(
                                      child: Text("No data available",style: TextStyle(fontSize: 20),)),
                                ):spinkit;
                              }
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: StreamBuilder<Post>(
                              stream: selectedPost.stream,
                              builder: (context, snapshot) {
                                return snapshot.hasData?PostDetailPage(title: 'Detail',post: snapshot.data!,):Container();
                              }
                            ),
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

        ],
      )

    );

  }
}

class PostList extends StatelessWidget{
  Post post;
  Function(Post) onSelect;

  PostList(this.post,this.onSelect);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final f = new DateFormat('dd-MMMM-yyyy');

    return GestureDetector(
      onTap: (){
        onSelect(post);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),),

              Container(
                  constraints: BoxConstraints(
                      minHeight: 100, minWidth: double.infinity, maxHeight: 400),
                  padding: EdgeInsets.only(top: 10),
                  child: Text(post.description,
                  style: TextStyle(
                    height: 1.5
                  ),)
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price  : ${post.price} SGD"),
                    Text("Date  : ${post.postDt.toString().contains("null")?"Not Available":f.format(DateTime.fromMillisecondsSinceEpoch(post.postDt))}"),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

class PostDetailPage extends StatefulWidget {
  Post post;
  var dio= getDio();
  BehaviorSubject<Post> loadPost = BehaviorSubject();
  BehaviorSubject<List<RecommendPost>> recomendationPost = BehaviorSubject();
  TextEditingController commentController = TextEditingController();

  PostDetailPage({Key? key, required this.title,required this.post}) {
     fetchPost();
     fetchRecommendation();
     print("POST"+post.status);
  }


  void submitComment(Function onSuccess,Function onFail){

    dio.post("/commentSubmit",data: {
      "postId":post.id,
      "accountId":accountID,
      "accountName":"",
      "description":commentController.value.text
    }).then((value)  {
      print("value."+value.toString());
      fetchPost();
      commentController.clear();
      onSuccess();
    }).catchError((onError){
      print("error."+onError.toString());
      onFail();
    });
  }


  final String title;

  void fetchPost(){
    print("POST ID"+post.id);
    dio.get("/post/${post.id}").then((value)  {

      Post post= Post.fromJson(value.data);
      print("POST value"+value.toString());

      loadPost.add(post);

    });
  }
  void fetchRecommendation(){
    print("new select");

    dio.get("/Recommendation").then((value)  {
      print("size"+value.toString());

       List<dynamic> va=value.data as List<dynamic>;

       List<RecommendPost> rp=[];
       va.forEach((element) {
         rp.add(RecommendPost.fromJson(element));
       });
      recomendationPost.add(rp);

    });
  }

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {

  var rate=1.0;

  @override
  void initState() {
    super.initState();

  }

  void submitRating(Function onSuccess,Function onFail){

    print("on submit" +widget.post.id);
    widget.dio.post("/rateSubmit",data: {
      "postId":widget.post.id,
      "accountId":accountID,
      "rateScore":rate,
    }).then((value)  {

      print("Rate"+rate.toString());
      widget.fetchPost();
      rate=0;
      onSuccess();
    }).catchError((onError){
      print("error."+onError.toString());
      onFail();
    });
  }
  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('dd-MMMM-yyyy');

    return Scaffold(

        body: Container(
          padding: EdgeInsets.only(left: 20,right: 50,top: 10),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Flexible(
                        flex: 2,
                        child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(widget.post.title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                          StreamBuilder<Post>(
                            stream: widget.loadPost.stream,

                            builder: (context, snapshot) {
                              var score=0.0;
                              try{
                                score=double.parse(snapshot.data!.score);
                              }catch(Exception){

                              }
                              var rating =  MRatingBar.builder(
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
                                }, onRatingUpdate: (double value) {  },);
                              return Container(
                                  margin: EdgeInsets.only(top: 20,bottom: 5),
                                  child: Row(
                                    children: [
                                      Text("Rating  : "),
                                      GestureDetector(
                                          onTap: (){

                                          },
                                          child: rating)
                                    ],
                                  ));
                            }
                          ),

                          Container(
                              constraints: BoxConstraints(
                                  minHeight: 100, minWidth: double.infinity, maxHeight: 400),
                              padding: EdgeInsets.only(top: 10),
                              child: Text(widget.post.description,
                                style: TextStyle(
                                    height: 1.5
                                ),)
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 20,bottom: 5),
                              child: Text("Category  : ${widget.post.category}")),
                          Container(
                              margin: EdgeInsets.only(top: 5,bottom: 5),
                              child: Text("Websites  : ${widget.post.website}")),
                          Container(
                              margin: EdgeInsets.only(top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Text("Status  :  "),
                                  Chip(
                                      backgroundColor: widget.post.status.contains("1")?Colors.red:Colors.green,
                                      label: Text(" ${widget.post.status.contains("1")?"CLOSED":"ACTIVE"}",style: TextStyle(
                                          color: Colors.white
                                      ),))
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 5,bottom: 5),

                              child: Text("Price  : ${widget.post.price} SGD")),
                          Container(
                              margin: EdgeInsets.only(top: 5,bottom: 10),
                              child: Text("Post Date  : ${widget.post.postDt.toString().contains("null")?"Not Available":f.format(DateTime.fromMillisecondsSinceEpoch(widget.post.postDt))}")),

                        ],
                      ),
                    )),
                    Flexible(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Text("Recommended for You")),
                            Flexible(
                              child: StreamBuilder<List<RecommendPost>>(
                                stream: widget.recomendationPost.stream,
                                builder: (context, snapshot) {
                                  return Container(
                                    child: ListView.builder(
                                      itemCount: snapshot.hasData&&snapshot.data!.isNotEmpty?snapshot.data!.length:0,
                                      itemBuilder: (BuildContext context, int index) {
                                        return snapshot.hasData?Container(
                                            margin: EdgeInsets.only(top: 5,bottom: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                            ),
                                            padding: EdgeInsets.only(top: 5,left: 10,bottom: 5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(snapshot.data![index].title,style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12
                                                ),),
                                                Container(
                                                    margin: EdgeInsets.only(top: 5,left: 5),
                                                    child: Text(snapshot.data![index].description)),
                                              ],
                                            )):Container();
                                      },

                                    ),
                                  );
                                }
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children:[
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 50,
                                padding: EdgeInsets.only(left: 10),
                                color: Colors.white,
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 50,
                                    color: Colors.white,
                                    child: FractionallySizedBox(
                                      widthFactor: 1.0, // width w.r.t to parent
                                      heightFactor: 1.0,
                                      child: TextButton(
                                        onPressed: () {

                                          showDialog(context: context, builder: (con){
                                            return AlertDialog(
                                              title: Text("Comment"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: widget.commentController,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 5),
                                                    child: TextButton(onPressed: (){

                                                      widget.submitComment((){
                                                        Navigator.pop(con);

                                                      },(){

                                                      });
                                                    },
                                                    child: Text("Comment now"),))

                                                ],
                                              ),
                                            );
                                          });

                                        },
                                        child: Text("Comment"),),
                                    )
                                )
                              ),
                            ),
                              Container(
                                color: Colors.black12,
                                width: 2,
                              ),
                              Expanded(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 50,
                                    color: Colors.white,
                                    child: FractionallySizedBox(
                                      widthFactor: 1.0, // width w.r.t to parent
                                      heightFactor: 1.0,
                                      child: TextButton(
                                        onPressed: () {

                                          var rating =  RatingBar.builder(
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
                                                rate=rating;
                                              },);
                                          showDialog(context: context, builder: (con){
                                            return AlertDialog(
                                                title: Text("Rating"),
                                                 content: Column(
                                                   mainAxisSize: MainAxisSize.min,
                                                   children: [
                                                     rating,
                                                     Container(
                                                       margin: EdgeInsets.only(top: 5),
                                                       child: TextButton(onPressed: (){
                                                         submitRating((){

                                                           Navigator.pop(con);

                                                         },(){
                                                           Navigator.pop(con);

                                                         });
                                                       }, child: Text("Rate now")),
                                                     )
                                                   ],
                                                 ),
                                            );
                                          });

                                        },
                                      child: Text("Rate"),),
                                    )
                                ),
                              )
                            ]
                          ),
                          Flexible(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(left: 10,top: 20),
                              child: StreamBuilder<Post>(
                                  stream: widget.loadPost.stream,
                                  builder: (context, snapshot) {
                                    return ListView.builder(
                                      itemCount: snapshot.hasData?snapshot.data!.comments.length:0,
                                      itemBuilder: (BuildContext context, int index) {
                                        var data=snapshot.data!.comments[index].accountName;
                                        var accName= (data!=null&&data.isNotEmpty)?snapshot.data!.comments[index].accountName:"anonymous";
                                        return Container(
                                            margin: EdgeInsets.only(top: 5,bottom: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            ),
                                            padding: EdgeInsets.only(top: 5,left: 10,bottom: 5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(accName!,
                                                  style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 12
                                                ),),

                                                Container(
                                                    margin: EdgeInsets.only(top: 5,left: 5),
                                                    child: Text(snapshot.data!.comments[index].description)),
                                              ],
                                            ));
                                      },

                                    );
                                  }
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                   widget.post.location!=null? Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10,top: 50,left: 20),
                  child: FlutterMap(

                    options: MapOptions(
                      center: LatLng(1.3368959,103.6978811),
                      zoom: 12.0,
                    ),
                    layers: [
                      TileLayerOptions(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c']
                      ),
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(widget.post.location?.lat,widget.post.location?.lon),
                            builder: (ctx) =>
                                Container(
                                  child: Icon(Icons.location_on,color: Colors.blue,),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ):Container()
                  ],
                ),

              ),

            ],
          ),
        )

    );

  }


}

Dio getDio(){
   var options = BaseOptions(
     // baseUrl: 'http://localhost:8080/',
     // baseUrl: 'http://studymama-load-balancer-795957589.ap-southeast-1.elb.amazonaws.com:8080',
     baseUrl: 'http://studymama-load-balancer-795957589.ap-southeast-1.elb.amazonaws.com:8080',
     connectTimeout: 5000,
     receiveTimeout: 3000,
     headers: {
       "Access-Control-Allow-Origin":"*",
       "Access-Control-Allow-Credentials":true,
       "Access-Control-Allow-Methods":"GET,POST,PUT,DELETE"
     }

   );
   var dio= Dio(options);
   // dio.interceptors.add(LoggingInterceptor());

   return dio;
}// with default Options
