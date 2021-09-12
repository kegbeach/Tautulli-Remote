import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/core_new/api/tautulli_api/api_response_data.dart';
import 'package:tautulli_remote/core_new/error/new_exception.dart';
import 'package:tautulli_remote/core_new/error/new_failure.dart';
import 'package:tautulli_remote/core_new/network_info/new_network_info.dart';
import 'package:tautulli_remote/features_new/new_activity/data/datasources/new_geo_ip_data_source.dart';
import 'package:tautulli_remote/features_new/new_activity/data/models/new_geo_ip_model.dart';
import 'package:tautulli_remote/features_new/new_activity/data/repositories/new_geo_ip_repository_impl.dart';

class MockGeoIpDataSource extends Mock implements NewGeoIpDataSource {}

class MockNetworkInfo extends Mock implements NewNetworkInfo {}

void main() {
  final mockDataSource = MockGeoIpDataSource();
  final mockNetworkInfo = MockNetworkInfo();
  final repository = NewGeoIpRepositoryImpl(
    dataSource: mockDataSource,
    networkInfo: mockNetworkInfo,
  );

  const tTautulliId = 'jkl';
  const tIpAddress = '10.0.0.1';

  final tGeoIp = NewGeoIpModel(
    city: "Toronto",
    code: "CA",
    country: "Canada",
    region: "Ontario",
  );

  final ApiResponseData tApiResponseData = ApiResponseData(
    data: tGeoIp,
    primaryActive: true,
  );

  group('getActivity', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockDataSource.getGeoIp(
              tautulliId: any(named: 'tautulliId'),
              ipAddress: any(named: 'ipAddress'),
            )).thenAnswer((_) async => tApiResponseData);
        // act
        await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        );
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    group('Device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call data source getGeoIp()',
        () async {
          // arrange
          when(() => mockDataSource.getGeoIp(
                tautulliId: any(named: 'tautulliId'),
                ipAddress: any(named: 'ipAddress'),
              )).thenAnswer((_) async => tApiResponseData);
          // act
          await repository.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          );
          // assert
          verify(() => mockDataSource.getGeoIp(
                tautulliId: tTautulliId,
                ipAddress: tIpAddress,
              ));
        },
      );

      test(
        'response should contain key data with NewGeoIpModel',
        () async {
          // arrange
          when(() => mockDataSource.getGeoIp(
                tautulliId: any(named: 'tautulliId'),
                ipAddress: any(named: 'ipAddress'),
              )).thenAnswer((_) async => tApiResponseData);
          // act
          final response = await repository.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          );
          // assert
          expect(
            response,
            equals(
              Right(tApiResponseData),
            ),
          );
        },
      );

      test(
        'should return proper Failure using FailureMapperHelper if a known exception is thrown',
        () async {
          // arrange
          when(
            () => mockDataSource.getGeoIp(
              tautulliId: any(named: 'tautulliId'),
              ipAddress: any(named: 'ipAddress'),
            ),
          ).thenThrow(ServerException);
          // act
          final response = await repository.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          );
          // assert
          expect(response, equals(Left(ServerFailure())));
        },
      );
    });

    group('Device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return a ConnectionFailure when there is no internet',
        () async {
          //act
          final response = await repository.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          );
          //assert
          expect(response, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
