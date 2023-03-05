namespace Sudoku.Models;

public record Template(int[][] Grid)
{
    public void Validate()
    {
        if (Grid is null) {
            throw new Exception("Grid is null!");
        }
    }
}