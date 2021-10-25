part of 'new_onesignal_privacy_bloc.dart';

abstract class NewOnesignalPrivacyEvent extends Equatable {
  const NewOnesignalPrivacyEvent();

  @override
  List<Object> get props => [];
}

class NewOnesignalPrivacyCheck extends NewOnesignalPrivacyEvent {}

class NewOnesignalPrivacyGrant extends NewOnesignalPrivacyEvent {}

class NewOnesignalPrivacyRevoke extends NewOnesignalPrivacyEvent {}
