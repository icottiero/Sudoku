import 'package:flutter_sudoku/models/number_entry.dart';

import '../models/position.dart';
import '../models/table.dart';

class Game {
  Game(List<List<NumberEntry>> numbers) : table = Table.createWith(numbers);

  final Table table;
  final List<Position> _movesHistory = List<Position>.empty();

  bool get isDone => table.isFull;

  String printTable() {
    var sb = StringBuffer();
    for (int row = 0; row < 9; row++) {
      for (int column = 0; column < 9; column++) {
        var value = table.getValue(rowIndex: row, columnIndex: column);
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
    List<Reason> failureReasons = List.empty();

    if (table.isEmpty(position)) {
      failureReasons.add(Reason(RuleType.position, position));
    }

    var row = _getRow(position.rowIndex);
    foundAtIndex = row.indexOf(value);

    if (foundAtIndex > -1) {
      failureReasons.add(Reason(RuleType.row,
          Position(rowIndex: position.rowIndex, columnIndex: foundAtIndex)));
    }

    var column = _getColumn(position.columnIndex);
    foundAtIndex = column.indexOf(value);
    if (foundAtIndex > -1) {
      failureReasons.add(Reason(RuleType.column,
          Position(rowIndex: foundAtIndex, columnIndex: position.columnIndex)));
    }

    final boxStartingPosition = _getBoxStartingPosition(position);
    var box = _getBox(boxStartingPosition);
    foundAtIndex = box.indexOf(value);
    if (foundAtIndex > -1) {
      final foundAtPosition =
          _getAbsolutePositionFromBoxIndex(boxStartingPosition, foundAtIndex);
      failureReasons.add(Reason(RuleType.box, foundAtPosition));
    }

    var result = MoveResult(reasons: failureReasons);

    if (result.success) {
      _makeMove(value, position);
    }

    return result;
  }

  void undoMove() {
    final previousMove = _movesHistory.last;
    table.resetValue(previousMove);
    _movesHistory.remove(previousMove);
  }

  void _makeMove(int value, Position position) {
    table.setValue(value: value, position: position);
    _movesHistory.add(position);
  }

  List<int?> _getRow(int rowIndex) {
    List<int?> result = [];
    for (int columnIndex = 0; columnIndex < 9; columnIndex++) {
      result.add(table.getValue(rowIndex: rowIndex, columnIndex: columnIndex));
    }
    return result;
  }

  List<int?> _getColumn(int columnIndex) {
    List<int?> result = [];
    for (int rowIndex = 0; rowIndex < 9; rowIndex++) {
      result.add(table.getValue(rowIndex: rowIndex, columnIndex: columnIndex));
    }
    return result;
  }

  List<int?> _getBox(Position boxStartingPosition) {
    List<int?> result = [];
    for (int index = 0; index < 9; index++) {
      result.add(table.getValue(
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
  final List<Reason> reasons;

  MoveResult({
    required this.reasons,
  }) : success = reasons.isEmpty;
}

class Reason {
  final RuleType brokenRule;
  final Position conflictingPosition;

  Reason(this.brokenRule, this.conflictingPosition);
}

enum RuleType { row, column, box, position }
