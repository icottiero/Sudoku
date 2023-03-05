//
//  Table.swift
//  SudokuConsole
//
//  Created by Ivan Cottiero on 18.02.2023..
//

import Foundation

struct Table {
    private var _numbers : [[Int?]]
    private var _numbersCount = 0;
    
    init() {
        _numbers = [[Int?]](repeating: [Int?](repeating: nil, count: 9), count: 9);
    }
    
    func getValue(row: Int, column: Int) -> Int? {
        return _numbers[row][column];
    }
    
    mutating func setValue(value: Int, position: Position) throws {
        guard getValue(row: position.row, column: position.column) == nil else {
            throw SudokuError.PositionAlreadyFilled(position: position)
        }
        _numbers[position.row][position.column] = value;
        _numbersCount += 1;
    }
    
    var isFull: Bool { _numbersCount >= 81 }
    
    func printString() -> String {
        var result = "";
        
        for row in 0 ... 8 {
            for column in 0 ... 8 {
                let value = _numbers[row][column]
                if value != nil {
                    result += String(value!);
                }
                else {
                    result += " ";
                }
                
                if (column == 2 || column == 5) {
                    result += "|";
                }
            }
            result += "\n";
            
            if row == 2 || row == 5 {
                result += "-----------\n";
            }
        }
        
        return result;
    }
}
