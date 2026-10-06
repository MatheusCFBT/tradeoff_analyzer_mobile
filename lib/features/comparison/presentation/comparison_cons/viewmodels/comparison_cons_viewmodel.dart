import 'package:flutter/foundation.dart';

class ComparisonConsViewModel extends ChangeNotifier {
  final List<String> _cons = [];

  List<String> get cons => List.unmodifiable(_cons);

  bool addCon(String value) {
    final argument = value.trim();
    if (argument.isEmpty) return false;
    _cons.add(argument);
    notifyListeners();
    return true;
  }
}
