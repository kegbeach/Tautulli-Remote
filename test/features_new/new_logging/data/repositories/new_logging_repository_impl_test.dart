import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_logging/data/datasources/new_logging_data_source.dart';
import 'package:tautulli_remote/rewrite/features_new/new_logging/data/repositories/new_logging_repository_impl.dart';

class MockLoggingDataSource extends Mock implements NewLoggingDataSource {}

void main() {
  final mockDataSource = MockLoggingDataSource();
  final repository = NewLoggingRepositoryImpl(mockDataSource);

  test(
    'trace should call the data source to add a trace log',
    () async {
      // act
      repository.trace('text');
      // assert
      verify(() => mockDataSource.trace('text')).called(1);
    },
  );

  test(
    'debug should call the data source to add a debug log',
    () async {
      // act
      repository.debug('text');
      // assert
      verify(() => mockDataSource.debug('text')).called(1);
    },
  );

  test(
    'info should call the data source to add a info log',
    () async {
      // act
      repository.info('text');
      // assert
      verify(() => mockDataSource.info('text')).called(1);
    },
  );

  test(
    'warning should call the data source to add a warning log',
    () async {
      // act
      repository.warning('text');
      // assert
      verify(() => mockDataSource.warning('text')).called(1);
    },
  );

  test(
    'error should call the data source to add a error log',
    () async {
      // act
      repository.error('text');
      // assert
      verify(() => mockDataSource.error('text')).called(1);
    },
  );

  test(
    'severe should call the data source to add a severe log',
    () async {
      // act
      repository.severe('text');
      // assert
      verify(() => mockDataSource.severe('text')).called(1);
    },
  );

  test(
    'fatal should call the data source to add a fatal log',
    () async {
      // act
      repository.fatal('text');
      // assert
      verify(() => mockDataSource.fatal('text')).called(1);
    },
  );

  test(
    'getAllLogs should return all Logs in a list',
    () async {
      // arrange
      when(() => mockDataSource.getAllLogs()).thenAnswer(
        (_) async => [Log()],
      );
      // act
      final result = await repository.getAllLogs();
      // assert
      expect(result, isA<List<Log>>());
    },
  );

  test(
    'clearLogs should call the data source to clear the logs',
    () async {
      // arrange
      when(() => mockDataSource.clearLogs()).thenAnswer(
        (_) => Future.value(),
      );
      // act
      await repository.clearLogs();
      // assert
      verify(() => mockDataSource.clearLogs()).called(1);
    },
  );

  test(
    'exportLogs should save logs to storage',
    () async {
      // arrange
      when(() => mockDataSource.exportLogs()).thenAnswer(
        (_) async => File(''),
      );
      // act
      await repository.exportLogs();
      // assert
      verify(() => mockDataSource.exportLogs()).called(1);
    },
  );
}
