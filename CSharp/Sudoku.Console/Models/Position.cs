namespace Sudoku.Models;

public record Position
{
	public int Row { get; }
	public int Column { get; }

    public Position(int row, int column)
	{
		if (!Table.IsValidIndex(row) || !Table.IsValidIndex(column))
		{
			throw new Exception($"Invalid position (r:{row},c:{column}");
		}

		Row = row;
		Column = column;
	}

    public override string ToString()
    {
		return $"(r:{Row},c:{Column})";

	}
}