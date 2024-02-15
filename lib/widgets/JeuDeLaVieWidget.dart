import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/controllers/JeuDeLaVieController.dart';
import 'package:provider/provider.dart';
import 'package:zoom_widget/zoom_widget.dart';

class JeuDeLaVieWidget extends StatelessWidget {


  const JeuDeLaVieWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final int size = context.read<JeuDeLaVieController>().size;
    return Center(
      child: Zoom(
        child: SizedBox(
          width: (size * size).toDouble(),
          height: (size * size).toDouble(),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size,
            ),
            itemCount: size * size,
            itemBuilder: (context, index) {
              return Cell(valueNotifier: context.read<JeuDeLaVieController>().tab[index ~/ size][index % size]);
            },
          ),
        ),
      ),
    );
  }
}

class Cell extends StatelessWidget {
  final ValueNotifier<bool> valueNotifier ;
  const Cell({Key? key, required this.valueNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder:  (BuildContext context, bool alive, Widget? child) {
        return GestureDetector(
          onTap: () {
            valueNotifier.value = !alive;
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
              color: valueNotifier.value ? Colors.black : Colors.white,
            ),
          ),
        );
      }, valueListenable: valueNotifier,
    );
  }
}


