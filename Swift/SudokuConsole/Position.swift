struct Position {
    private var _row: Int;
    private var _column: Int;
    
    init(row: Int, column: Int) throws {
        _row = row;
        _column = column;
        try checkIndex(index: row);
        try checkIndex(index: column);
    }
    
    var row: Int {
        get {
            return _row;
        }
    }
    
    var column: Int {
        get {
            return _column;
        }
    }
    
    var printString: String { return "(r:\(_row),c:\(_column))" }
    
    private func checkIndex(index: Int) throws {
        guard index > 0 && index < 9 else {
            throw SudokuError.IndexOutOfBounds(index: index);
        }
    }
}
