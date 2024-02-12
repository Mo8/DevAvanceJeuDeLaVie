import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/models/Config.dart';
import 'package:zoom_widget/zoom_widget.dart';

const int size = 20;

class JeuDeLaViePage extends StatefulWidget {
  final Config config;

  const JeuDeLaViePage({Key? key, required this.config}) : super(key: key);

  @override
  State<JeuDeLaViePage> createState() => _JeuDeLaViePageState();
}

class _JeuDeLaViePageState extends State<JeuDeLaViePage> {
  List<List<bool>> tab = List.generate(size, (index) => List.generate(size, (index) => false));
  int generation = 0;

  bool resume = false;

  void doGeneration() {
    if (resume) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (context.mounted) {
          setState(() {
            generation++;
            List<List<bool>> newTab = List.generate(size, (index) => List.generate(size, (index) => false));
            for (int i = 0; i < size; i++) {
              for (int j = 0; j < size; j++) {
                int nbVoisins = 0;
                if (i > 0 && j > 0 && tab[i - 1][j - 1]) {
                  nbVoisins++;
                }
                if (i > 0 && tab[i - 1][j]) {
                  nbVoisins++;
                }
                if (i > 0 && j < size - 1 && tab[i - 1][j + 1]) {
                  nbVoisins++;
                }
                if (j > 0 && tab[i][j - 1]) {
                  nbVoisins++;
                }
                if (j < size - 1 && tab[i][j + 1]) {
                  nbVoisins++;
                }
                if (i < size - 1 && j > 0 && tab[i + 1][j - 1]) {
                  nbVoisins++;
                }
                if (i < size - 1 && tab[i + 1][j]) {
                  nbVoisins++;
                }
                if (i < size - 1 && j < size - 1 && tab[i + 1][j + 1]) {
                  nbVoisins++;
                }
                if (tab[i][j]) {
                  if (widget.config.survive.contains(nbVoisins)) {
                    newTab[i][j] = true;
                  }
                } else {
                  if (widget.config.born.contains(nbVoisins)) {
                    newTab[i][j] = true;
                  }
                }
              }
            }
            tab = newTab;
            doGeneration();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("Jeu de la vie - gen : $generation - ${widget.config.survive.join()}A${widget.config.born.join()}D"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  resume = !resume;
                  if (resume) {
                    doGeneration();
                  }
                });
              },
              icon: Icon(resume ? Icons.pause : Icons.play_arrow),
            ),
          ],
        ),
        body: Center(
          child: Zoom(
            child: SizedBox(
              width: (size * size).toDouble(),
              height: (size * size).toDouble(),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size,
                ),
                itemCount: size * size,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      tab[index ~/ size][index % size] = !tab[index ~/ size][index % size];
                      if (!resume) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                        color: tab[index ~/ size][index % size] ? Colors.black : Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            int x = Random().nextInt(size-10)+5;
            int y = Random().nextInt(size-10)+5;
            // add random point on the grid
            for (int i = x-5; i < x+5; i++) {
              for (int j = y-5; j < y+5; j++) {
                if(tab[i][j] == false) {
                  tab[i][j] = Random().nextBool();
                }
              }
            }
            if (!resume) {
              setState(() {});
            }
          },
          child: const Icon(Icons.add),
        ));
  }
}
