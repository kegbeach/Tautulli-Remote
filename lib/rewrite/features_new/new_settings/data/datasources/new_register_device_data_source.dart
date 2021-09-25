import '../../../../core_new/api/tautulli_api/new_tautulli_api.dart'
    as tautulli_api;
import '../../../../core_new/device_info/device_info.dart';
import '../../../../core_new/error/new_exception.dart';
import '../../../new_onesignal/data/datasources/new_onesignal_data_source.dart';

abstract class NewRegisterDeviceDataSource {
  Future<Map<String, dynamic>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    bool trustCert,
  });
}

class NewRegisterDeviceDataSourceImpl implements NewRegisterDeviceDataSource {
  final DeviceInfo deviceInfo;
  final NewOnesignalDataSource oneSignal;
  final tautulli_api.NewRegisterDevice apiRegisterDevice;

  NewRegisterDeviceDataSourceImpl({
    required this.deviceInfo,
    required this.oneSignal,
    required this.apiRegisterDevice,
  });

  @override
  Future<Map<String, dynamic>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    bool trustCert = false,
  }) async {
    final String deviceId = await deviceInfo.uniqueId ?? 'unknown';
    final String deviceName = await deviceInfo.model ?? 'unknown';
    final String version = await deviceInfo.appVersion;
    final String onesignalId = await oneSignal.userId;

    final response = await apiRegisterDevice(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      deviceId: deviceId,
      deviceName: deviceName,
      onesignalId: onesignalId,
      platform: await deviceInfo.platform,
      version: version,
      trustCert: trustCert,
    );

    // If the response result is not success throw ServerException.
    if (response['responseData']['response']['result'] != 'success') {
      throw ServerException();
    }

    final Map<String, dynamic> responseData =
        response['responseData']['response']['data'];

    // If response data is missing tautulli_version throw ServerVersionException.
    if (!responseData.containsKey('tautulli_version')) {
      throw ServerVersionException();
    }

    return responseData;
  }
}
