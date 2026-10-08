import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_draft_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/models/completed_comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_decision/viewmodels/comparison_decision_viewmodel.dart';

void main() {
  final draft = ComparisonDraftModel(theme: 'Tema');

  test('completion rejects undecided side', () {
    expect(
      () => CompletedComparisonModel(
        draft: draft,
        selectedSide: SelectedSide.undecided,
      ),
      throwsArgumentError,
    );
  });

  test('confirmation requires selection and completes only once', () {
    final viewModel = ComparisonDecisionViewModel();
    addTearDown(viewModel.dispose);
    expect(viewModel.confirm(draft), isNull);
    viewModel.selectSide(SelectedSide.undecided);
    expect(viewModel.canConfirm, isFalse);
    viewModel.selectSide(SelectedSide.pros);
    expect(viewModel.confirm(draft)?.selectedSide, SelectedSide.pros);
    expect(viewModel.canConfirm, isFalse);
    expect(viewModel.completedComparison!.draft, same(draft));
    expect(viewModel.completedComparison!.selectedSide, SelectedSide.pros);
    viewModel.selectSide(SelectedSide.cons);
    expect(viewModel.selectedSide, SelectedSide.pros);
    expect(viewModel.confirm(draft), isNull);
  });
}
