import 'package:dartz/dartz.dart';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/error/new_failure.dart';

abstract class NewGeoIpRepository {
  Future<Either<NewFailure, ApiResponseData>> getGeoIp({
    required String tautulliId,
    required String ipAddress,
  });
}
