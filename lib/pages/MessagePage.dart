import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/widgets/ChatWidget.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message"),
      ),
      body: ChatWidget(),
    );
  }
}
