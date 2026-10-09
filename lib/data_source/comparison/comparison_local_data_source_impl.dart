import 'package:tradeoff_analyzer_mobile/features/comparison/models/completed_comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/data_source/comparison/comparison_local_data_source_interface.dart';

class ComparisonLocalDataSource extends IComparisonLocalDataSource {
  CompletedComparisonModel? _lastCompletedComparison;

  @override
  void saveCompletedComparison(CompletedComparisonModel comparison) {
    _lastCompletedComparison = comparison;
  }

  @override
  CompletedComparisonModel? getLastCompletedComparison() =>
      _lastCompletedComparison;
}
