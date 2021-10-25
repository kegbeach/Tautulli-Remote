import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_logging/domain/usecases/new_logging.dart';
import 'package:tautulli_remote/rewrite/features_new/new_logging/presentation/bloc/logging_export_bloc.dart';

class MockLogging extends Mock implements NewLogging {}

void main() {
  final mockLogging = MockLogging();

  test(
    'initial state should be LoggingExportInitial',
    () async {
      // assert
      expect(LoggingExportBloc(mockLogging).state, LoggingExportInitial());
    },
  );

  blocTest<LoggingExportBloc, LoggingExportState>(
    'emits [LoggingExportInProgress, LoggingExportSuccess] when LoggingExportStart is added and there are no errors.',
    setUp: () => when(() => mockLogging.exportLogs()).thenAnswer(
      (_) async => File('test'),
    ),
    build: () => LoggingExportBloc(mockLogging),
    act: (bloc) => bloc.add(LoggingExportStart()),
    expect: () => <LoggingExportState>[
      LoggingExportInProgress(),
      LoggingExportSuccess(),
    ],
  );

  blocTest<LoggingExportBloc, LoggingExportState>(
    'emits [LoggingExportInProgress, LoggingExportFailure] when LoggingExportStart is added and an error is thrown.',
    setUp: () => when(() => mockLogging.exportLogs()).thenThrow(Exception()),
    build: () => LoggingExportBloc(mockLogging),
    act: (bloc) => bloc.add(LoggingExportStart()),
    expect: () => <LoggingExportState>[
      LoggingExportInProgress(),
      LoggingExportFailure(),
    ],
  );
}
