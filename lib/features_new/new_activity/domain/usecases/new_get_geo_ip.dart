import 'package:dartz/dartz.dart';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/error/new_failure.dart';
import '../repositories/new_geo_ip_repository.dart';

class NewGetGeoIp {
  final NewGeoIpRepository repository;

  NewGetGeoIp(this.repository);

  /// Returns an `ApiResponseData` object that contains a
  /// `NewGeoIpModel` under `data` and a `bool` under `primaryActive`.
  Future<Either<NewFailure, ApiResponseData>> call({
    required String tautulliId,
    required String ipAddress,
  }) async {
    return await repository.getGeoIp(
      tautulliId: tautulliId,
      ipAddress: ipAddress,
    );
  }
}
