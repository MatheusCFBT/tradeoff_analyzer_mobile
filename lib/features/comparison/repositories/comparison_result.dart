import 'package:equatable/equatable.dart';

typedef AsyncComparisonResult<T> = Future<ComparisonResult<T>>;

sealed class ComparisonResult<T> extends Equatable {
  const ComparisonResult();

  bool get isSuccess => this is ComparisonSuccess<T>;
  bool get isFailuer => this is ComparisonFailure;

  T? getValueOrNull() {
    if (this is ComparisonSuccess<T>) return (this as ComparisonSuccess<T>).value;
    return null;
  }

  Object? getErrorOrNull() {
    if (this is ComparisonFailure) return (this as ComparisonFailure).error;
    return null;
  }
}

final class ComparisonSuccess<T> extends ComparisonResult<T>{
  const ComparisonSuccess(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}

final class ComparisonFailure extends ComparisonResult<Never> {
  const ComparisonFailure(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
} 