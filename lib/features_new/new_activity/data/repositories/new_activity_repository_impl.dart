import 'package:dartz/dartz.dart';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/error/new_failure.dart';
import '../../../../core_new/helpers/new_failure_mapper_helper.dart';
import '../../../../core_new/network_info/new_network_info.dart';
import '../../domain/repositories/new_activity_repository.dart';
import '../datasources/new_activity_data_source.dart';

class NewActivityRepositoryImpl implements NewActivityRepository {
  final NewActivityDataSource dataSource;
  final NewNetworkInfo networkInfo;

  NewActivityRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<NewFailure, ApiResponseData>> getActivity({
    required String tautulliId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final activityData = await dataSource.getActivity(
          tautulliId: tautulliId,
        );
        return Right(activityData);
      } catch (exception) {
        final NewFailure failure =
            NewFailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
