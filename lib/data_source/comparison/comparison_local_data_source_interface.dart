import 'package:tradeoff_analyzer_mobile/features/comparison/models/completed_comparison_model.dart';

abstract class IComparisonLocalDataSource {
  void saveCompletedComparison(CompletedComparisonModel comparison);
  CompletedComparisonModel? getLastCompletedComparison();
}
