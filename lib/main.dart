import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/controllers/LoginController.dart';
import 'package:jeu_de_la_vie/models/Config.dart';
import 'package:jeu_de_la_vie/pages/HomePage.dart';
import 'package:jeu_de_la_vie/pages/JeuDeLaViePage.dart';
import 'package:jeu_de_la_vie/pages/LoginPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => LoginController(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/jeuDeLaVie": (context) => JeuDeLaViePage(
              config: context.read<LoginController>().user != null
                  ? context.read<LoginController>().user!.config
                  : const Config(survive: {2, 3}, born: {3}),
            ),
        "/login": (context) => const LoginPage(),
        "/": (context) => const HomePage(),
      },
    );
  }
}
