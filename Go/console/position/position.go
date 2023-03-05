package position

import "errors"

type Position struct {
	Row    int
	Column int
}

func NewPosition(row int, column int) Position {
	if !IsValidPosition(row, column) {
		panic(errors.New("Invalid position index."))
	}

	return Position{Row: row, Column: column}
}

func IsValidPosition(row int, column int) bool {
	return isValidIndex(row) && isValidIndex(column)
}

func isValidIndex(index int) bool {
	return index >= 0 && index < 9
}
