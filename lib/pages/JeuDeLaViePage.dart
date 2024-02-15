import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/controllers/JeuDeLaVieController.dart';
import 'package:jeu_de_la_vie/models/Config.dart';
import 'package:jeu_de_la_vie/widgets/JeuDeLaVieWidget.dart';
import 'package:provider/provider.dart';

class JeuDeLaViePage extends StatefulWidget {
  final Config config;

  const JeuDeLaViePage({Key? key, required this.config}) : super(key: key);

  @override
  State<JeuDeLaViePage> createState() => _JeuDeLaViePageState();
}

class _JeuDeLaViePageState extends State<JeuDeLaViePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JeuDeLaVieController(config: widget.config, size: 100),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Consumer(
              builder: (context, JeuDeLaVieController controller, child) {
                return Text(
                    "Jeu de la vie - gen : ${controller.generation} - ${controller.config.survive.join()}A${controller.config.born.join()}D");
              },
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<JeuDeLaVieController>().resumeOrPause();
                },
                icon: Icon(context.watch<JeuDeLaVieController>().resume ? Icons.pause : Icons.play_arrow),
              ),
            ],
          ),
          body: const JeuDeLaVieWidget(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.read<JeuDeLaVieController>().addCells();
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
