part of 'new_onesignal_health_bloc.dart';

abstract class NewOnesignalHealthState extends Equatable {
  const NewOnesignalHealthState();

  @override
  List<Object> get props => [];
}

class NewOnesignalHealthInitial extends NewOnesignalHealthState {}

class NewOnesignalHealthInProgress extends NewOnesignalHealthState {}

class NewOnesignalHealthSuccess extends NewOnesignalHealthState {}

class NewOnesignalHealthFailure extends NewOnesignalHealthState {}
