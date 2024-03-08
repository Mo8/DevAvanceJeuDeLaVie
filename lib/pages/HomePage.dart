import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/controllers/LoginController.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          if (context.watch<LoginController>().user != null)
            TextButton.icon(
              label: const Text("Se déconnecter"),
              onPressed: () {
                context.read<LoginController>().logout();
              },
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topLeft,
            filterQuality: FilterQuality.low,
            image: AssetImage("assets/glider.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(maxWidth: 400, maxHeight: 400, minWidth: 300, minHeight: 300),
                decoration: BoxDecoration(color: Colors.grey, border: Border.all(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text("Connecté en tant que : ${context.watch<LoginController>().user?.userLabel ?? "Anonyme"}"),
                        const SizedBox(
                          height: 5,
                        ),
                        if (context.watch<LoginController>().user == null)
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            child: const Text("Se connecter"),
                          ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                              onPressed: () {
                                Navigator.pushNamed(context, "/jeuDeLaVie");
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.gamepad,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("Jeu de la vie - 1 joueur", style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                              onPressed: () {
                                Navigator.pushNamed(context, "/message");
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.chat,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Jeu de la vie via chat - 2 joueurs", style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
