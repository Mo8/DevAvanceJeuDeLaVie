
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/models/User.dart';
import 'package:http/http.dart' as http;

class LoginController extends ChangeNotifier {
  User? user;
  static const apiUrl = String.fromEnvironment("apiUrl");

  Future<void> login(String login, String password) async {
    final response  = await http.post(Uri.parse(apiUrl + "/login"), body: jsonEncode({"username": login, "password": password}), headers: {"content-type": "application/json"});
    print(response.body);
      if (response.statusCode == 200) {
        user = User.fromJson(jsonDecode(response.body));
        notifyListeners();
      }
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}
