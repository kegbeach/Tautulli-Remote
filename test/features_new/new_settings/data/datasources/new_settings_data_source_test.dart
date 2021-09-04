import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/core_new/local_storage/local_storage.dart';
import 'package:tautulli_remote/features_new/new_settings/data/datasources/new_settings_data_source.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  final mockLocalStorage = MockLocalStorage();
  final dataSource = NewSettingsDataSourceImpl(
    localStorage: mockLocalStorage,
  );

  const int tServerTimeout = 15;

  group('Custom Cert Hash List', () {
    test(
      'should return list of custom cert hashes from settings',
      () async {
        // arrange
        when(() => mockLocalStorage.getStringList(CUSTOM_CERT_HASH_LIST))
            .thenReturn(['1', '2']);
        // act
        final customCertHashList = await dataSource.getCustomCertHashList();
        // assert
        verify(() => mockLocalStorage.getStringList(CUSTOM_CERT_HASH_LIST))
            .called(1);
        expect(customCertHashList, equals([1, 2]));
      },
    );

    test(
      'should return an ampty list when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getStringList(CUSTOM_CERT_HASH_LIST),
        ).thenReturn(null);
        // act
        final customCertHashList = await dataSource.getCustomCertHashList();
        // assert
        expect(customCertHashList, equals([]));
      },
    );

    test(
      'should call LocalStorage to save the custom cert hash list',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setStringList(
            CUSTOM_CERT_HASH_LIST,
            ['1', '2'],
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setCustomCertHashList([1, 2]);
        // assert
        verify(
          () => mockLocalStorage.setStringList(
            CUSTOM_CERT_HASH_LIST,
            ['1', '2'],
          ),
        ).called(1);
      },
    );
  });

  group('Server Timeout', () {
    test(
      'should return int from settings',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getInt(SETTINGS_SERVER_TIMEOUT),
        ).thenReturn(tServerTimeout);
        // act
        final serverTimeout = await dataSource.getServerTimeout();
        // assert
        verify(() => mockLocalStorage.getInt(SETTINGS_SERVER_TIMEOUT))
            .called(1);
        expect(serverTimeout, equals(tServerTimeout));
      },
    );

    test(
      'should return 15 when there is no stored value',
      () async {
        // arrange
        when(
          () => mockLocalStorage.getInt(SETTINGS_SERVER_TIMEOUT),
        ).thenReturn(null);
        // act
        final serverTimeout = await dataSource.getServerTimeout();
        // assert
        expect(serverTimeout, equals(15));
      },
    );

    test(
      'should call LocalStorage to save the server timeout',
      () async {
        // arrange
        when(
          () => mockLocalStorage.setInt(
            SETTINGS_SERVER_TIMEOUT,
            tServerTimeout,
          ),
        ).thenAnswer((_) async => Future.value(true));
        // act
        await dataSource.setServerTimeout(tServerTimeout);
        // assert
        verify(
          () =>
              mockLocalStorage.setInt(SETTINGS_SERVER_TIMEOUT, tServerTimeout),
        ).called(1);
      },
    );
  });
}
