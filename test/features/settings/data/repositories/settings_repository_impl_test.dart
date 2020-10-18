import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/settings/data/datasources/settings_data_source.dart';
import 'package:tautulli_remote/features/settings/data/models/plex_server_info_model.dart';
import 'package:tautulli_remote/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tautulli_remote/features/settings/domain/entities/plex_server_info.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSettingsDataSource extends Mock implements SettingsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  SettingsRepositoryImpl repository;
  MockSettingsDataSource mockSettingsDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockSettingsDataSource = MockSettingsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SettingsRepositoryImpl(
      dataSource: mockSettingsDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final int tServerTimeout = 3;
  final int tRefreshRate = 5;
  final String tTautulliId = 'jkl';
  final String tStatsType = 'duration';

  final plexServerInfoJson = json.decode(fixture('plex_server_info.json'));
  final PlexServerInfo tPlexServerInfo =
      PlexServerInfoModel.fromJson(plexServerInfoJson['response']['data']);

  group('getPlexServerInfo', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getPlexServerInfo(tTautulliId);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getPlexServerInfo()',
        () async {
          // act
          await repository.getPlexServerInfo(tTautulliId);
          // assert
          verify(
            mockSettingsDataSource.getPlexServerInfo(tTautulliId),
          );
        },
      );

      test(
        'should return MetadataItem when call to API is successful',
        () async {
          // arrange
          when(
            mockSettingsDataSource.getPlexServerInfo(any),
          ).thenAnswer((_) async => tPlexServerInfo);
          // act
          final result = await repository.getPlexServerInfo(tTautulliId);
          // assert
          expect(result, equals(Right(tPlexServerInfo)));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no network connection',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getPlexServerInfo(tTautulliId);
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Server Timeout', () {
    test(
      'should return the server timeout from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getServerTimeout())
            .thenAnswer((_) async => tServerTimeout);
        // act
        final result = await repository.getServerTimeout();
        // assert
        expect(result, equals(tServerTimeout));
      },
    );

    test(
      'should formward the call to the data source to set server timeout',
      () async {
        // act
        await repository.setServerTimeout(tServerTimeout);
        // assert
        verify(mockSettingsDataSource.setServerTimeout(tServerTimeout));
      },
    );
  });

  group('Refresh Rate', () {
    test(
      'should return the refresh rate from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getRefreshRate())
            .thenAnswer((_) async => tRefreshRate);
        // act
        final result = await repository.getRefreshRate();
        // assert
        expect(result, equals(tRefreshRate));
      },
    );

    test(
      'should formward the call to the data source to set refresh rate',
      () async {
        // act
        await repository.setRefreshRate(tRefreshRate);
        // assert
        verify(mockSettingsDataSource.setRefreshRate(tRefreshRate));
      },
    );
  });

  group('Last Selected Server', () {
    test(
      'should return the last selected server from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getLastSelectedServer())
            .thenAnswer((_) async => tTautulliId);
        // act
        final result = await repository.getLastSelectedServer();
        // assert
        expect(result, equals(tTautulliId));
      },
    );

    test(
      'should formward the call to the data source to set last selected server',
      () async {
        // act
        await repository.setLastSelectedServer(tTautulliId);
        // assert
        verify(mockSettingsDataSource.setLastSelectedServer(tTautulliId));
      },
    );
  });

  group('Stats Type', () {
    test(
      'should return the stats type from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getStatsType())
            .thenAnswer((_) async => tStatsType);
        // act
        final result = await repository.getStatsType();
        // assert
        expect(result, equals(tStatsType));
      },
    );

    test(
      'should formward the call to the data source to set stats type',
      () async {
        // act
        await repository.setStatsType(tStatsType);
        // assert
        verify(mockSettingsDataSource.setStatsType(tStatsType));
      },
    );
  });
}
