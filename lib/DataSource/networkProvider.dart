
import 'package:dio/dio.dart';

class NetworkProvider {
  static NetworkProvider _instance = NetworkProvider._internal();
  static Dio _dio= new Dio();
  // static String baseURL ="http://studymama-load-balancer-795957589.ap-southeast-1.elb.amazonaws.com:8080/";
  // static String baseURL ="http://163ce110d423.ngrok.io/";
  static String baseURL ="http://192.168.86.128:8080/";

  ///recommended using with url
  factory NetworkProvider({String url = ""}) {

    if (url != null && url.isNotEmpty) {

      BaseOptions options = new BaseOptions(
        baseUrl: url,
        connectTimeout: 50000,
        receiveTimeout: 50000,
          headers: {
            "Access-Control-Allow-Origin":"*",
            "Access-Control-Allow-Methods": "GET, POST",
          }
      );
      _dio = new Dio(options);

    } else {
      BaseOptions options = new BaseOptions(
        baseUrl: baseURL,
        connectTimeout: 50000,
        receiveTimeout: 50000,
        headers: {
          "Access-Control-Allow-Origin":"*",
          "Access-Control-Allow-Methods": "GET, POST",
        }
      );
      _dio = new Dio(options);
      _dio = new Dio(options);
      _dio.interceptors.add(LogInterceptor());
    }

    return _instance;
  }

  Dio get dio => _dio;

  NetworkProvider._internal() {
    BaseOptions options = new BaseOptions(
      baseUrl: baseURL,
      connectTimeout: 50000,
      receiveTimeout: 100000,
        headers: {
          "Access-Control-Allow-Origin":"*",
          "Access-Control-Allow-Methods": "GET, POST",
        }
    );
    _dio = new Dio(options);
    _dio = new Dio(options);
    dio.interceptors.add(LogInterceptor());
  }

  Dio dioWithAuth(String token){
    BaseOptions options = new BaseOptions(
        baseUrl: baseURL,
        connectTimeout: 50000,
        receiveTimeout: 50000,
        headers: {
          "Access-Control-Allow-Origin":"*",
          "Access-Control-Allow-Methods": "GET, POST",
          "Authorization":"Bearer $token"
        }
    );
    _dio = new Dio(options);
    dio.interceptors.add(LogInterceptor());
    return _dio;
  }
}

