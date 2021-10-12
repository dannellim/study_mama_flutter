class LoginRequest {
  String username;
  String password;

  LoginRequest({  this.username="",   this.password=""});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      username: json['username'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return 'LoginRequest{username: $username, password: $password}';
  }
}

class LoginResponse {
  String token;

  LoginResponse({ required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
    );
  }

  @override
  String toString() {
    return 'LoginResponse{token: $token}';
  }
}
