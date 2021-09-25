import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/core_new/api/tautulli_api/api_response_data.dart';
import 'package:tautulli_remote/rewrite/core_new/api/tautulli_api/new_tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/rewrite/features_new/new_activity/data/datasources/new_activity_data_source.dart';
import 'package:tautulli_remote/rewrite/features_new/new_activity/data/models/new_activity_model.dart';

import '../../../../fixtures_new/new_fixture_reader.dart';

class MockGetActivity extends Mock implements tautulli_api.NewGetActivity {}

void main() {
  final mockGetActivity = MockGetActivity();
  final datasource = NewActivityDataSourceImpl(mockGetActivity);

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

  void setUpSuccess() {
    when(
      () => mockGetActivity(tautulliId: any(named: 'tautulliId')),
    ).thenAnswer((_) async => {
          'responseData': json.decode(fixture('new_activity.json')),
          'primaryActive': true,
        });
  }

  group('getActivity', () {
    test(
      'should call getActivity from Tautulli API',
      () async {
        // arrange
        setUpSuccess();
        // act
        await datasource.getActivity(tautulliId: tTautulliId);
        // assert
        verify(() => mockGetActivity(tautulliId: tTautulliId));
      },
    );

    test(
      'response.data should contain list of NewActivityModel',
      () async {
        // arrange
        setUpSuccess();
        // act
        final response = await datasource.getActivity(tautulliId: tTautulliId);
        // assert
        expect(response.data, equals(tApiResponseData.data));
      },
    );
  });
}
