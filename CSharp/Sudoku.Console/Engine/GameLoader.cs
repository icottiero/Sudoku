using System.Text.Json;
using Sudoku.Console;
using Sudoku.Helpers;
using Sudoku.Models;

namespace Sudoku.Engine;

public static class GameLoader
{
    public static Game LoadNewGame() 
    {
        var path = GetRandomTemplatePath();

        var template = LoadTemplateFromFile(path);

        template.Validate();

        var table = new Table(template);

        return new Game(table);
    }

    private static Template LoadTemplateFromFile(string path)
    {
        var contents = File.ReadAllText(path);
        var result = JsonSerializer.Deserialize<Template>(contents);

        if (result == null)
        {
            throw new Exception($"The template file was not a valid template: {path}");
        }

        return result;
    }

    private static string GetRandomTemplatePath()
    {
        var templates = GetTemplates();

        var random = new Random((int)DateTime.Now.Ticks);

        return templates[random.Next(templates.Count())];
    }

    private static string[] GetTemplates()
    {
        var files = Directory.GetFiles(Config.TemplatesPath);
        
        if (!files.Any()) 
        {
            throw new Exception($"No tempaltes were found at {Config.TemplatesPath}");
        }

        return files;
    }
}