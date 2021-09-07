import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/core_new/api/tautulli_api/api_response_data.dart';
import 'package:tautulli_remote/core_new/error/new_exception.dart';
import 'package:tautulli_remote/core_new/error/new_failure.dart';
import 'package:tautulli_remote/core_new/network_info/new_network_info.dart';
import 'package:tautulli_remote/features_new/new_activity/data/datasources/new_activity_data_source.dart';
import 'package:tautulli_remote/features_new/new_activity/data/models/new_activity_model.dart';
import 'package:tautulli_remote/features_new/new_activity/data/repositories/new_activity_repository_impl.dart';

import '../../../../fixtures_new/new_fixture_reader.dart';

class MockActivityDataSource extends Mock implements NewActivityDataSource {}

class MockNetworkInfo extends Mock implements NewNetworkInfo {}

void main() {
  final mockDataSource = MockActivityDataSource();
  final mockNetworkInfo = MockNetworkInfo();
  final repository = NewActivityRepositoryImpl(
    dataSource: mockDataSource,
    networkInfo: mockNetworkInfo,
  );

  const tTautulliId = 'abc';

  final tActivityJson = json.decode(fixture('new_activity.json'));

  List<NewActivityModel> tActivityList = [];
  tActivityJson['response']['data']['sessions'].forEach(
    (session) {
      tActivityList.add(
        NewActivityModel.fromJson(session),
      );
    },
  );

  final ApiResponseData tApiResponseData = ApiResponseData(
    data: tActivityList,
    primaryActive: true,
  );

  group('getActivity', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getActivity(tautulliId: tTautulliId);
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    group('Device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call data source getActivity()',
        () async {
          // act
          await repository.getActivity(tautulliId: tTautulliId);
          // assert
          verify(() => mockDataSource.getActivity(tautulliId: tTautulliId));
        },
      );

      test(
        'response should contain key data with list of NewActivityModel',
        () async {
          // arrange
          when(() => mockDataSource.getActivity(
                  tautulliId: any(named: 'tautulliId')))
              .thenAnswer((_) async => tApiResponseData);
          // act
          final response =
              await repository.getActivity(tautulliId: tTautulliId);
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
            () => mockDataSource.getActivity(
                tautulliId: any(named: 'tautulliId')),
          ).thenThrow(ServerException);
          // act
          final response =
              await repository.getActivity(tautulliId: tTautulliId);
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
          final response =
              await repository.getActivity(tautulliId: tTautulliId);
          //assert
          expect(response, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
