part of 'new_onesignal_subscription_bloc.dart';

abstract class NewOnesignalSubscriptionEvent extends Equatable {
  const NewOnesignalSubscriptionEvent();

  @override
  List<Object> get props => [];
}

class NewOnesignalSubscriptionCheck extends NewOnesignalSubscriptionEvent {}
