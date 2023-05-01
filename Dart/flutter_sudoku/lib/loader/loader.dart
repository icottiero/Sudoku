import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_sudoku/models/number_entry.dart';

import '../config.dart' as config;

class Loader {
  static final JsonDecoder _decoder = JsonDecoder();

  static Future<List<List<NumberEntry>>> loadRandomGame() async {
    var templates = await _readFilesFromDirectory(config.templatesPath);
    var template = _getRandomValueFromList(templates);

    var values = await _loadTemplate(template);

    return values;
  }

  static Future loadRandomGameInto(
      List<List<NumberEntry>> existingTable) async {
    var values = await loadRandomValues();
    for (int columnIndex = 0; columnIndex < 9; columnIndex++) {
      for (int rowIndex = 0; rowIndex < 9; rowIndex++) {
        existingTable[rowIndex][columnIndex]
            .setValue(values[rowIndex][columnIndex].getValue());
      }
    }
  }

  static Future<List<List<NumberEntry>>> loadRandomValues() async {
    var templates = await _readFilesFromDirectory(config.templatesPath);
    var template = _getRandomValueFromList(templates);

    return await _loadTemplate(template);
  }

  static Future<List<String>> _readFilesFromDirectory(
      String directoryPath) async {
    final dir = Directory(directoryPath);

    if (!await dir.exists()) {
      throw Exception("The specified directory doesn't exist: $dir");
    }
    final entities = await dir.list().toList();

    return entities.map((e) => e.path).toList();
  }

  static String _getRandomValueFromList(List<String> values) {
    final random = Random();

    return values[random.nextInt(values.length)];
  }

  static Future<List<List<NumberEntry>>> _loadTemplate(
      String templatePath) async {
    final fileContents = await File(templatePath).readAsString();
    final Map<String, dynamic> jsonmap = _decoder.convert(fileContents);

    List<List<int>> convertedItems = (jsonmap['Grid'] as List<dynamic>)
        .map((l) => List<int>.from(l))
        .toList();

    return convertedItems
        .map((e) => e
            .map((value) => value == 0 ? NumberEntry(null) : NumberEntry(value))
            .toList())
        .toList();
  }
}
