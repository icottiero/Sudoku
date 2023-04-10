import 'package:sudoku_console/models/position.dart';
import 'package:test/test.dart';

void main() {
  final invalidIndexes = [-10, -1, 9, 10, 20];

  group('isValidPosition', () {
    test('valid position - return true', () {
      for (int i = 0; i < 9; i++) {
        expect(Position.isValidIndex(i), true);
      }
    });

    test('not valid position - return false', () {
      for (var element in invalidIndexes) {
        expect(Position.isValidIndex(element), false);
      }
    });
  });

  group('ctor', () {
    test('valid parameters - create successfully', () {
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          var result = Position(rowIndex: i, columnIndex: j);
          expect(result.rowIndex, i);
          expect(result.columnIndex, j);
        }
      }
    });

    test('invalid row - throw Exception', () {
      for (int i = 0; i < 9; i++) {
        for (int invalid in invalidIndexes) {
          expect(() => Position(rowIndex: invalid, columnIndex: i),
              throwsException);
        }
      }
    });

    test('invalid column - throw Exception', () {
      for (int i = 0; i < 9; i++) {
        for (int invalid in invalidIndexes) {
          expect(() => Position(rowIndex: i, columnIndex: invalid),
              throwsException);
        }
      }
    });
  });
}
