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
    sortIndex: 1,
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
    'addServer should return the database ID of the added server',
    () async {
      // arrange
      when(() => mockSettingsRepository.addServer(tServerModel)).thenAnswer(
        (_) async => 1,
      );
      // act
      final serverId = await settings.addServer(tServerModel);
      // assert
      expect(serverId, equals(1));
      verify(() => mockSettingsRepository.addServer(tServerModel)).called(1);
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'deleteServer should forward the request to the repository',
    () async {
      /// arrange
      when(() => mockSettingsRepository.deleteServer(1)).thenAnswer(
        (_) async => Future.value(),
      );
      // act
      await settings.deleteServer(1);
      // assert
      verify(() => mockSettingsRepository.deleteServer(1)).called(1);
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getAllServers should return a list of all servers from the database',
    () async {
      /// arrange
      when(() => mockSettingsRepository.getAllServers()).thenAnswer(
        (_) async => [tServerModel],
      );
      // act
      final serverList = await settings.getAllServers();
      // assert
      expect(serverList, equals([tServerModel]));
      verify(() => mockSettingsRepository.getAllServers()).called(1);
      verifyNoMoreInteractions(mockSettingsRepository);
    },
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
