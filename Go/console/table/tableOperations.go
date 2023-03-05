package table

import (
	"errors"
	"fmt"
	"log"
	"strings"
	"sudoku/console/position"
)

type Position = position.Position

func (table Table) GetValue(position position.Position) int {
	return table.numbers[position.Row][position.Column]
}

func (table Table) SetValue(value int, position Position) error {
	if table.numbers[position.Row][position.Column] != EmptyValue {
		return errors.New("The position is not empty.")
	}

	table.numbers[position.Row][position.Column] = value
	table.addedNumbersCount++
	return nil
}

func (table Table) IsFull() bool {
	return table.addedNumbersCount >= 81
}

func (table Table) GetRow(position Position) TableArray {
	return table.numbers[position.Row]
}

func (table Table) GetColumn(position Position) TableArray {
	result := TableArray{}
	columnIndex := 0
	for _, column := range table.numbers {
		result[columnIndex] = column[position.Row]
		columnIndex++
	}
	return result
}

func (table Table) GetBoxAndStartingPosition(containingPosition Position) (TableArray, Position) {
	boxStartingPosition := getBoxStartingPosition(containingPosition)
	log.Printf(
		"Determined the box starting position to be (r:%d,c:%d)",
		boxStartingPosition.Row,
		boxStartingPosition.Column)

	result := TableArray{}
	resultIndex := 0
	for rowIndex := boxStartingPosition.Row; rowIndex < boxStartingPosition.Row+3; rowIndex++ {
		for columnIndex := boxStartingPosition.Column; columnIndex < boxStartingPosition.Column+3; columnIndex++ {
			result[resultIndex] = table.numbers[rowIndex][columnIndex]
			resultIndex++
		}
	}
	return result, boxStartingPosition
}

func getBoxStartingPosition(containingPosition position.Position) Position {
	row := containingPosition.Row - (containingPosition.Row / 3)
	column := containingPosition.Column - (containingPosition.Column / 3)
	return position.NewPosition(row, column)
}

func ConvertBoxIndexToAbsolutePosition(index int, boxStartingPosition position.Position) position.Position {
	row := boxStartingPosition.Row + (index % 3)
	column := boxStartingPosition.Column + (index / 3)
	return position.NewPosition(row, column)
}

func (table Table) ToStringFormat() string {
	var sb strings.Builder
	for rowIndex, row := range table.numbers {
		for columnIndex, value := range row {
			valueStr := " "
			if value != EmptyValue {
				valueStr = fmt.Sprintf("%d", value)
			}

			sb.WriteString(valueStr)
			if columnIndex == 2 || columnIndex == 5 {
				sb.WriteString("|")
			}
		}

		sb.WriteString("\n")
		if rowIndex == 2 || rowIndex == 5 {
			sb.WriteString("-----------\n")
		}
	}

	return sb.String()
}
