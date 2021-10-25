import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_onesignal/data/datasources/new_onesignal_data_source.dart';
import 'package:tautulli_remote/rewrite/features_new/new_onesignal/presentation/bloc/new_onesignal_health_bloc.dart';

class MockOnesignalDataSource extends Mock implements NewOnesignalDataSource {}

void main() {
  final mockOnesignalDataSource = MockOnesignalDataSource();

  test(
    'initial state should be NewOnesignalHealthInitial',
    () async {
      // assert
      expect(
        NewOnesignalHealthBloc(mockOnesignalDataSource).state,
        NewOnesignalHealthInitial(),
      );
    },
  );

  blocTest<NewOnesignalHealthBloc, NewOnesignalHealthState>(
    'emits [NewOnesignalHealthInProgress, NewOnesignalHealthSuccess] when NewOnesignalHealthCheck is added and isReachable returns true.',
    setUp: () {
      when(() => mockOnesignalDataSource.isReachable).thenAnswer(
        (_) async => true,
      );
    },
    build: () => NewOnesignalHealthBloc(mockOnesignalDataSource),
    act: (bloc) => bloc.add(NewOnesignalHealthCheck()),
    expect: () => <NewOnesignalHealthState>[
      NewOnesignalHealthInProgress(),
      NewOnesignalHealthSuccess(),
    ],
  );

  blocTest<NewOnesignalHealthBloc, NewOnesignalHealthState>(
    'emits [NewOnesignalHealthInProgress, NewOnesignalHealthFailure] when NewOnesignalHealthCheck is added and isReachable returns false.',
    setUp: () {
      when(() => mockOnesignalDataSource.isReachable).thenAnswer(
        (_) async => false,
      );
    },
    build: () => NewOnesignalHealthBloc(mockOnesignalDataSource),
    act: (bloc) => bloc.add(NewOnesignalHealthCheck()),
    expect: () => <NewOnesignalHealthState>[
      NewOnesignalHealthInProgress(),
      NewOnesignalHealthFailure(),
    ],
  );
}
