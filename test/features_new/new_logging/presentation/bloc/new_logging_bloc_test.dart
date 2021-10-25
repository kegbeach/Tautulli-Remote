import 'package:bloc_test/bloc_test.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_logging/domain/usecases/new_logging.dart';
import 'package:tautulli_remote/rewrite/features_new/new_logging/presentation/bloc/new_logging_bloc.dart';

class MockLogging extends Mock implements NewLogging {}

void main() {
  final mockLogging = MockLogging();

  final tLogList = [Log()];

  test(
    'initial state should be NewLoggingInitial',
    () async {
      // assert
      expect(NewLoggingBloc(mockLogging).state, NewLoggingInitial());
    },
  );

  blocTest<NewLoggingBloc, NewLoggingState>(
    'emits [NewLoggingSuccess] when NewLoggingLoad is added and logs are returned.',
    setUp: () {
      when(() => mockLogging.getAllLogs()).thenAnswer((_) async => tLogList);
    },
    build: () => NewLoggingBloc(mockLogging),
    act: (bloc) => bloc.add(NewLoggingLoad()),
    expect: () => <NewLoggingState>[
      NewLoggingSuccess(tLogList),
    ],
  );

  blocTest<NewLoggingBloc, NewLoggingState>(
    'emits [NewLoggingFailure] when NewLoggingLoad is added and an exception is thrown.',
    setUp: () {
      when(() => mockLogging.getAllLogs()).thenThrow(Exception());
    },
    build: () => NewLoggingBloc(mockLogging),
    act: (bloc) => bloc.add(NewLoggingLoad()),
    expect: () => <NewLoggingState>[
      NewLoggingFailure(),
    ],
  );

  blocTest<NewLoggingBloc, NewLoggingState>(
    'emits [NewLoggingSuccess] with an empty list when NewLoggingClear is added and there are no errors.',
    setUp: () {
      when(() => mockLogging.clearLogs()).thenAnswer(
        (_) async => Future.value(),
      );
    },
    build: () => NewLoggingBloc(mockLogging),
    act: (bloc) => bloc.add(NewLoggingClear()),
    expect: () => <NewLoggingState>[
      const NewLoggingSuccess([]),
    ],
    verify: (_) => verify(() => mockLogging.clearLogs()).called(1),
  );

  blocTest<NewLoggingBloc, NewLoggingState>(
    'emits [NewLoggingFailure] when NewLoggingClear is added and an exception is thrown.',
    setUp: () {
      when(() => mockLogging.clearLogs()).thenThrow(Exception());
    },
    build: () => NewLoggingBloc(mockLogging),
    act: (bloc) => bloc.add(NewLoggingClear()),
    expect: () => <NewLoggingState>[
      NewLoggingFailure(),
    ],
  );
}
