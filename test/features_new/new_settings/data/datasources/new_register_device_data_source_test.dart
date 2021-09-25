import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/core_new/device_info/device_info.dart';
import 'package:tautulli_remote/rewrite/features_new/new_onesignal/data/datasources/new_onesignal_data_source.dart';
import 'package:tautulli_remote/rewrite/core_new/api/tautulli_api/new_tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/datasources/new_register_device_data_source.dart';

class MockDeviceInfo extends Mock implements DeviceInfoImpl {}

class MockOnesignalDataSource extends Mock
    implements NewOnesignalDataSourceImpl {}

class MockRegisterDevice extends Mock
    implements tautulli_api.NewRegisterDeviceImpl {}

void main() {
  final mockDeviceInfo = MockDeviceInfo();
  final mockOnesignalDataSource = MockOnesignalDataSource();
  final mockRegisterDevice = MockRegisterDevice();
  final datasource = NewRegisterDeviceDataSourceImpl(
    deviceInfo: mockDeviceInfo,
    oneSignal: mockOnesignalDataSource,
    apiRegisterDevice: mockRegisterDevice,
  );

  const String tConnectionProtocol = 'http';
  const String tConnectionDomain = 'tautulli.com';
  const String tConnectionPath = '/tautulli';
  const String tDeviceToken = 'abc';
  const String tDeviceName = 'test';
  const String tDeviceId = 'lmn';
  const String tOnesignalId = 'xyz';
  const String tPlatform = 'android';
  const String tAppVersion = '2.10.0';

  Map<String, dynamic> tResponse = {
    'responseData': {
      "response": {
        "result": "success",
        "data": {
          "pms_name": "Starlight",
          "server_id": "<tautulli_server_id>",
          'tautulli_version': 'v0.0.0',
        }
      }
    },
    'primaryActive': true,
  };

  void setUpSuccess() {
    when(
      () => mockRegisterDevice(
        connectionProtocol: any(named: 'connectionProtocol'),
        connectionDomain: any(named: 'connectionDomain'),
        connectionPath: any(named: 'connectionPath'),
        deviceToken: any(named: 'deviceToken'),
        deviceId: any(named: 'deviceId'),
        deviceName: any(named: 'deviceName'),
        onesignalId: any(named: 'onesignalId'),
        platform: any(named: 'platform'),
        version: any(named: 'version'),
      ),
    ).thenAnswer((_) async => tResponse);
    when(() => mockDeviceInfo.model).thenAnswer((_) async => tDeviceName);
    when(() => mockDeviceInfo.uniqueId).thenAnswer((_) async => tDeviceId);
    when(() => mockDeviceInfo.appVersion).thenAnswer((_) async => tAppVersion);
    when(() => mockDeviceInfo.platform).thenAnswer((_) async => tPlatform);
    when(() => mockOnesignalDataSource.userId).thenAnswer(
      (_) async => tOnesignalId,
    );
  }

  group('register device data source', () {
    test(
      'should query DeviceInfo & Onesignal for model, uniqueId, appVersion, platform, and userId',
      () async {
        // arrange
        setUpSuccess();
        // act
        await datasource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(() => mockDeviceInfo.model).called(1);
        verify(() => mockDeviceInfo.uniqueId).called(1);
        verify(() => mockDeviceInfo.appVersion).called(1);
        verify(() => mockDeviceInfo.platform).called(1);
        verify(() => mockOnesignalDataSource.userId).called(1);
      },
    );

    test(
      'should call registerDevice from Tautulli API',
      () async {
        // arrange
        setUpSuccess();
        // act
        await datasource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(
          () => mockRegisterDevice(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionPath: tConnectionPath,
            deviceToken: tDeviceToken,
            deviceId: tDeviceId,
            deviceName: tDeviceName,
            onesignalId: tOnesignalId,
            platform: tPlatform,
            version: tAppVersion,
          ),
        );
      },
    );

    test(
      'should return Map with response data',
      () async {
        // arrange
        setUpSuccess();
        // act
        final response = await datasource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        expect(response, equals(tResponse['responseData']['response']['data']));
      },
    );
  });
}
