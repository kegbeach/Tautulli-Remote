import 'dart:io';

import 'package:f_logs/model/flog/log.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_logging/data/repositories/new_logging_repository_impl.dart';
import 'package:tautulli_remote/rewrite/features_new/new_logging/domain/usecases/new_logging.dart';

class MockLoggingRepository extends Mock implements NewLoggingRepositoryImpl {}

void main() {
  final mockRepository = MockLoggingRepository();
  final usecase = NewLogging(mockRepository);

  test(
    'should forward the call to the repository to add a trace log',
    () async {
      // act
      usecase.trace('trace');
      // assert
      verify(() => mockRepository.trace('trace')).called(1);
    },
  );

  test(
    'should forward the call to the repository to add a debug log',
    () async {
      // act
      usecase.debug('debug');
      // assert
      verify(() => mockRepository.debug('debug')).called(1);
    },
  );

  test(
    'should forward the call to the repository to add a info log',
    () async {
      // act
      usecase.info('info');
      // assert
      verify(() => mockRepository.info('info')).called(1);
    },
  );

  test(
    'should forward the call to the repository to add a warning log',
    () async {
      // act
      usecase.warning('warning');
      // assert
      verify(() => mockRepository.warning('warning')).called(1);
    },
  );

  test(
    'should forward the call to the repository to add a error log',
    () async {
      // act
      usecase.error('error');
      // assert
      verify(() => mockRepository.error('error')).called(1);
    },
  );

  test(
    'should forward the call to the repository to add a severe log',
    () async {
      // act
      usecase.severe('severe');
      // assert
      verify(() => mockRepository.severe('severe')).called(1);
    },
  );

  test(
    'should forward the call to the repository to add a fatal log',
    () async {
      // act
      usecase.fatal('fatal');
      // assert
      verify(() => mockRepository.fatal('fatal')).called(1);
    },
  );

  test(
    'should forward the call to the repository to get list of logs',
    () async {
      // arrange
      when(() => mockRepository.getAllLogs()).thenAnswer(
        (_) async => [Log()],
      );
      // act
      await usecase.getAllLogs();
      // assert
      verify(() => mockRepository.getAllLogs()).called(1);
    },
  );

  test(
    'should forward the call to the repository to clear logs',
    () async {
      // arrange
      when(() => mockRepository.clearLogs()).thenAnswer(
        (_) async => [Log()],
      );
      // act
      await usecase.clearLogs();
      // assert
      verify(() => mockRepository.clearLogs()).called(1);
    },
  );

  test(
    'should forward the call to the repository to export logs',
    () async {
      // arrange
      when(() => mockRepository.exportLogs()).thenAnswer(
        (_) async => File(''),
      );
      // act
      await usecase.exportLogs();
      // assert
      verify(() => mockRepository.exportLogs()).called(1);
    },
  );
}
