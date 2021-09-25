import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/core_new/api/tautulli_api/api_response_data.dart';
import 'package:tautulli_remote/rewrite/core_new/database/data/models/new_server_model.dart';
import 'package:tautulli_remote/rewrite/core_new/error/new_failure.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/data/models/new_activity_model.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/domain/usecases/new_get_activity.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/presentation/bloc/new_activity_bloc.dart';
import 'package:tautulli_remote/rewrite/features_new/new_image_url/domain/usecases/new_get_image_url.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../../fixtures_new/new_fixture_reader.dart';

class MockGetActivity extends Mock implements NewGetActivity {}

class MockGetImageUrl extends Mock implements NewGetImageUrl {}

void main() {
  final mockGetActivity = MockGetActivity();
  final mockGetImageUrl = MockGetImageUrl();

  const tTautulliId = 'jkl';

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

  final tServerModel = NewServerModel(
    sortIndex: 0,
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    deviceToken: 'abc',
    tautulliId: 'jkl',
    plexName: 'Plex',
    plexIdentifier: 'xyz',
    primaryActive: true,
    onesignalRegistered: true,
    plexPass: true,
  );

  void setUpSuccess() {
    String imageUrl =
        'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';
    when(
      () => mockGetActivity(
        tautulliId: any(named: 'tautulliId'),
      ),
    ).thenAnswer((_) async => Right(tApiResponseData));

    when(() => mockGetImageUrl(
          tautulliId: any(named: 'tautulliId'),
          img: any(named: 'img'),
          ratingKey: any(named: 'ratingKey'),
          fallback: any(named: 'fallback'),
        )).thenAnswer((_) async => Right(imageUrl));
  }

  test(
    'initial state should be NewActivityInitial',
    () async {
      // assert
      expect(
          NewActivityBloc(
            getActivity: mockGetActivity,
            getImageUrl: mockGetImageUrl,
          ).state,
          NewActivityInitial());
    },
  );

  blocTest<NewActivityBloc, NewActivityState>(
    'emits [NewActivityFailure] when NewActivityLoad is added and server list is empty',
    build: () => NewActivityBloc(
      getActivity: mockGetActivity,
      getImageUrl: mockGetImageUrl,
    ),
    act: (bloc) => bloc.add(NewActivityLoad(const [])),
    expect: () => [
      NewActivityFailure(MissingServerFailure()),
    ],
  );

  blocTest<NewActivityBloc, NewActivityState>(
    'should get data from the GetActivity use case',
    setUp: () => setUpSuccess(),
    build: () => NewActivityBloc(
      getActivity: mockGetActivity,
      getImageUrl: mockGetImageUrl,
    ),
    act: (bloc) => bloc.add(
      NewActivityLoad([tServerModel]),
    ),
    wait: const Duration(milliseconds: 1),
    verify: (bloc) => mockGetActivity(
      tautulliId: tTautulliId,
    ),
    tearDown: () => activityMapCache = {},
  );

  blocTest<NewActivityBloc, NewActivityState>(
    'should get data from the GetImageUrl use case',
    setUp: () => setUpSuccess(),
    build: () => NewActivityBloc(
      getActivity: mockGetActivity,
      getImageUrl: mockGetImageUrl,
    ),
    act: (bloc) => bloc.add(
      NewActivityLoad([tServerModel]),
    ),
    wait: const Duration(milliseconds: 1),
    verify: (bloc) => mockGetImageUrl(
      tautulliId: tTautulliId,
    ),
    tearDown: () => activityMapCache = {},
  );

  blocTest<NewActivityBloc, NewActivityState>(
    'emits [NewActivityLoaded] when NewActivityLoad is added',
    setUp: () => setUpSuccess(),
    build: () => NewActivityBloc(
      getActivity: mockGetActivity,
      getImageUrl: mockGetImageUrl,
    ),
    act: (bloc) => bloc.add(
      NewActivityLoad([tServerModel]),
    ),
    expect: () => [
      isA<NewActivityLoaded>(),
    ],
  );
}
