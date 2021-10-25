part of 'new_registration_bloc.dart';

abstract class NewRegistrationState extends Equatable {
  const NewRegistrationState();

  @override
  List<Object> get props => [];
}

class NewRegistrationInitial extends NewRegistrationState {}

class NewRegistrationInProgress extends NewRegistrationState {}

class NewRegistrationSuccess extends NewRegistrationState {}

class NewRegistrationFailure extends NewRegistrationState {
  final NewFailure failure;

  const NewRegistrationFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
