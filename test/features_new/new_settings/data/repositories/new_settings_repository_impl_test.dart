import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/core_new/database/data/models/new_server_model.dart';
import 'package:tautulli_remote/core_new/error/new_exception.dart';
import 'package:tautulli_remote/features_new/new_settings/data/datasources/new_settings_data_source.dart';
import 'package:tautulli_remote/features_new/new_settings/data/repositories/new_settings_repository_impl.dart';

class MockSettingsDataSource extends Mock implements NewSettingsDataSource {}

void main() {
  final mockDataSource = MockSettingsDataSource();
  final repository = NewSettingsRepositoryImpl(
    dataSource: mockDataSource,
  );

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

  group('Custom Cert Hash List', () {
    test(
      'should return the custom cert hash list from settings',
      () async {
        // arrange
        when(() => mockDataSource.getCustomCertHashList()).thenAnswer(
          (_) async => [1, 2],
        );
        // act
        final result = await repository.getCustomCertHashList();
        // assert
        expect(result, equals([1, 2]));
      },
    );

    test(
      'should forward the call to the data source to set custom cert hash list',
      () async {
        // arrange
        when(() => mockDataSource.setCustomCertHashList([1, 2])).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setCustomCertHashList([1, 2]);
        // assert
        verify(() => mockDataSource.setCustomCertHashList([1, 2])).called(1);
      },
    );
  });

  group('getServerByTautulliId', () {
    test(
      'should return a NewServerModel for the corresponding Tautulli ID',
      () async {
        // arrange
        when(() => mockDataSource.getServerByTautulliId(any()))
            .thenAnswer((_) async => tServerModel);
        // act
        final result =
            await repository.getServerByTautulliId(tServerModel.tautulliId);
        // assert
        expect(result, equals(tServerModel));
      },
    );

    test(
      'should throw ServerNotFoundException when there is no server for corresponding Tautulli ID',
      () async {
        // arrange
        when(() => mockDataSource.getServerByTautulliId(any()))
            .thenThrow(ServerNotFoundException());
        // act
        final call = repository.getServerByTautulliId(tServerModel.tautulliId);
        // assert
        expect(
          () => call,
          throwsA(isA<ServerNotFoundException>()),
        );
      },
    );
  });

  group('Server Timeout', () {
    test(
      'should return the server timeout from settings',
      () async {
        // arrange
        when(() => mockDataSource.getServerTimeout())
            .thenAnswer((_) async => tServerTimeout);
        // act
        final result = await repository.getServerTimeout();
        // assert
        expect(result, equals(tServerTimeout));
      },
    );

    test(
      'should forward the call to the data source to set server timeout',
      () async {
        // arrange
        when(() => mockDataSource.setServerTimeout(tServerTimeout)).thenAnswer(
          (_) async => Future.value(true),
        );
        // act
        await repository.setServerTimeout(tServerTimeout);
        // assert
        verify(() => mockDataSource.setServerTimeout(tServerTimeout)).called(1);
      },
    );
  });
}
