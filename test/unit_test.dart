

import 'package:flutter_test/flutter_test.dart';
import 'package:jeu_de_la_vie/controllers/JeuDeLaVieController.dart';
import 'package:jeu_de_la_vie/models/Config.dart';

void main() {
  group('Initialisation parse', () {
    test('Regles parse', () {
      expect(Config.parse("23A3D").toString(), Config(born: {3}, survive: {2, 3}).toString());
      expect(Config.parse("12345678A12345678D").toString(), Config(born: { 1, 2, 3, 4, 5, 6, 7, 8}, survive: { 1, 2, 3, 4, 5, 6, 7, 8}).toString());
    });
    test('Regles parse not working', () {
      expect(() => Config.parse("23A3"), throwsAssertionError);
      expect(() => Config.parse("23A3D3"), throwsAssertionError);
      expect(() => Config.parse("23A3D3D"), throwsAssertionError);
      expect(() => Config.parse("23A3D3D3"), throwsAssertionError);
      expect(() => Config.parse("23AA3D"), throwsAssertionError);
    });
  });

  group('Jeu de la vie', () {
    test('Jeu de la vie initialisation', () {
      JeuDeLaVieController controller = JeuDeLaVieController(config: Config.parse("23A3D"), size: 10,);
      expect(controller.tab.length, 10);
      expect(controller.tab[0].length, 10);
      expect(controller.generation, 0);
      expect(controller.resume, false);

      controller.currentTab.forEach((element) {
        element.forEach((element) {
          expect(element, false);
        });
      });
    });
  });

}
