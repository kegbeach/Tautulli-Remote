part of 'new_onesignal_health_bloc.dart';

abstract class NewOnesignalHealthEvent extends Equatable {
  const NewOnesignalHealthEvent();

  @override
  List<Object> get props => [];
}

class NewOnesignalHealthCheck extends NewOnesignalHealthEvent {}
