import 'package:dartz/dartz.dart';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/error/new_failure.dart';

abstract class NewActivityRepository {
  Future<Either<NewFailure, ApiResponseData>> getActivity({
    required String tautulliId,
  });
}
