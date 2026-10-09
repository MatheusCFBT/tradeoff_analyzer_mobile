import 'package:tradeoff_analyzer_mobile/features/comparison/models/completed_comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/data_source/comparison/comparison_local_data_source_interface.dart';
import 'package:tradeoff_analyzer_mobile/data_source/comparison/comparison_remote_data_source_interface.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_repository_interface.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_result_model.dart';

typedef LoanConsigAction<T> = Future<T> Function();

class ComparisonRepository extends IComparisonRepository {
  ComparisonRepository({
    required IComparisonLocalDataSource localDataSource,
    required IComparisonRemoteDataSource dataSource,
  }) : _localDataSource = localDataSource,
       _dataSource = dataSource;

  final IComparisonLocalDataSource _localDataSource;

  @override
  void saveCompletedComparison(CompletedComparisonModel comparison) =>
      _localDataSource.saveCompletedComparison(comparison);

  @override
  CompletedComparisonModel? getLastCompletedComparison() =>
      _localDataSource.getLastCompletedComparison();

  final IComparisonRemoteDataSource _dataSource;

  @override
  AsyncComparisonResultModel<ComparisonModel> startComparisonAsync() async {
    return _runAsync(() => _dataSource.startComparison());
  }

  AsyncComparisonResultModel<T> _runAsync<T>(LoanConsigAction action) async {
    try {
      final result = await action();
      return ComparisonSuccessModel(result);
    } on FormatException catch (error) {
      //TODO loggar
      return ComparisonFailureModel(error);
    } catch (error) {
      return ComparisonFailureModel(error);
    }
    // TODO Colocar exception de connection
  }
}
