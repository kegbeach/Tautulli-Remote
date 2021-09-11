import 'package:dartz/dartz.dart';

import '../../../../core_new/error/new_failure.dart';
import '../../../../core_new/helpers/new_failure_helper.dart';
import '../../../../core_new/network_info/new_network_info.dart';
import '../../domain/repositories/new_register_device_repository.dart';
import '../datasources/new_register_device_data_source.dart';

class NewRegisterDeviceRepositoryImpl implements NewRegisterDeviceRepository {
  final NewRegisterDeviceDataSource dataSource;
  final NewNetworkInfo networkInfo;

  NewRegisterDeviceRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<NewFailure, Map<String, dynamic>>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    bool trustCert = false,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource(
          connectionProtocol: connectionProtocol,
          connectionDomain: connectionDomain,
          connectionPath: connectionPath,
          deviceToken: deviceToken,
          trustCert: trustCert,
        );
        return Right(response);
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
