package engine

import (
	"errors"
	"fmt"
	"sudoku/console/position"
	"sudoku/console/table"
)

type SetResult struct {
	Success      bool
	ErrorMessage string
}

type Engine struct {
	table table.Table
}

const (
	MinValue = 1
	MaxValue = 9
)

func NewSudokuEngine() Engine {
	table := table.NewSudokuTable()

	return Engine{
		table: table,
	}
}

func (engine Engine) TablePrint() string {
	return engine.table.ToStringFormat()
}

func (engine Engine) IsDone() bool {
	return engine.table.IsFull()
}

func (engine Engine) TrySetValue(value int, position position.Position) error {
	if !isValidValue(value) {
		return errors.New("This is not a valid value.")
	}

	if engine.table.GetValue(position) != table.EmptyValue {
		return errors.New("The specified position is not empty.")
	}

	row := engine.table.GetRow(position)
	if foundAtIndex := row.GetIndexOf(value); foundAtIndex != -1 {
		return errors.New(fmt.Sprintf("The same value already esists in the same row at index %d", foundAtIndex))
	}

	column := engine.table.GetColumn(position)
	if foundAtIndex := column.GetIndexOf(value); foundAtIndex != -1 {
		return errors.New(fmt.Sprintf("The same value already exists in the same column at index %d", foundAtIndex))
	}

	box, boxStartingPosition := engine.table.GetBoxAndStartingPosition(position)
	if foundAtIndex := box.GetIndexOf(value); foundAtIndex != -1 {
		foundAtPosition := table.ConvertBoxIndexToAbsolutePosition(foundAtIndex, boxStartingPosition)
		return errors.New(fmt.Sprintf("The same value already exists in the same box at (r:%d,c:%d)", foundAtPosition.Row, foundAtPosition.Column))
	}

	engine.table.SetValue(value, position)

	return nil
}

func isValidValue(value int) bool {
	return value >= MinValue && value <= MaxValue
}
