class LoginRequest {
  final String username;
  final String password;
  final String database;

  LoginRequest({
    required this.username,
    required this.password,
    required this.database,
  });

  Map<String, dynamic> toJson() {
    return {
      'login': username,
      'password': password,
      'db': database,
    };
  }
}
