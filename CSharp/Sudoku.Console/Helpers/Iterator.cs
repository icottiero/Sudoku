using System;
namespace Sudoku.Console;

public static class Iterator
{
	public static void Iterate9Times(int?[] array, Action<int?[], int> action)
	{
		for (int i = 0; i < 9; i++)
		{
			action(array, i);
		}
	}
}

