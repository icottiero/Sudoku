package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
	"sudoku/console/engine"
	"sudoku/console/position"
)

func main() {
	fmt.Println("This version of Sudoku was implemented using Go.")
	fmt.Println("The game has started.")

	engine := engine.NewSudokuEngine()

	for !engine.IsDone() {
		fmt.Println(engine.TablePrint())

		value := ensureIntegerInput("Enter the new value: ")
		rowIndex := ensureIntegerInput("Enter the row index: ")
		columnIndex := ensureIntegerInput("Enter the column index:")

		if !position.IsValidPosition(rowIndex, columnIndex) {
			fmt.Println("This is not a valid position")
			continue
		}

		position := position.NewPosition(rowIndex, columnIndex)

		if err := engine.TrySetValue(value, position); err != nil {
			fmt.Println(err.Error())
		}
	}
}

func ensureIntegerInput(message string) int {
	fmt.Print(message)

	reader := bufio.NewReader(os.Stdin)

	input, _ := reader.ReadString('\n')

	number, err := strconv.Atoi(strings.Trim(input, " \n"))
	for err != nil {
		fmt.Print("That (" + input + ") is not a number, try again:")
		input, _ := reader.ReadString('\n')
		number, err = strconv.Atoi(strings.Trim(input, " \n"))
	}

	return number
}
