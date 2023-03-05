print("Hello, World!")

var game = Game();

print("The game has started.");

while !game.isDone {
    print(game.printString());
    
    let value = ensureNumberInput(question: "Please write the value:");
    
    let rowIndex = ensureNumberInput(question: "Please write the row index:");
    
    let columnIndex = ensureNumberInput(question: "Please write the column index:");
    
    let position: Position;
    do {
        position = try Position(row: rowIndex, column: columnIndex);
    }
    catch {
        print("Those indexes are not valid. Try again.");
        continue;
    }
    
    let setResult = game.trySetValue(value: value, position: position);
    
    handleResult(setResult: setResult);
}

func handleResult(setResult: SetResult) {
    if !setResult.success {
        print("Nope, that won't work. \(setResult.errorMessage!)");
    }
}

func ensureNumberInput(question: String) -> Int {
    print(question);
    var input = readLine();
    
    let value = Int(input ?? "")
    while value == nil {
        print("We couldn't call that a number, so we won't. Please write one:");
        input = readLine()
    }
    
    return value!;
}




