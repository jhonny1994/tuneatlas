import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// Result type for handling success/failure
/// Wraps API responses and errors in a type-safe way
@freezed
class Result<T> with _$Result<T> {
  /// Success state with data
  const factory Result.success(T data) = Success<T>;

  /// Failure state with error message
  const factory Result.failure(String error) = Failure<T>;
}
