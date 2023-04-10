import 'dart:io';

import 'package:sudoku_console/loader/loader.dart';

import 'engine/game.dart';
import 'models/position.dart';

Future<void> playGame() async {
  var game = await Loader.loadRandomGame();
  print('The game has started');

  while (!game.isDone) {
    print(game.printTable());

    print('Enter the new value: ');
    var value = ensureNumberInput();

    print('Enter the row number');
    var rowNumber = ensureNumberInput();

    print('Enter the column number');
    var columnNumber = ensureNumberInput();

    var result = game.tryMove(value,
        Position(rowIndex: rowNumber - 1, columnIndex: columnNumber - 1));

    if (!result.success) {
      print(result.message);
    }
  }
}

int ensureNumberInput() {
  while (true) {
    var input = stdin.readLineSync();
    if (input == null) {
      print("That's not an input. Try again.");
      continue;
    }
    var numberInput = int.tryParse(input);
    if (numberInput == null) {
      print("That's not a number. Try again.");
      continue;
    }

    if (!Position.isValidIndex(numberInput - 1)) {
      print("That's not a valid number. Try again.");
      continue;
    }

    return numberInput;
  }
}
