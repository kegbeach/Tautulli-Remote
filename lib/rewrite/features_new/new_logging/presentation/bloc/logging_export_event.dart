part of 'logging_export_bloc.dart';

abstract class LoggingExportEvent extends Equatable {
  const LoggingExportEvent();

  @override
  List<Object> get props => [];
}

class LoggingExportStart extends LoggingExportEvent {
  final NewLoggingBloc loggingBloc;

  const LoggingExportStart(this.loggingBloc);
}
