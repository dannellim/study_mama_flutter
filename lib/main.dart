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
import 'package:study_mama_flutter/logging_interceptor.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMama',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
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
     var options = Options(
         headers: {
           "Access-Control-Allow-Origin":"*",
           "Access-Control-Allow-Credentials":true
         }

     );
         dio.get("/postService/allPost",queryParameters: {
       "current":0,
       "pageSize":100
     },options: options).then((value)  {
       PostPage  postPage = PostPage.fromJson(value.data);
       posts.add(postPage.posts);
       print("size"+postPage.posts.length.toString());
     }).catchError((onError){
       print("Error error $onError");
     });
  }

  void searchPost(){
    posts.add(null);
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          width: 300,
                          child: TextField(
                            controller: searchTextController,
                            onSubmitted: (text){
                              searchPost();
                            },
                            decoration: InputDecoration(
                              hintText: "Search here by keyword "
                            ),
                          )),
                      ElevatedButton(onPressed: () {
                        searchPost();

                      }, child: Text("Search"),)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          width: 300,
                          child: TextField(
                            controller: geoController,
                            onSubmitted: (text){
                              searchPostNearMe();
                            },
                            decoration: InputDecoration(
                                hintText: "Search by distance (km) "
                            ),
                          )),
                      ElevatedButton(onPressed: () {
                        searchPostNearMe();

                      }, child: Text("Search"),)
                    ],
                  ),
                )
              ],
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
                            return snapshot.hasData?ListView.builder(
                              itemCount: snapshot.hasData?snapshot.data?.length:0,
                              itemBuilder: (BuildContext context, int index) {
                                return PostList(snapshot.data![index],(post){
                                  selectedPost.add(post);
                                });
                              },

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
                    Text("Date  : ${f.format(DateTime.fromMillisecondsSinceEpoch(post.postDt))}"),

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

  PostDetailPage({Key? key, required this.title,required this.post}) {
     fetchPost();
     fetchRecommendation();
  }

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  void fetchPost(){

    dio.get("/post/${post.id}").then((value)  {

      Post post= Post.fromJson(value.data);

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




  @override
  void initState() {
    super.initState();

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
                                      backgroundColor: widget.post.status=="1"?Colors.green:Colors.red,
                                      label: Text(" ${widget.post.status=="1"?"OPEN":"CLOSED"}",style: TextStyle(
                                          color: Colors.white
                                      ),))
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 5,bottom: 5),

                              child: Text("Price  : ${widget.post.price} SGD")),
                          Container(
                              margin: EdgeInsets.only(top: 5,bottom: 10),
                              child: Text("Post Date  : ${f.format(DateTime.fromMillisecondsSinceEpoch(widget.post.postDt))}")),

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
                                                  TextField(),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 5),
                                                    child: TextButton(onPressed: (){
                                                      Navigator.pop(con);
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
                                                         Navigator.pop(con);
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
                                                Text("Anonymous",style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 12
                                                ),),

                                                Container(
                                                    margin: EdgeInsets.only(top: 5,left: 5),
                                                    child: Text(snapshot.data!.comments[index])),
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
                    Flexible(
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
                    )
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
     baseUrl: 'http://studymama-load-balancer-795957589.ap-southeast-1.elb.amazonaws.com:8080/',
     connectTimeout: 5000,
     receiveTimeout: 3000,
     headers: {
       "Access-Control-Allow-Origin":"*",
       "Access-Control-Allow-Credentials":true
     }

   );
   var dio= Dio(options);
   // dio.interceptors.add(LoggingInterceptor());

   return dio;
}// with default Options

