using Sudoku.Engine;
using Sudoku.Models;

Console.WriteLine("Hello, World!");

var sudoku = GameLoader.LoadNewGame();

Console.Write("The game has started.");

Console.WriteLine();
Console.WriteLine(sudoku);

int value, row, column;

while(!sudoku.IsDone())
{
    Console.Write("Enter the new value: ");

    var input = Console.ReadKey();
    Console.WriteLine();

    while(!int.TryParse($"{input.KeyChar}", out value))
    {
        Console.Write("That is not a number. The value must be a number. Enter the value:");
        input = Console.ReadKey();
        Console.WriteLine();
    }

    Console.Write($"Write the row number: ");
    input = Console.ReadKey();
    Console.WriteLine();

    while (!int.TryParse($"{input.KeyChar}", out row))
    {
        Console.Write("That is not a number. The row must be a number. Enter the value:");
        input = Console.ReadKey();
        Console.WriteLine();
    }

    Console.Write($"Write the column number: ");
    input = Console.ReadKey();
    Console.WriteLine();

    while (!int.TryParse($"{input.KeyChar}", out column))
    {
        Console.Write("That is not a number. The column must be a number. Enter the value:");
        input = Console.ReadKey();
        Console.WriteLine();
    }

    Position position;

    try
    {
        position = new Position(row - 1, column - 1);
    }
    catch (Exception ex)
    {
        Console.WriteLine(ex.Message);
        Console.WriteLine("Congrats, now try again.");
        continue;
    }
    var result = sudoku.TrySetNumber(value, position);

    if (result.Success)
    {
        Console.WriteLine();
        Console.WriteLine(sudoku);
        Console.WriteLine();
    }
    else
    {
        Console.WriteLine(result.ErrorMessage);
    }
}