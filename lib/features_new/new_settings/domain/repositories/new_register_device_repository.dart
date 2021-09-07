import 'package:dartz/dartz.dart';

import '../../../../core_new/error/new_failure.dart';

abstract class NewRegisterDeviceRepository {
  Future<Either<NewFailure, Map<String, dynamic>>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    bool trustCert,
  });
}
