import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/core_new/api/tautulli_api/api_response_data.dart';
import 'package:tautulli_remote/features_new/new_activity/data/models/new_activity_model.dart';
import 'package:tautulli_remote/features_new/new_activity/domain/repositories/new_activity_repository.dart';
import 'package:tautulli_remote/features_new/new_activity/domain/usecases/new_get_activity.dart';

import '../../../../fixtures_new/new_fixture_reader.dart';

class MockActivityRepository extends Mock implements NewActivityRepository {}

void main() {
  final mockActivityRepository = MockActivityRepository();
  final usecase = NewGetActivity(mockActivityRepository);

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

  test(
    'should get activity from API',
    () async {
      // arrange
      when(() => mockActivityRepository.getActivity(
              tautulliId: any(named: 'tautulliId')))
          .thenAnswer((_) async => Right(tApiResponseData));
      // act
      final response = await usecase(tautulliId: tTautulliId);
      // assert
      expect(response, Right(tApiResponseData));
      verify(() => mockActivityRepository.getActivity(tautulliId: tTautulliId));
      verifyNoMoreInteractions(mockActivityRepository);
    },
  );
}
