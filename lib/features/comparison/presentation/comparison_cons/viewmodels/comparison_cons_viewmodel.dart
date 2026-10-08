import 'package:flutter/foundation.dart';

class ComparisonConsViewModel extends ChangeNotifier {
  final List<String> _cons = [];

  List<String> get cons => List.unmodifiable(_cons);

  void replaceCons(List<String> arguments) {
    _cons
      ..clear()
      ..addAll(arguments);
    notifyListeners();
  }

  bool addCon(String value) {
    final argument = value.trim();
    if (argument.isEmpty) return false;
    _cons.add(argument);
    notifyListeners();
    return true;
  }

  bool updateCon(int index, String value) {
    final argument = value.trim();
    if (index < 0 || index >= _cons.length || argument.isEmpty) return false;
    if (_cons[index] == argument) return true;
    _cons[index] = argument;
    notifyListeners();
    return true;
  }

  bool removeCon(int index) {
    if (index < 0 || index >= _cons.length) return false;
    _cons.removeAt(index);
    notifyListeners();
    return true;
  }
}
