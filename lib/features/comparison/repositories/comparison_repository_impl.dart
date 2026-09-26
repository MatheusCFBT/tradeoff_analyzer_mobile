import 'package:tradeoff_analyzer_mobile/data_source/comparison/comparison_local_data_source_interface.dart';
import 'package:tradeoff_analyzer_mobile/data_source/comparison/comparison_remote_data_source_interface.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_repository_interface.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_result.dart';

typedef LoanConsigAction<T> = Future<T> Function();

class ComparisonRepository extends IComparisonRepository {
  ComparisonRepository({
    required IComparisonLocalDataSource localDataSource,
    required IComparisonRemoteDataSource dataSource
  }) :  _localDataSource = localDataSource,
        _dataSource = dataSource;

  final IComparisonLocalDataSource _localDataSource;
  final IComparisonRemoteDataSource _dataSource;

  @override
  AsyncComparisonResult<ComparisonModel> startComparisonAsync() async {
    return _runAsync(() => _dataSource.startComparison());
  }

  AsyncComparisonResult<T> _runAsync<T>(LoanConsigAction action) async {
    try {
      final result = await action();
      return ComparisonSuccess(result);
    } on FormatException catch (error, stackTrace) {
      //TODO loggar
      return ComparisonFailure(error);
    } catch (error, stackTrace) {
      return ComparisonFailure(error);
    }
    // TODO Colocar exception de connection 
  }
}