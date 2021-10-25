import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_logs/model/flog/log.dart';
import 'package:f_logs/model/flog/log_level.dart';

import '../../domain/usecases/new_logging.dart';

part 'new_logging_event.dart';
part 'new_logging_state.dart';

List<Log> logCache = [];
LogLevel levelCache = LogLevel.ALL;

class NewLoggingBloc extends Bloc<NewLoggingEvent, NewLoggingState> {
  final NewLogging logging;

  NewLoggingBloc(this.logging) : super(NewLoggingInitial()) {
    on<NewLoggingLoad>((event, emit) => _onNewLoggingLoad(event, emit));
    on<NewLoggingClear>((event, emit) => _onNewLoggingClear(event, emit));
    on<NewLoggingSetLevel>((event, emit) => _onNewLoggingSetLevel(event, emit));
  }

  void _onNewLoggingLoad(
    NewLoggingLoad event,
    Emitter<NewLoggingState> emit,
  ) async {
    try {
      final logs = await logging.getAllLogs();
      final reversedLogs = logs.reversed.toList();
      logCache = reversedLogs;

      emit(
        NewLoggingSuccess(
          logs: reversedLogs,
          level: levelCache,
        ),
      );
    } catch (_) {
      emit(
        NewLoggingFailure(),
      );
    }
  }

  void _onNewLoggingClear(
    NewLoggingClear event,
    Emitter<NewLoggingState> emit,
  ) async {
    try {
      logging.clearLogs();

      logging.info('Logging :: Cleared Logs');

      // Allow time to record above logging before loading new logging
      await Future.delayed(const Duration(milliseconds: 50));

      final logs = await logging.getAllLogs();
      final reversedLogs = logs.reversed.toList();
      logCache = reversedLogs;

      emit(
        NewLoggingSuccess(
          logs: reversedLogs,
          level: levelCache,
        ),
      );
    } catch (_) {
      emit(
        NewLoggingFailure(),
      );
    }
  }

  void _onNewLoggingSetLevel(
    NewLoggingSetLevel event,
    Emitter<NewLoggingState> emit,
  ) {
    levelCache = event.level;

    emit(
      NewLoggingSuccess(
        logs: logCache,
        level: event.level,
      ),
    );
  }
}
