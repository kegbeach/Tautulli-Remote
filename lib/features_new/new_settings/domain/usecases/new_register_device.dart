import 'package:dartz/dartz.dart';

import '../../../../core_new/error/new_failure.dart';
import '../repositories/new_register_device_repository.dart';

class NewRegisterDevice {
  final NewRegisterDeviceRepository repository;

  NewRegisterDevice(this.repository);

  /// Used to register with a Tautulli server.
  ///
  /// When successfull returns a map with the `pms_id`, `server_id`, and
  /// `tautulli_version`.
  ///
  /// Set `trustCert` to true to add the certificate's hash to a list of user
  /// trusted certificates that could not be authenticated by
  /// any of the built in trusted root certificates.
  Future<Either<NewFailure, Map<String, dynamic>>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    bool trustCert = false,
  }) async {
    return await repository(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      trustCert: trustCert,
    );
  }
}
