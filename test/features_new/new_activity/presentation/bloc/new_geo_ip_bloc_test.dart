import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/core_new/api/tautulli_api/api_response_data.dart';
import 'package:tautulli_remote/rewrite/core_new/error/new_failure.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/data/models/new_geo_ip_model.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/domain/usecases/new_get_geo_ip.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/presentation/bloc/new_geo_ip_bloc.dart';

class MockGetGeoIp extends Mock implements NewGetGeoIp {}

void main() {
  final mockGetGeoIp = MockGetGeoIp();

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

  void setUpSuccess() {
    when(
      () => mockGetGeoIp(
        tautulliId: any(named: 'tautulliId'),
        ipAddress: any(named: 'ipAddress'),
      ),
    ).thenAnswer((_) async => Right(tApiResponseData));
  }

  test(
    'initial state should be NewGeoIpInitial',
    () async {
      // assert
      expect(NewGeoIpBloc(mockGetGeoIp).state, NewGeoIpInitial());
    },
  );

  blocTest<NewGeoIpBloc, NewGeoIpState>(
    'should get data from the GetGeoIp use case',
    setUp: () => setUpSuccess(),
    build: () => NewGeoIpBloc(mockGetGeoIp),
    act: (bloc) => bloc.add(
      NewGeoIpLoad(
        tautulliId: tTautulliId,
        ipAddress: tIpAddress,
      ),
    ),
    wait: const Duration(milliseconds: 1),
    verify: (bloc) => mockGetGeoIp(
      tautulliId: tTautulliId,
      ipAddress: tIpAddress,
    ),
    tearDown: () => geoIpMapCache = {},
  );

  blocTest<NewGeoIpBloc, NewGeoIpState>(
    'emits [NewGeoIpInProgress, NewGeoIpSuccess] when NewGeoIpLoad is successful',
    setUp: () => setUpSuccess(),
    build: () => NewGeoIpBloc(mockGetGeoIp),
    act: (bloc) => bloc.add(
      NewGeoIpLoad(
        tautulliId: tTautulliId,
        ipAddress: tIpAddress,
      ),
    ),
    expect: () => [
      NewGeoIpInProgress(),
      NewGeoIpSuccess(
        geoIpMap: {
          tIpAddress: tGeoIp,
        },
      )
    ],
    tearDown: () => geoIpMapCache = {},
  );

  blocTest<NewGeoIpBloc, NewGeoIpState>(
    'emits [NewGeoIpSuccess] when IP address is already in geoIpMap',
    setUp: () => geoIpMapCache = {
      tIpAddress: tGeoIp,
    },
    build: () => NewGeoIpBloc(mockGetGeoIp),
    act: (bloc) => bloc.add(
      NewGeoIpLoad(
        tautulliId: tTautulliId,
        ipAddress: tIpAddress,
      ),
    ),
    expect: () => [
      NewGeoIpSuccess(
        geoIpMap: {
          tIpAddress: tGeoIp,
        },
      )
    ],
    tearDown: () => geoIpMapCache = {},
  );

  blocTest<NewGeoIpBloc, NewGeoIpState>(
    'emits [NewGeoIpInProgress, NewGeoIpFailure] when NewGeoIpLoad fails',
    setUp: () {
      when(
        () => mockGetGeoIp(
          tautulliId: any(named: 'tautulliId'),
          ipAddress: any(named: 'ipAddress'),
        ),
      ).thenAnswer((_) async => Left(ConnectionFailure()));
    },
    build: () => NewGeoIpBloc(mockGetGeoIp),
    act: (bloc) => bloc.add(
      NewGeoIpLoad(
        tautulliId: tTautulliId,
        ipAddress: tIpAddress,
      ),
    ),
    expect: () => [
      NewGeoIpInProgress(),
      NewGeoIpFailure(
        geoIpMap: const {},
      )
    ],
  );
}
