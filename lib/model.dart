import 'package:flutter/foundation.dart';

class PostPage {
  List<Post> posts;
  Pageable? pageable;
  //
  // int maxScore;
  // int totalElements;
  // int totalPages;
  // int numberOfElements;
  // int number;
  // Sort? sort;
  // bool first;
  // bool last;
  // int size;
  // bool empty;

  PostPage(
      this.posts,
          this.pageable,);

  factory PostPage.fromJson(Map<String, dynamic> json) {
   var  posts = <Post>[];

    if (json['content'] != null) {
      json['content'].forEach((v) {
        posts.add(new Post.fromJson(v));
      });
    }

  var pageable = json['pageable'] != null?
   new Pageable.fromJson(json['pageable'])
       : null;
    return PostPage( posts,pageable);
  }
  factory PostPage.fromJsonGeo(Map<String, dynamic> json) {
    var  posts = <Post>[];

    if (json['content']!= null) {
      json['content'].forEach((v) {
        posts.add(new Post.fromJson(v['content'] ));
      });
    }

    var pageable = json['pageable'] != null?
    new Pageable.fromJson(json['pageable'])
        : null;
    return PostPage( posts,pageable);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.posts != null) {
      data['content'] = this.posts.map((v) => v.toJson()).toList();
    }
    if (this.pageable != null) {
      data['pageable'] = this.pageable?.toJson();
    }
    return data;
  }
}

class Post {
  String id;
  String title;
  String description;
  String website;
  Location? location;
  String status;
  int postDt;
  int editedDt;
  String price;
  String category;
  String accountId;
  String score;
  String contact;
  List<Comment> comments;



  Post(
      this.id,
        this.title,
        this.description,
        this.website,
        this.location,
        this.status,
        this.postDt,
        this.editedDt,
        this.price,
        this.category,
        this.accountId,this.score,this.contact,this.comments);

 factory Post.fromJson(Map<String, dynamic> json){

  var id = json['id'],
    title = json['title'],
   description = json['description'],
   website = json['website'],
   location = json['location'] != null?
   new Location.fromJson(json['location'])
       : null,
   status = json['status'].toString(),
   postDt = json['post_dt'],
   editedDt = json['edited_dt'],
   price = json['price'],
   category = json['category'],
    score = json['score'].toString(),
      contact = json['contact'].toString(),
   accountId = json['accountId'].toString();
  List<Comment> comments = [];
  if(json['comments']!=null){
    json['comments'].forEach((v) {
      comments.add(new Comment.fromJson(v));
    });

 }
  return Post(id, title, description, website, location, status, postDt, editedDt, price, category, accountId,score, contact,comments);

 }


  factory Post.fromJsonDB(Map<String, dynamic> json){

    var id = json['postId'].toString(),
        title = json['title'],
        description = json['description'],
        website = json['website'],
        status = json['status'].toString(),
        postDt = json['post_dt'],
        editedDt = json['edited_dt'],
        price = json['price'],
        category = json['category'],
        score = json['score'].toString(),
        contact = json['contact'].toString(),
        accountId = json['accountId'].toString();
      List<Comment> comments = [];


    var gpsX= json['gpsX'] ;
    var gpsY= json['gpsY'];
    var location =Location(gpsX, gpsY);
    if(json['comments']!=null){
      json['comments'].forEach((v) {
        comments.add(new Comment.fromJson(v));
      });

    }
    return Post(id, title, description, website, location, status, postDt, editedDt, price, category, accountId,score, contact,comments);

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postId'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['website'] = this.website;
    if (this.location != null) {
      data['location'] = this.location?.toJson();
      data["gpsX"] =this.location?.lat;
      data["gpsY"] =this.location?.lon;
    }
    data['status'] = this.status;
    data['contact'] = this.contact;
    data['post_dt'] = this.postDt;
    data['edited_dt'] = this.editedDt;
    data['price'] = this.price;
    data['category'] = this.category;
    data['accountId'] = this.accountId;
    return data;
  }
}

class Location {
  double lat;
  double lon;

  Location(this.lat, this.lon);

  Location.fromJson(Map<String, dynamic> json):
        lat = json['lat'],
     lon = json['lon'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}

class Pageable {
  Sort? sort;
  int pageNumber=0;
  int pageSize=0;
  int offset=0;
  bool paged=false;
  bool unpaged=false;

  Pageable(
      this.sort,
         this.pageNumber,
         this.pageSize,
         this.offset,
         this.paged,
         this.unpaged);

  Pageable.fromJson(Map<String, dynamic> json)
      :sort = json['sort'] != null?  new Sort.fromJson(json['sort']):null,
        pageNumber = json['pageNumber'],
        pageSize = json['pageSize'],
        offset = json['offset'],
        paged = json['paged'],
        unpaged = json['unpaged'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sort != null) {
      data['sort'] = this.sort?.toJson();
    }
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['offset'] = this.offset;
    data['paged'] = this.paged;
    data['unpaged'] = this.unpaged;
    return data;
  }
}

class Sort {
  bool sorted;
  bool unsorted;
  bool empty;

  Sort(this.sorted, this.unsorted, this.empty);



  Sort.fromJson(Map<String, dynamic> json):
        sorted = json['sorted'],
  unsorted = json['unsorted'],
  empty = json['empty'];
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    data['empty'] = this.empty;
    return data;
  }
}

class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };
}

class RecommendPost {
  String id;
  String title;
  String description;
  String category;
  String contact;
  String creationDate;

  RecommendPost(
      this.id,
        this.title,
        this.description,
        this.category,
        this.contact,
        this.creationDate);

  RecommendPost.fromJson(Map<String, dynamic> json) :
    id = json['id'].toString(),
    title = json['title'].toString(),
    description = json['description'].toString(),
    category = json['category'].toString(),
    contact = json['contact'].toString(),
    creationDate = json['creationDate'].toString();


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['category'] = this.category;
    data['contact'] = this.contact;
    data['creationDate'] = this.creationDate;
    return data;
  }
}
class Comment {
  int postId;
  int accountId;
  String? accountName;
  int commentId;
  String description;

  Comment(
      this.postId,
        this.accountId,
        this.accountName,
        this.commentId,
        this.description);

  Comment.fromJson(Map<String, dynamic> json):
    postId = json['postId'],
    accountId = json['accountId'],
    accountName = json['accountName'],
    commentId = json['commentId'],
    description = json['description'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['accountId'] = this.accountId;
    data['accountName'] = this.accountName;
    data['commentId'] = this.commentId;
    data['description'] = this.description;
    return data;
  }
}