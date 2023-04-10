import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../config.dart' as config;
import '../engine/game.dart';

class Loader {
  static final JsonDecoder _decoder = JsonDecoder();

  static Future<Game> loadRandomGame() async {
    var templates = await _readFilesFromDirectory(config.templatesPath);
    var template = _getRandomValueFromList(templates);

    var values = await _loadTemplate(template);

    return Game(values);
  }

  static Future<List<String>> _readFilesFromDirectory(
      String directoryPath) async {
    final dir = Directory(directoryPath);
    final entities = await dir.list().toList();

    return entities.map((e) => e.path).toList();
  }

  static String _getRandomValueFromList(List<String> values) {
    final random = Random();

    return values[random.nextInt(values.length)];
  }

  static Future<List<List<int?>>> _loadTemplate(String templatePath) async {
    final fileContents = await File(templatePath).readAsString();
    final Map<String, dynamic> jsonmap = _decoder.convert(fileContents);

    List<List<int>> convertedItems = (jsonmap['Grid'] as List<dynamic>)
        .map((l) => List<int>.from(l))
        .toList();

    return convertedItems
        .map((e) => e.map((value) => value == 0 ? null : value).toList())
        .toList();
  }
}
