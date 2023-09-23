using System;
using System.Text;

namespace Sudoku.Models;

public class Table
{
    private Number?[,] _numbers = new Number?[9, 9];
    private int noOfSetNumbers = 0;

    public Table(Template template)
	{
        for(int column = 0; column < 9; column++)
        {
            for (int row = 0; row < 9; row++) 
            {
                if (template.Grid[column][row] != 0) 
                {
                    _numbers[row, column] = new(template.Grid[column][row], false);
                }
            }
        }
	}

    public bool IsFilled()
    {
        return noOfSetNumbers == 81;
    }

    public int? GetValue(int rowIndex, int columnIndex)
    {
        if (!IsValidIndex(rowIndex) || !IsValidIndex(columnIndex))
        {
            throw new Exception($"Tried accessing invalid position (r:{rowIndex},c:{columnIndex})");
        }

        return _numbers[rowIndex, columnIndex]?.Value;
    }

    public void SetValue(int value, Position position)
    {
        if (_numbers[position.Row, position.Column] is not null)
        {
            throw new Exception($"Value already exists on position {position}.");
        }

        _numbers[position.Row, position.Column] = new(value, true);
        noOfSetNumbers++;
    }

    public static bool IsValidIndex(int index)
        => index >= 0 && index < 9;

    public override string ToString()
    {
        StringBuilder sb = new();

        for(int column = 0; column < 9; column++)
        {
            for(int row = 0; row < 9; row++)
            {
                var valueStr = GetValue(row, column)?.ToString() ?? " ";
                sb.Append(valueStr);

                if (row == 2 || row == 5)
                {
                    sb.Append('|');
                }
            }

            sb.AppendLine();

            if (column == 2 || column == 5)
            {
                sb.Append("-----------");

                sb.AppendLine();
            }
        }

        return sb.ToString();
    }
}

