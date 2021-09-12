import 'package:dartz/dartz.dart';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/error/new_failure.dart';
import '../../../../core_new/helpers/new_failure_helper.dart';
import '../../../../core_new/network_info/new_network_info.dart';
import '../../domain/repositories/new_geo_ip_repository.dart';
import '../datasources/new_geo_ip_data_source.dart';

class NewGeoIpRepositoryImpl implements NewGeoIpRepository {
  final NewGeoIpDataSource dataSource;
  final NewNetworkInfo networkInfo;

  NewGeoIpRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<NewFailure, ApiResponseData>> getGeoIp({
    required String tautulliId,
    required String ipAddress,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final geoIpData = await dataSource.getGeoIp(
          tautulliId: tautulliId,
          ipAddress: ipAddress,
        );
        return Right(geoIpData);
      } catch (exception) {
        final NewFailure failure =
            NewFailureHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
