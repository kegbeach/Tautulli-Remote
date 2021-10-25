part of 'new_onesignal_privacy_bloc.dart';

abstract class NewOnesignalPrivacyState extends Equatable {
  const NewOnesignalPrivacyState();

  @override
  List<Object> get props => [];
}

class NewOnesignalPrivacyInitial extends NewOnesignalPrivacyState {}

class NewOnesignalPrivacySuccess extends NewOnesignalPrivacyState {}

class NewOnesignalPrivacyFailure extends NewOnesignalPrivacyState {}
