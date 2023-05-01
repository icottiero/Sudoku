import 'package:flutter_sudoku/models/number_entry.dart';

import '../models/position.dart';

class Table {
  List<List<NumberEntry>> _numbers = List<List<NumberEntry>>.generate(
      9, (ind) => List<NumberEntry>.generate(9, (index) => NumberEntry(null)));

  Table._(this._numbers);

  factory Table.createWith(List<List<NumberEntry>> numbers) {
    return Table._(numbers);
  }

  int _filledCount = 0;

  void setValue({required int value, required Position position}) {
    _validateValue(value);

    _numbers[position.rowIndex][position.columnIndex].setValue(value);
    _filledCount++;
  }

  void resetValue(Position position) {
    if (getValue(
            rowIndex: position.rowIndex, columnIndex: position.columnIndex) !=
        null) {
      _numbers[position.rowIndex][position.columnIndex].setValue(null);
    }
  }

  int? getValue({
    required int rowIndex,
    required int columnIndex,
  }) {
    _validateIndex(rowIndex);
    _validateIndex(columnIndex);

    return _numbers[rowIndex][columnIndex].getValue();
  }

  bool isEmpty(Position position) {
    return getValue(
            rowIndex: position.rowIndex, columnIndex: position.columnIndex) ==
        null;
  }

  bool get isFull {
    return _filledCount >= 81;
  }

  void _validateValue(int value) {
    if (value < 1 || value > 9) {
      throw Exception("Invalid value: $value");
    }
  }

  void _validateIndex(int index) {
    if (!Position.isValidIndex(index)) {
      throw Exception("Invalid index: $index");
    }
  }
}
