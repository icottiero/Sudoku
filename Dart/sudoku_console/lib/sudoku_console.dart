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
      print('Unable to make the required move:');
      for (var reason in result.reasons) {
        switch (reason.brokenRule) {
          case RuleType.column:
            print(
                'The same value was found in the same column at position ${reason.conflictingPosition.rowIndex}');
            break;
          case RuleType.row:
            print(
                'The same value was found in the same row at position ${reason.conflictingPosition.columnIndex}');
            break;
          case RuleType.box:
            print(
                'The same value was found in the same box at position ${reason.conflictingPosition.rowIndex + 1},${reason.conflictingPosition.columnIndex + 1}');
            break;
        }
      }
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

void _printResult(MoveResult result) {
  if (!result.success) {
    print('Unable to make the required move:');
    for (var reason in result.reasons) {
      switch (reason.brokenRule) {
        case RuleType.column:
          print(
              'The same value was found in the same column at position ${reason.conflictingPosition.rowIndex}\n');
          break;
        case RuleType.row:
          print(
              'The same value was found in the same row at position ${reason.conflictingPosition.columnIndex}\n');
          break;
        case RuleType.box:
          print(
              'The same value was found in the same box at position ${reason.conflictingPosition.rowIndex + 1},${reason.conflictingPosition.columnIndex + 1}\n');
          break;
        case RuleType.position:
          print('The position you specified is not empty.');
          break;
      }
    }

    return;
  }

  print('Move successful!\n');
}
