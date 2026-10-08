import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_result_model.dart';

abstract class IComparisonRepository {
  AsyncComparisonResultModel<ComparisonModel> startComparisonAsync();
}
