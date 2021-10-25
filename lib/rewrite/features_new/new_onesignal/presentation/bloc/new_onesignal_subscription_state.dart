part of 'new_onesignal_subscription_bloc.dart';

abstract class NewOnesignalSubscriptionState extends Equatable {
  const NewOnesignalSubscriptionState();

  @override
  List<Object> get props => [];
}

class NewOnesignalSubscriptionInitial extends NewOnesignalSubscriptionState {}

class NewOnesignalSubscriptionSuccess extends NewOnesignalSubscriptionState {}

class NewOnesignalSubscriptionFailure extends NewOnesignalSubscriptionState {
  final String title;
  final String message;

  const NewOnesignalSubscriptionFailure({
    required this.title,
    required this.message,
  });

  @override
  List<Object> get props => [title, message];
}
