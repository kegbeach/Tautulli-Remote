import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/activity/data/datasources/activity_data_source.dart';
import 'package:tautulli_remote/features/activity/domain/entities/activity.dart';
import 'package:tautulli_remote/features/activity/data/models/activity_model.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

class MockGetActivity extends Mock implements tautulli_api.GetActivity {}

void main() {
  ActivityDataSourceImpl dataSource;
  MockGetActivity mockApiGetActivity;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockSettings = MockSettings();
    mockLogging = MockLogging();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
    mockApiGetActivity = MockGetActivity();
    dataSource = ActivityDataSourceImpl(
      settings: mockSettings,
      apiGetActivity: mockApiGetActivity,
    );
  });

  const tTautulliId = 'abc';

  final tActivityJson = json.decode(fixture('activity.json'));

  List<ActivityItem> tActivityList = [];
  tActivityJson['response']['data']['sessions'].forEach(
    (session) {
      tActivityList.add(
        ActivityItemModel.fromJson(session),
      );
    },
  );

  void setUpSuccess() {
    when(
      mockApiGetActivity(
        tautulliId: anyNamed('tautulliId'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => json.decode(fixture('activity.json')));
  }

  group('getActivity', () {
    test(
      'should call [getActivity] from TautulliApi',
      () async {
        // arrange
        setUpSuccess();
        //act
        await dataSource.getActivity(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        //assert
        verify(
          mockApiGetActivity(
            tautulliId: tTautulliId,
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
      },
    );

    test(
      'should return list of ActivityItemModel',
      () async {
        // arrange
        setUpSuccess();
        //act
        final result = await dataSource.getActivity(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        //assert
        expect(result, equals(tActivityList));
      },
    );
  });
}
