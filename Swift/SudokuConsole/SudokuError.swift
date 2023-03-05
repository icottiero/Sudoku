enum SudokuError: Error {
    case PositionAlreadyFilled(position: Position)
    case IndexOutOfBounds(index: Int)
}
