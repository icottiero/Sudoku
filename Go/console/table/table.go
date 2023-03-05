package table

const (
	TableSize  = 9
	MinValue   = 1
	EmptyValue = 0
)

type Table struct {
	numbers           [9][9]int
	addedNumbersCount int
}

type TableArray [9]int

func NewSudokuTable() Table {
	return Table{
		numbers:           [9][9]int{},
		addedNumbersCount: 0,
	}
}

func (array TableArray) GetIndexOf(value int) int {
	for p, v := range array {
		if v == value {
			return p
		}
	}
	return -1
}
