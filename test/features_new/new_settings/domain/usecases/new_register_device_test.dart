import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/data/repositories/new_register_device_repository_impl.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/domain/usecases/new_register_device.dart';

class MockRegisterDeviceRepository extends Mock
    implements NewRegisterDeviceRepositoryImpl {}

void main() {
  final mockRepository = MockRegisterDeviceRepository();
  final usecase = NewRegisterDevice(mockRepository);

  const String tConnectionProtocol = 'http';
  const String tConnectionDomain = 'tautulli.com';
  const String tConnectionPath = '/tautulli';
  const String tDeviceToken = 'abc';

  test(
    'should return a Map with response data when device registration is successful',
    () async {
      // arrange
      final Map<String, dynamic> responseMap = {
        "pms_name": "Starlight",
        "server_id": "<tautulli_server_id>",
        'tautulli_version': 'v0.0.0',
      };
      when(
        () => mockRepository(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        ),
      ).thenAnswer((_) async => Right(responseMap));
      // act
      final response = await usecase(
        connectionProtocol: tConnectionProtocol,
        connectionDomain: tConnectionDomain,
        connectionPath: tConnectionPath,
        deviceToken: tDeviceToken,
      );
      // assert
      expect(response, equals(Right(responseMap)));
    },
  );
}
