import 'package:equatable/equatable.dart';

typedef AsyncComparisonResultModel<T> = Future<ComparisonResultModel<T>>;

sealed class ComparisonResultModel<T> extends Equatable {
  const ComparisonResultModel();

  bool get isSuccess => this is ComparisonSuccessModel<T>;
  bool get isFailuer => this is ComparisonFailureModel;

  T? getValueOrNull() {
    if (this is ComparisonSuccessModel<T>) {
      return (this as ComparisonSuccessModel<T>).value;
    }
    return null;
  }

  Object? getErrorOrNull() {
    if (this is ComparisonFailureModel) {
      return (this as ComparisonFailureModel).error;
    }
    return null;
  }
}

final class ComparisonSuccessModel<T> extends ComparisonResultModel<T> {
  const ComparisonSuccessModel(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}

final class ComparisonFailureModel extends ComparisonResultModel<Never> {
  const ComparisonFailureModel(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}
