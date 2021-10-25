part of 'new_logging_bloc.dart';

abstract class NewLoggingState extends Equatable {
  const NewLoggingState();

  @override
  List<Object> get props => [];
}

class NewLoggingInitial extends NewLoggingState {}

class NewLoggingSuccess extends NewLoggingState {
  final List<Log> logs;
  final LogLevel level;

  const NewLoggingSuccess({
    required this.logs,
    required this.level,
  });

  @override
  List<Object> get props => [logs, level];
}

class NewLoggingFailure extends NewLoggingState {}
