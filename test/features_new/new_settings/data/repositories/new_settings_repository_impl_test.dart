import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/core_new/network_info/new_network_info.dart';
import 'package:tautulli_remote/features_new/new_settings/data/datasources/new_settings_data_source.dart';
import 'package:tautulli_remote/features_new/new_settings/data/repositories/new_settings_repository_impl.dart';

class MockSettingsDataSource extends Mock implements NewSettingsDataSource {}

class MockNetworkInfo extends Mock implements NewNetworkInfo {}

void main() {
  final mockDataSource = MockSettingsDataSource();
  final mockNetworkInfo = MockNetworkInfo();
  final repository = NewSettingsRepositoryImpl(
    dataSource: mockDataSource,
    networkInfo: mockNetworkInfo,
  );

  const int tServerTimeout = 15;

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
