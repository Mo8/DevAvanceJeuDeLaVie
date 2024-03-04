import 'Config.dart';

class User {

  String username;
  Config config;

  String get userLabel => "${username}_$config";

  User({required this.username, required this.config});


}

