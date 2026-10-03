import 'package:flutter/foundation.dart';

class ComparisonArgumentsViewModel extends ChangeNotifier {
  final List<String> _pros = [];

  List<String> get pros => List.unmodifiable(_pros);

  bool addArgument(String value) {
    final argument = value.trim();
    if (argument.isEmpty) return false;
    _pros.add(argument);
    notifyListeners();
    return true;
  }
}
