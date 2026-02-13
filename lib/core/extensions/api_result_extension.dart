import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:fpdart/fpdart.dart';

extension ApiResultExt<T> on ApiResult<T> {
  /// Convert ApiResult to Either
  /// Left: ApiFailure (error)
  /// Right: ApiSuccess (success)
  Either<ApiFailure<T>, ApiSuccess<T>> toEither() {
    return switch (this) {
      ApiSuccess<T> success => Right(success),
      ApiFailure<T> failure => Left(failure),
      ApiCursorSuccess<T>() => throw UnimplementedError(
        'ApiCursorSuccess not yet supported in toEither. Use toEitherCursor instead.',
      ),
    };
  }

  /// Convert ApiCursorSuccess to Either
  /// For paginated/cursor-based responses
  Either<ApiFailure<T>, ApiCursorSuccess<T>> toEitherCursor() {
    return switch (this) {
      ApiCursorSuccess<T> success => Right(success),
      ApiFailure<T> failure => Left(failure),
      ApiSuccess<T>() => throw UnimplementedError(
        'ApiSuccess cannot be converted to ApiCursorSuccess. Use toEither instead.',
      ),
    };
  }
}
