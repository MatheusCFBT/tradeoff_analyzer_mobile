import 'comparison_draft_model.dart';
import 'comparison_model.dart';

class CompletedComparisonModel {
  CompletedComparisonModel({required this.draft, required this.selectedSide}) {
    if (selectedSide == SelectedSide.undecided) {
      throw ArgumentError.value(selectedSide, 'selectedSide');
    }
  }
  final ComparisonDraftModel draft;
  final SelectedSide selectedSide;
}
