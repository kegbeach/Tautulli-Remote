part of 'new_registration_bloc.dart';

abstract class NewRegistrationEvent extends Equatable {
  const NewRegistrationEvent();

  @override
  List<Object> get props => [];
}

class NewRegistrationStarted extends NewRegistrationEvent {
  final String primaryConnectionAddress;
  final String secondaryConnectionAddress;
  final String deviceToken;
  final List<NewCustomHeaderModel> headers;
  final NewSettingsBloc settingsBloc;

  const NewRegistrationStarted({
    required this.primaryConnectionAddress,
    required this.secondaryConnectionAddress,
    required this.deviceToken,
    required this.headers,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        primaryConnectionAddress,
        secondaryConnectionAddress,
        deviceToken,
        headers,
        settingsBloc,
      ];
}

class NewRegistrationUnverifiedCert extends NewRegistrationEvent {
  final NewSettingsBloc settingsBloc;

  const NewRegistrationUnverifiedCert(this.settingsBloc);

  @override
  List<Object> get props => [settingsBloc];
}
