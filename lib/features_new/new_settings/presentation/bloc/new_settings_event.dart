part of 'new_settings_bloc.dart';

abstract class NewSettingsEvent extends Equatable {
  const NewSettingsEvent();
}

class NewSettingsLoad extends NewSettingsEvent {
  @override
  List<Object?> get props => [];
}
