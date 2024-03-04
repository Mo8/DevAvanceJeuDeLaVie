import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/controllers/JeuDeLaVieController.dart';
import 'package:jeu_de_la_vie/models/Config.dart';
import 'package:jeu_de_la_vie/widgets/JeuDeLaVieWidget.dart';
import 'package:provider/provider.dart';

class JeuDeLaViePage extends StatelessWidget {
  final Config config;
  final simulateRandom;
  final int? goToGeneration;

  const JeuDeLaViePage({Key? key, required this.config, this.simulateRandom = false, this.goToGeneration, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JeuDeLaVieController(config: config, size: 30,simulateRandom: simulateRandom , goToGeneration: goToGeneration),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Consumer(
              builder: (context, JeuDeLaVieController controller, child) {
                return Text("Jeu de la vie - gen : ${controller.generation} - ${controller.config.survive.join()}A${controller.config.born.join()}D");
              },
            ),
            actions: [
                IconButton(
                  onPressed: () {
                    context.read<JeuDeLaVieController>().resumeOrPause();
                  },
                  icon: Icon(context.watch<JeuDeLaVieController>().resume ? Icons.pause : Icons.play_arrow),
                ),
              if(simulateRandom)
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, context.read<JeuDeLaVieController>().currentTab);
                  },
                  icon: const Icon(Icons.send),
                )
            ],
          ),
          body: const JeuDeLaVieWidget(),
          floatingActionButton: !simulateRandom
              ? FloatingActionButton(
                  onPressed: () {
                    context.read<JeuDeLaVieController>().addCells();
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
