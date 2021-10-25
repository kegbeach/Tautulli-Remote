import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';

import '../../data/datasources/new_onesignal_data_source.dart';

part 'new_onesignal_subscription_event.dart';
part 'new_onesignal_subscription_state.dart';

String consentErrorTitle = 'OneSignal Data Privacy Not Accepted';
String consentErrorMessage =
    'To receive notifications from Tautulli consent to OneSignal data privacy.';
String registerErrorTitle = 'Device Has Not Registered With OneSignal';
String registerErrorMessage =
    'This device is attempting to register with OneSignal. This process may take up to 2 min.';
String unexpectedErrorTitle = 'Unexpected Error Communicating With OneSignal';
String unexpectedErrorMessage =
    'Please contact Tautulli support for assistance.';

class NewOnesignalSubscriptionBloc
    extends Bloc<NewOnesignalSubscriptionEvent, NewOnesignalSubscriptionState> {
  final NewOnesignalDataSource onesignal;

  NewOnesignalSubscriptionBloc(this.onesignal)
      : super(NewOnesignalSubscriptionInitial()) {
    on<NewOnesignalSubscriptionCheck>(
      (event, emit) => _onNewOnesignalSubscriptionCheck(event, emit),
    );
  }

  void _onNewOnesignalSubscriptionCheck(
    NewOnesignalSubscriptionCheck event,
    Emitter<NewOnesignalSubscriptionState> emit,
  ) async {
    final bool hasConsented = await onesignal.hasConsented;
    final bool isSubscribed = await onesignal.isSubscribed;
    final String userId = await onesignal.userId;

    if (hasConsented && isSubscribed && isNotBlank(userId)) {
      emit(
        NewOnesignalSubscriptionSuccess(),
      );
    } else if (!hasConsented) {
      emit(
        NewOnesignalSubscriptionFailure(
          title: consentErrorTitle,
          message: consentErrorMessage,
        ),
      );
    } else if (!isSubscribed) {
      emit(
        NewOnesignalSubscriptionFailure(
          title: registerErrorTitle,
          message: registerErrorMessage,
        ),
      );
    } else {
      emit(
        NewOnesignalSubscriptionFailure(
          title: unexpectedErrorTitle,
          message: unexpectedErrorMessage,
        ),
      );
    }
  }
}
