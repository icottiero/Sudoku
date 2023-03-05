using Sudoku.Console;
using Sudoku.Helpers;
using Sudoku.Models;

namespace Sudoku.Engine;

public class Game
{
	private readonly Table _table;

	public Game(Table table)
	{
		_table = table;
	}

	public SetResult TrySetNumber(int value, Position position)
	{
		if (!IsValidValue(value)) 
		{
			return new(false, $"The value {value} is not a valid one.");
		}

		if (!IsEmpty(position))
		{
			return new(false, $"The position (r:{position.Row},c:{position.Column}) is allready filled (value {_table.GetValue(position.Row, position.Column)}).");
		}

		var row = GetRow(position.Row);

		if (row.ContainsValue(value, out int? foundAtIndex))
		{
			return new(false, $"The value {value} already exists in the same row at position {foundAtIndex + 1}");
        }

		var column = GetColumn(position.Column);

		if (column.ContainsValue(value, out foundAtIndex))
		{
			return new(false, $"The value {value} already exists in the same column at position {foundAtIndex + 1}");
        }

		(var box, var startingPosition) = GetBoxAndStartingPosition(position);

		if (box.ContainsValue(value, out foundAtIndex))
		{
			var foundAtPosition = GetAbsolutePositionForBoxIndex(foundAtIndex!.Value, startingPosition);
			return new(false, $"The value {value} already exists in the same box at position {foundAtPosition}.");
		}

		_table.SetValue(value, position);

		return new(true);
	}

	public bool IsDone()
		=> _table.IsFilled();

	private Position GetAbsolutePositionForBoxIndex(int index, Position boxStartingPosition)
	{
		var rowIndex = boxStartingPosition.Row + (index / 3);
		var columnIndex = boxStartingPosition.Column + (index % 3);
		return new(rowIndex, columnIndex);
	}

	private int?[] GetRow(int index)
	{
		var result = new int?[9];

		for (int i = 0; i < 9; i++)
		{
			result[i] = _table.GetValue(index, i);
		}

		return result;
	}

	private int?[] GetColumn(int index)
	{
		var result = new int?[9];

		Iterator.Iterate9Times(result, (array, i) =>
		{
			array[i] = _table.GetValue(i, index);
		});

		return result;
	}

	private (int?[], Position) GetBoxAndStartingPosition(Position containedPosition)
	{
		var result = new int?[9];
		var resultIndex = 0;

		var startingPosition = GetBoxStartingPosition(containedPosition);

		for (int rowIndex = startingPosition.Row; rowIndex < startingPosition.Row + 3; rowIndex++)
		{
			for(int columnIndex = startingPosition.Column; columnIndex < startingPosition.Column + 3; columnIndex++)
			{
				result[resultIndex++] = _table.GetValue(rowIndex, columnIndex);
			}
		}

		return (result, startingPosition);
	}

	private Position GetBoxStartingPosition(Position containedPosition)
	{
        var startingRowIndex = containedPosition.Row - (containedPosition.Row % 3);
        var startingColumnIndex = containedPosition.Column - (containedPosition.Column % 3);

		return new(startingRowIndex, startingColumnIndex);
    }

	public bool IsEmpty(Position position)
	{
		return _table.GetValue(position.Row, position.Column) is null;
	}

    public override string ToString()
    {
        return _table.ToString();
    }

	public bool IsValidValue(int value) 
	{
		return value > 0 && value <= 9;
	}
}