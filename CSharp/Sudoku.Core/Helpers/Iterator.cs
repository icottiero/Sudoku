using System;
namespace Sudoku.Core.Helpers;

public static class Iterator
{
	public static void Iterate9Times(int?[] array, Action<int?[], int> action)
	{
		for (var i = 0; i < 9; i++)
		{
			action(array, i);
		}
	}
}

