part of 'new_logging_bloc.dart';

abstract class NewLoggingEvent extends Equatable {
  const NewLoggingEvent();

  @override
  List<Object> get props => [];
}

class NewLoggingLoad extends NewLoggingEvent {}

class NewLoggingClear extends NewLoggingEvent {}

class NewLoggingSetLevel extends NewLoggingEvent {
  final LogLevel level;

  const NewLoggingSetLevel(this.level);

  @override
  List<Object> get props => [level];
}
