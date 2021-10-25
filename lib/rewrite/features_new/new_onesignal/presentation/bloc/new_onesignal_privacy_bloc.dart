import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../new_settings/domain/usecases/new_settings.dart';
import '../../data/datasources/new_onesignal_data_source.dart';

part 'new_onesignal_privacy_event.dart';
part 'new_onesignal_privacy_state.dart';

class NewOnesignalPrivacyBloc
    extends Bloc<NewOnesignalPrivacyEvent, NewOnesignalPrivacyState> {
  final NewOnesignalDataSource onesignal;
  final NewSettings settings;

  NewOnesignalPrivacyBloc({
    required this.onesignal,
    required this.settings,
  }) : super(NewOnesignalPrivacyInitial()) {
    on<NewOnesignalPrivacyCheck>(
      (event, emit) => _onOnesignalPrivacyCheck(event, emit),
    );
    on<NewOnesignalPrivacyGrant>(
      (event, emit) => _onOnesignalPrivacyGrant(event, emit),
    );
    on<NewOnesignalPrivacyRevoke>(
      (event, emit) => _onOnesignalPrivacyRevoke(event, emit),
    );
  }

  void _onOnesignalPrivacyCheck(
    NewOnesignalPrivacyCheck event,
    Emitter<NewOnesignalPrivacyState> emit,
  ) async {
    if (await onesignal.hasConsented) {
      emit(
        NewOnesignalPrivacySuccess(),
      );
    } else {
      emit(
        NewOnesignalPrivacyFailure(),
      );
    }
  }

  void _onOnesignalPrivacyGrant(
    NewOnesignalPrivacyGrant event,
    Emitter<NewOnesignalPrivacyState> emit,
  ) async {
    await onesignal.grantConsent(true);
    await onesignal.disablePush(false);
    await settings.setOneSignalConsented(true);

    //TODO: Log privacy granted

    emit(
      NewOnesignalPrivacySuccess(),
    );
  }

  void _onOnesignalPrivacyRevoke(
    NewOnesignalPrivacyRevoke event,
    Emitter<NewOnesignalPrivacyState> emit,
  ) async {
    await onesignal.disablePush(true);
    await onesignal.grantConsent(false);
    await settings.setOneSignalConsented(false);

    //TODO: Log privacy revoked

    emit(
      NewOnesignalPrivacyFailure(),
    );
  }
}
