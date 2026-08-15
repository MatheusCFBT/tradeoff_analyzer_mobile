import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_result.dart';

abstract class IComparisonRepository {
  AsyncComparisonResult<ComparisonModel> startComparisonAsync();
}