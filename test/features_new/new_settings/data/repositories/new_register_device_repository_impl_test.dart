import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/core_new/error/new_exception.dart';
import 'package:tautulli_remote/core_new/error/new_failure.dart';
import 'package:tautulli_remote/core_new/network_info/new_network_info.dart';
import 'package:tautulli_remote/features_new/new_settings/data/datasources/new_register_device_data_source.dart';
import 'package:tautulli_remote/features_new/new_settings/data/repositories/new_register_device_repository_impl.dart';

class MockRegisterDeviceDataSource extends Mock
    implements NewRegisterDeviceDataSourceImpl {}

class MockNetworkInfo extends Mock implements NewNetworkInfoImpl {}

void main() {
  final mockDataSource = MockRegisterDeviceDataSource();
  final mockNetworkInfo = MockNetworkInfo();
  final repository = NewRegisterDeviceRepositoryImpl(
    dataSource: mockDataSource,
    networkInfo: mockNetworkInfo,
  );

  const String tConnectionProtocol = 'http';
  const String tConnectionDomain = 'tautulli.com';
  const String tConnectionPath = '/tautulli';
  const String tDeviceToken = 'abc';

  test(
    'should check if the device is online',
    () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      await repository(
        connectionProtocol: tConnectionProtocol,
        connectionDomain: tConnectionDomain,
        connectionPath: tConnectionPath,
        deviceToken: tDeviceToken,
      );
      //assert
      verify(() => mockNetworkInfo.isConnected);
    },
  );

  group('device is online', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'should call the data source',
      () async {
        // act
        await repository(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(
          () => mockDataSource(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionPath: tConnectionPath,
            deviceToken: tDeviceToken,
          ),
        ).called(1);
      },
    );

    test(
      'should return a Map with response data when call to API is successful',
      () async {
        // arrange
        final Map<String, dynamic> responseMap = {
          "pms_name": "Starlight",
          "server_id": "<tautulli_server_id>",
          'tautulli_version': 'v0.0.0',
        };
        when(
          () => mockDataSource(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionPath: tConnectionPath,
            deviceToken: tDeviceToken,
          ),
        ).thenAnswer((_) async => responseMap);
        // act
        final response = await repository(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        expect(response, equals(Right(responseMap)));
      },
    );

    test(
      'should return proper Failure using FailureMapperHelper if a known exception is thrown',
      () async {
        // arrange
        when(
          () => mockDataSource(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionPath: tConnectionPath,
            deviceToken: tDeviceToken,
          ),
        ).thenThrow(ServerException);
        // act
        final response = await repository(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        expect(response, equals(Left(ServerFailure())));
      },
    );
  });

  group('device is offline', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test(
      'should return a ConnectionFailure when there is no internet',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        //act
        final result = await repository(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        //assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
