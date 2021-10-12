class LoginRegister {
  String username;
  String password;
  String role;

  LoginRegister({required this.username, required this.password,required  this.role});

  factory LoginRegister.fromJson(Map<String, dynamic> json) {
    return LoginRegister(
      username: json['username'],
      password: json['password'],
      role: json['role'],
    );
  }

  @override
  String toString() {
    return 'LoginRegister{username: $username, password: $password, role: $role}';
  }
}
