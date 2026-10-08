import 'package:flutter/foundation.dart';

class ComparisonProsViewModel extends ChangeNotifier {
  final List<String> _pros = [];

  List<String> get pros => List.unmodifiable(_pros);

  void replacePros(List<String> arguments) {
    _pros
      ..clear()
      ..addAll(arguments);
    notifyListeners();
  }

  bool addPro(String value) {
    final argument = value.trim();
    if (argument.isEmpty) return false;
    _pros.add(argument);
    notifyListeners();
    return true;
  }

  bool updatePro(int index, String value) {
    final argument = value.trim();
    if (index < 0 || index >= _pros.length || argument.isEmpty) return false;
    if (_pros[index] == argument) return true;
    _pros[index] = argument;
    notifyListeners();
    return true;
  }

  bool removePro(int index) {
    if (index < 0 || index >= _pros.length) return false;
    _pros.removeAt(index);
    notifyListeners();
    return true;
  }
}
