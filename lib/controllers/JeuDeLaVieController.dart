import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:jeu_de_la_vie/models/Config.dart';

class JeuDeLaVieController extends ChangeNotifier {
  final int size;
  List<List<ValueNotifier<bool>>> tab;
  int generation = 0;

  List<List<bool>> get currentTab => tab.map((e) => e.map((e) => e.value).toList()).toList();

  bool resume = false;

  Config config;

  JeuDeLaVieController({required this.config, required this.size, bool simulateRandom = false, int? goToGeneration})
      : tab = simulateRandom
            ? List.generate(size, (indexX) => List.generate(size, (indexY) => ValueNotifier<bool>(Random().nextBool())))
            : List.generate(size, (index) => List.generate(size, (index) => ValueNotifier<bool>(false))) {
    if (goToGeneration != null) {
      for (int i = 0; i < goToGeneration; i++) {
        doOneGeneration();
      }
      notifyListeners();
    }
  }

  void doGeneration() {
    if (resume) {
      Future.delayed(const Duration(milliseconds: 50), () {
        doOneGeneration();
        notifyListeners();
        doGeneration();
      });
    }
  }

  void doOneGeneration() {
    generation++;
    List<List<bool>> newTab = List.generate(size, (index) => List.generate(size, (index) => false));
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        int nbVoisins = 0;
        if (i > 0 && j > 0 && tab[i - 1][j - 1].value) {
          nbVoisins++;
        }
        if (i > 0 && tab[i - 1][j].value) {
          nbVoisins++;
        }
        if (i > 0 && j < size - 1 && tab[i - 1][j + 1].value) {
          nbVoisins++;
        }
        if (j > 0 && tab[i][j - 1].value) {
          nbVoisins++;
        }
        if (j < size - 1 && tab[i][j + 1].value) {
          nbVoisins++;
        }
        if (i < size - 1 && j > 0 && tab[i + 1][j - 1].value) {
          nbVoisins++;
        }
        if (i < size - 1 && tab[i + 1][j].value) {
          nbVoisins++;
        }
        if (i < size - 1 && j < size - 1 && tab[i + 1][j + 1].value) {
          nbVoisins++;
        }
        if (tab[i][j].value) {
          if (config.survive.contains(nbVoisins)) {
            newTab[i][j] = true;
          }
        } else {
          if (config.born.contains(nbVoisins)) {
            newTab[i][j] = true;
          }
        }
      }
    }
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        tab[i][j].value = newTab[i][j];
      }
    }
  }

  void resumeOrPause() {
    resume = !resume;
    if (resume) {
      doGeneration();
    }
  }

  void addCells() {
    int x = Random().nextInt(size - 10) + 5;
    int y = Random().nextInt(size - 10) + 5;
    for (int i = x - 5; i < x + 5; i++) {
      for (int j = y - 5; j < y + 5; j++) {
        if (tab[i][j].value == false) {
          tab[i][j].value = Random().nextBool();
        }
      }
    }
  }
}
