import '../error/new_exception.dart';
import '../error/new_failure.dart';

class NewFailureMapperHelper {
  /// Map [Exception] to corresponding [Failure].
  static NewFailure mapExceptionToFailure(dynamic exception) {
    switch (exception) {
      case (ServerException):
        return ServerFailure();
      default:
        return GenericFailure();
    }
  }
}
