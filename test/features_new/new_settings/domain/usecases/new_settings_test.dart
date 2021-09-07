import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/core_new/database/data/models/new_server_model.dart';
import 'package:tautulli_remote/features_new/new_settings/domain/repositories/new_settings_repository.dart';
import 'package:tautulli_remote/features_new/new_settings/domain/usecases/new_settings.dart';

class MockSettingsRepository extends Mock implements NewSettingsRepository {}

void main() {
  final mockSettingsRepository = MockSettingsRepository();
  final settings = NewSettings(mockSettingsRepository);

  const int tServerTimeout = 15;

  NewServerModel tServerModel = NewServerModel(
    plexName: 'Plex',
    plexIdentifier: '123abc',
    tautulliId: '456def',
    primaryConnectionAddress: 'http://192.168.0.10:8181',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: '192.168.0.10:8181',
    deviceToken: 'xyz',
    primaryActive: true,
    onesignalRegistered: true,
    plexPass: true,
  );

  test(
    'getCustomCertHashList should get list of custom cert hashes from settings',
    () async {
      // arrange
      when(() => mockSettingsRepository.getCustomCertHashList()).thenAnswer(
        (_) async => [1, 2],
      );
      // act
      final result = await settings.getCustomCertHashList();
      // assert
      expect(result, equals([1, 2]));
      verify(() => mockSettingsRepository.getCustomCertHashList()).called(1);
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setCustomCertHashList should forward the request to the repository',
    () async {
      // arrange
      when(() => mockSettingsRepository.setCustomCertHashList([1, 2]))
          .thenAnswer(
        (_) async => Future.value(true),
      );
      // act
      await settings.setCustomCertHashList([1, 2]);
      // assert
      verify(() => mockSettingsRepository.setCustomCertHashList([1, 2]))
          .called(1);
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getServerByTautulliId should get the Server Model from the database',
    () async {
      // arrange
      when(() => mockSettingsRepository.getServerByTautulliId(any()))
          .thenAnswer((_) async => tServerModel);
      // act
      final result =
          await settings.getServerByTautulliId(tServerModel.tautulliId);
      // assert
      expect(result, equals(tServerModel));
      verify(() => mockSettingsRepository.getServerByTautulliId(any()))
          .called(1);
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getServerTimeout should get server timeout from settings',
    () async {
      // arrange
      when(() => mockSettingsRepository.getServerTimeout()).thenAnswer(
        (_) async => tServerTimeout,
      );
      // act
      final result = await settings.getServerTimeout();
      // assert
      expect(result, equals(tServerTimeout));
      verify(() => mockSettingsRepository.getServerTimeout()).called(1);
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setServerTimeout should forward request to the repository',
    () async {
      // arrange
      when(
        () => mockSettingsRepository.setServerTimeout(tServerTimeout),
      ).thenAnswer((_) async => Future.value(true));
      // act
      await settings.setServerTimeout(tServerTimeout);
      // assert
      verify(
        () => mockSettingsRepository.setServerTimeout(tServerTimeout),
      ).called(1);
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
