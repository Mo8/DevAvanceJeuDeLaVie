import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/controllers/LoginController.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Logged as : ${context.watch<LoginController>().user?.username ?? "No user"}"),

          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/jeuDeLaVie");
            },
            icon: const Icon(Icons.gamepad, size: 100,),
          ),
        ],
      )),
    );
  }
}
