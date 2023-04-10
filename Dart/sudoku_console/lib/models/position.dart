class Position {
  final int rowIndex;
  final int columnIndex;

  Position({
    required this.rowIndex,
    required this.columnIndex,
  }) {
    _validate();
  }

  void _validate() {
    if (!isValidIndex(rowIndex) || !isValidIndex(columnIndex)) {
      throw Exception(
          'The position is not valid - r:$rowIndex, c:$columnIndex');
    }
  }

  static bool isValidIndex(int index) {
    return index >= 0 && index < 9;
  }
}
