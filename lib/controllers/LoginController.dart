import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/models/Config.dart';
import 'package:jeu_de_la_vie/models/User.dart';
import 'package:jeu_de_la_vie/secret.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:crypto/crypto.dart';

class LoginController extends ChangeNotifier {
  User? user;
  mongo.DbCollection? db;

  LoginController() {
    mongo.Db.create("mongodb+srv://root:$passwordDB@cluster0.4kfm6pu.mongodb.net/jeuDeLaVie?retryWrites=true&w=majority")
        .then((value) async {
      await value.open();
      db = value.collection("users");
      if (await db?.count() == 0 ) {
        await db?.insertAll([
          {"username": "admin", "password": sha256.convert(utf8.encode("admin")).toString(), "config": "23A3D"},
          {"username": "user", "password": sha256.convert(utf8.encode("user")).toString(), "config": "23A3D"},
        ]);
        print("Inserted");
      }
    });
  }

  void login(String login, String password) {
    db?.findOne(mongo.where.eq("username", login)).then((value) {
      if (value != null) {
        if (value["password"] == sha256.convert(utf8.encode(password)).toString()) {
          user = User(username: value["username"], config: Config.parse(value["config"]));
          notifyListeners();
        }
      }
    });
  }
}
