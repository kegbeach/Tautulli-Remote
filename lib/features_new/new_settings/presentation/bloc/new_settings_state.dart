part of 'new_settings_bloc.dart';

abstract class NewSettingsState extends Equatable {
  const NewSettingsState();
}

class NewSettingsInitial extends NewSettingsState {
  @override
  List<Object> get props => [];
}

class NewSettingsInProgress extends NewSettingsState {
  @override
  List<Object> get props => [];
}

class NewSettingsSuccess extends NewSettingsState {
  final List<NewServerModel> serverList;

  NewSettingsSuccess({
    required this.serverList,
  });
  @override
  List<Object> get props => [serverList];
}

class NewSettingsFailure extends NewSettingsState {
  @override
  List<Object> get props => [];
}
