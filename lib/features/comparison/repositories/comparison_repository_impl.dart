import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_repository_interface.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_result.dart';

class ComparisonRepositoryImpl extends IComparisonRepository {
  @override
  AsyncComparisonResult<ComparisonModel> startComparisonAsync() async {
    var comparison = ComparisonModel(id: "asd");
    return ComparisonSuccess(comparison);
  }
}