import 'package:sudoku_console/models/table.dart';
import 'package:sudoku_console/models/position.dart';

class Game {
  Game(List<List<int?>> numbers) : _table = Table.load(numbers);

  final Table _table;

  bool get isDone => _table.isFull;

  String printTable() {
    var sb = StringBuffer();
    for (int row = 0; row < 9; row++) {
      for (int column = 0; column < 9; column++) {
        var value = _table.getValue(rowIndex: row, columnIndex: column);
        if (value == null) {
          sb.write(' ');
        } else {
          sb.write(value);
        }
        if (column == 2 || column == 5) {
          sb.write('|');
        }
      }
      sb.write('\n');
      if (row == 2 || row == 5) {
        sb.write('-----------\n');
      }
    }

    return sb.toString();
  }

  MoveResult tryMove(int value, Position position) {
    int foundAtIndex = -1;

    var row = _getRow(position.rowIndex);
    foundAtIndex = row.indexOf(value);

    if (foundAtIndex > -1) {
      return MoveResult(
          success: false,
          message:
              'The row $position contains the same value at index $foundAtIndex');
    }

    var column = _getColumn(position.columnIndex);
    foundAtIndex = column.indexOf(value);
    if (foundAtIndex > -1) {
      return MoveResult(
          success: false,
          message:
              'The column ${position.columnIndex} contains the same value at index $foundAtIndex');
    }

    final boxStartingPosition = _getBoxStartingPosition(position);
    var box = _getBox(boxStartingPosition);
    foundAtIndex = box.indexOf(value);
    if (foundAtIndex > -1) {
      final foundAtPosition =
          _getAbsolutePositionFromBoxIndex(boxStartingPosition, foundAtIndex);
      return MoveResult(
          success: false,
          message: 'The box contains the same value at index '
              '(r:${foundAtPosition.rowIndex},c:${foundAtPosition.columnIndex})');
    }

    _table.setValue(value: value, position: position);

    return MoveResult(success: true);
  }

  List<int?> _getRow(int rowIndex) {
    List<int?> result = [];
    for (int columnIndex = 0; columnIndex < 9; columnIndex++) {
      result.add(_table.getValue(rowIndex: rowIndex, columnIndex: columnIndex));
    }
    return result;
  }

  List<int?> _getColumn(int columnIndex) {
    List<int?> result = [];
    for (int rowIndex = 0; rowIndex < 9; rowIndex++) {
      result.add(_table.getValue(rowIndex: rowIndex, columnIndex: columnIndex));
    }
    return result;
  }

  List<int?> _getBox(Position boxStartingPosition) {
    List<int?> result = [];
    for (int index = 0; index < 9; index++) {
      result.add(_table.getValue(
          rowIndex: (boxStartingPosition.rowIndex + (index % 3)),
          columnIndex: boxStartingPosition.columnIndex + (index ~/ 3)));
    }
    return result;
  }

  Position _getBoxStartingPosition(Position containingPosition) {
    final startingRow =
        containingPosition.rowIndex - (containingPosition.rowIndex % 3);
    final startingColumn =
        containingPosition.columnIndex - (containingPosition.columnIndex % 3);
    return Position(rowIndex: startingRow, columnIndex: startingColumn);
  }

  Position _getAbsolutePositionFromBoxIndex(
      Position boxStartingPosition, int index) {
    return Position(
        rowIndex: boxStartingPosition.rowIndex + (index % 3),
        columnIndex: boxStartingPosition.columnIndex + (index ~/ 3));
  }
}

class MoveResult {
  final bool success;
  final String? message;

  MoveResult({
    required this.success,
    this.message,
  });
}
