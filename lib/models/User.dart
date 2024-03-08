import 'Config.dart';

class User {

  String username;
  Config config;

  String get userLabel => "${username}_$config";

  User({required this.username, required this.config});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      config: Config.parse(json['config']),
    );
  }


}

