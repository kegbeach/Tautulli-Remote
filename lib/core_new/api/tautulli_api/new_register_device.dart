import '../../new_requirements/versions.dart';
import 'new_connection_handler.dart';

abstract class NewRegisterDevice {
  Future<Map<String, dynamic>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    required String deviceId,
    required String deviceName,
    required String onesignalId,
    required String platform,
    required String version,
    bool trustCert,
  });
}

class NewRegisterDeviceImpl implements NewRegisterDevice {
  final NewConnectionHandler connectionHandler;

  NewRegisterDeviceImpl(this.connectionHandler);

  @override
  Future<Map<String, dynamic>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    required String deviceId,
    required String deviceName,
    required String onesignalId,
    required String platform,
    required String version,
    bool trustCert = false,
  }) async {
    final response = await connectionHandler(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      cmd: 'register_device',
      params: {
        'device_name': deviceName,
        'device_id': deviceId,
        'onesignal_id': onesignalId,
        'min_version': 'v${MinimumVersion.tautulliServer}',
        'platform': platform,
        'version': version,
      },
      trustCert: trustCert,
    );

    return response;
  }
}
