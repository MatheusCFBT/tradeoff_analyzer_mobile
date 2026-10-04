import 'package:flutter/foundation.dart';

class ComparisonProsViewModel extends ChangeNotifier {
  final List<String> _pros = [];

  List<String> get pros => List.unmodifiable(_pros);

  bool addPro(String value) {
    final argument = value.trim();
    if (argument.isEmpty) return false;
    _pros.add(argument);
    notifyListeners();
    return true;
  }
}
