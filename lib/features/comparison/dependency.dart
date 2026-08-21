import 'package:get_it/get_it.dart';
import 'package:tradeoff_analyzer_mobile/data_source/comparison/comparison_local_data_source_impl.dart';
import 'package:tradeoff_analyzer_mobile/data_source/comparison/comparison_local_data_source_interface.dart';
import 'package:tradeoff_analyzer_mobile/data_source/comparison/comparison_remote_data_source_impl.dart';
import 'package:tradeoff_analyzer_mobile/data_source/comparison/comparison_remote_data_source_interface.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_start/viewmodels/comparison_start_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_repository_impl.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_repository_interface.dart';

void setupComparisonDependencies() { // TODO VERIFICAR SE É O MELHOR LIFETIME
  GetIt.instance
    ..registerFactory<IComparisonRemoteDataSource>(
      () => ComparisonRemoteDataSource()
    )
    ..registerLazySingleton<IComparisonLocalDataSource>(
      () => ComparisonLocalDataSource()
    )
    ..registerFactory<IComparisonRepository>(
      () => ComparisonRepository(
        localDataSource: GetIt.instance.get(), 
        dataSource: GetIt.instance.get()
      )
    )
    ..registerFactory(
      () => ComparisonStartViewModel(
        repository: GetIt.instance.get()
      )
    );
}