import 'package:flutter/foundation.dart';
import '../../../models/comparison_model.dart';
import '../../../models/comparison_draft_model.dart';
import '../../../models/completed_comparison_model.dart';

class ComparisonDecisionViewModel extends ChangeNotifier {
  SelectedSide? _selectedSide;
  CompletedComparisonModel? _completedComparison;
  CompletedComparisonModel? get completedComparison => _completedComparison;
  SelectedSide? get selectedSide => _selectedSide;
  bool get canConfirm => _selectedSide != null && _completedComparison == null;

  void selectSide(SelectedSide side) {
    if (_completedComparison != null ||
        side == SelectedSide.undecided ||
        side == _selectedSide) {
      return;
    }
    _selectedSide = side;
    notifyListeners();
  }

  CompletedComparisonModel? confirm(ComparisonDraftModel draft) {
    if (!canConfirm) return null;
    final completed = CompletedComparisonModel(
      draft: draft,
      selectedSide: _selectedSide!,
    );
    _completedComparison = completed;
    notifyListeners();
    return completed;
  }
}
