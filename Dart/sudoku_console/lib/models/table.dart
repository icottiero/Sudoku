import '../models/position.dart';

class Table {
  List<List<int?>> _numbers = List<List<int?>>.generate(
      9, (ind) => List<int?>.generate(9, (index) => null));

  Table({List<List<int?>>? numbers}) {
    if (numbers != null) {
      _numbers = numbers;
    }
  }

  factory Table.load(List<List<int?>> numbers) {
    return Table(numbers: numbers);
  }

  int _filledCount = 0;

  void setValue({required int value, required Position position}) {
    _validateValue(value);

    _numbers[position.rowIndex][position.columnIndex] = value;
    _filledCount++;
  }

  bool get isFull {
    return _filledCount >= 81;
  }

  int? getValue({
    required int rowIndex,
    required int columnIndex,
  }) {
    _validateIndex(rowIndex);
    _validateIndex(columnIndex);

    return _numbers[rowIndex][columnIndex];
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
