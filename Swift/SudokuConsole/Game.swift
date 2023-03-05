struct Game {
    private var _table: Table = Table();
    
    var isDone: Bool { _table.isFull }
    
    mutating func trySetValue(value: Int, position: Position) -> SetResult {
        if !isValidValue(value: value) {
            return SetResult(success: false, errorMessage: "This is not a valid value.");
        }
        
        if _table.getValue(row: position.row, column: position.column) != nil {
            return SetResult(success: false, errorMessage: "The position is already filled.");
        }
        
        let row = getRow(rowIndex: position.row);
        var foundAtIndex: Int?;
        if row.containsValue(value: value, foundAtIndex: &foundAtIndex) {
            return SetResult(success: false, errorMessage: "Value exists in the same row at index \(foundAtIndex!).");
        }
        
        let column = getColumn(columnIndex: position.column);
        if column.containsValue(value: value, foundAtIndex: &foundAtIndex) {
            return SetResult(success: false, errorMessage: "Value exists in the same column at index \(foundAtIndex!).");
        }
        
        let (box, boxStartingPosition) = getBox(position: position);
        if box.containsValue(value: value, foundAtIndex: &foundAtIndex) {
            let foundAtPosition = arrayIndexToBoxPosition(
                index: foundAtIndex!,
                boxStartingPosition: boxStartingPosition);
            
            return SetResult(success: false, errorMessage: "Value exists in the same box at position \(foundAtPosition)");
        }
        
        do {
            try _table.setValue(value: value, position: position);
        } catch {
            return SetResult(success: true, errorMessage: "Somehow, after all that checks, you still messed up.");
        }
        
        return SetResult(success: true, errorMessage: nil);
    }
    
    func printString() -> String {
        return _table.printString();
    }
    
    private func getRow(rowIndex: Int) -> [Int?] {
        var result = [Int?](repeating: nil, count: 9);
        
        for i in 0 ..< 9 {
            result[i] = _table.getValue(row: rowIndex, column: i);
        }
        
        return result;
    }
    
    private func getColumn(columnIndex: Int) -> [Int?] {
        var result = [Int?](repeating: nil, count: 9);
        
        for i in 0 ..< 9 {
            result[i] = _table.getValue(row: i, column: columnIndex);
        }
        
        return result;
    }
    
    private func getBox(position: Position) -> ([Int?], Position) {
        var result = [Int?](repeating: nil, count: 9);
        var resultIndex = 0
        
        let startingPosition = getBoxStartingPosition(position: position)
        
        for row in startingPosition.row ..< (startingPosition.row + 3) {
            for column in startingPosition.column ..< (startingPosition.column + 3) {
                result[resultIndex] = _table.getValue(row: row, column: column);
                resultIndex += 1;
            }
        }
        
        return (result, startingPosition);
    }
    
    private func getBoxStartingPosition(position: Position) -> Position {
        let startingColumn = position.column - (position.column % 3);
        let startingRow = position.row - (position.row % 3);
        
        return try! Position(row: startingRow, column: startingColumn)
    }
    
    private func arrayIndexToBoxPosition(index: Int, boxStartingPosition: Position) -> Position{
        let row = boxStartingPosition.row + boxStartingPosition.row % 3;
        let column = boxStartingPosition.column + boxStartingPosition.column / 3;
        
        return try! Position(row: row, column: column);
    }
    
    private func isValidValue(value: Int) -> Bool {
        return value > 0 && value <= 9;
    }
}

struct SetResult {
    
    init(success: Bool, errorMessage: String? = nil) {
        self.success = success;
        self.errorMessage = errorMessage;
    }
    
    let success: Bool;
    let errorMessage: String?;
}

extension [Int?] {
    func containsValue(value: Int, foundAtIndex: inout Int?) -> Bool{
        if let index = self.firstIndex(of: value) {
            foundAtIndex = index;
            return true;
        }
        
        return false;
    }
}
