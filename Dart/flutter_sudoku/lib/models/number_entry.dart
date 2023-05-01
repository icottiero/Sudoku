import 'package:flutter/material.dart';

class NumberEntry extends ChangeNotifier {
  NumberEntry(this._value);

  int? _value;

  String printValue() {
    return _value == null ? ' ' : '$_value';
  }

  int? getValue() => _value;
  void setValue(int? value) {
    _value = value;
    notifyListeners();
  }
}
