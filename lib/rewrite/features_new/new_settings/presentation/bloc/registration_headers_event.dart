part of 'registration_headers_bloc.dart';

abstract class RegistrationHeadersEvent extends Equatable {
  const RegistrationHeadersEvent();

  @override
  List<Object> get props => [];
}

class RegistrationHeadersClear extends RegistrationHeadersEvent {}

class RegistrationHeadersDelete extends RegistrationHeadersEvent {
  final String key;

  const RegistrationHeadersDelete(this.key);

  @override
  List<Object> get props => [key];
}

class RegistrationHeadersUpdate extends RegistrationHeadersEvent {
  final String key;
  final String value;
  final bool basicAuth;
  final String? previousKey;

  const RegistrationHeadersUpdate({
    required this.key,
    required this.value,
    required this.basicAuth,
    this.previousKey,
  });

  @override
  List<Object> get props => [key, value, basicAuth];
}
