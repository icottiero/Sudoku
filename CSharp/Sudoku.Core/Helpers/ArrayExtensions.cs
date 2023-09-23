using System;
namespace Sudoku.Core.Helpers;

internal static class ArrayExtensions
{
    public static bool ContainsValue(this int?[] array, int value, out int? foundAtIndex)
    {
        for (int i = 0; i < 9; i++)
        {
            if (array[i] == value)
            {
                foundAtIndex = i;
                return true;
            }
        }
        foundAtIndex = null;
        return false;
    }
}
