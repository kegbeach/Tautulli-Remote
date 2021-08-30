import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../injection_container.dart' as di;
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import '../../../settings/domain/usecases/settings.dart';

part 'wizard_event.dart';
part 'wizard_state.dart';

enum WizardStage {
  servers,
  oneSignal,
  closing,
}

WizardStage currentWizardStage = WizardStage.servers;

class WizardBloc extends Bloc<WizardEvent, WizardState> {
  WizardBloc()
      : super(
          WizardLoaded(
            wizardStage: WizardStage.servers,
          ),
        );

  @override
  Stream<WizardState> mapEventToState(
    WizardEvent event,
  ) async* {
    final currentState = state;

    if (currentState is WizardLoaded) {
      if (event is WizardUpdateStage) {
        currentWizardStage = _UpdateStage(event.currentStage);
        yield currentState.copyWith(
          wizardStage: currentWizardStage,
        );
      }
      if (event is WizardAcceptOneSignal) {
        yield currentState.copyWith(
          onesignalAccepted: event.accept,
        );
      }
      if (event is WizardRejectOneSignalPermission) {
        await di.sl<Settings>().setIosNotificationPermissionDeclined(true);
        yield currentState.copyWith(onesignalPermissionRejected: true);
      }
    }
  }
}

WizardStage _UpdateStage(WizardStage currentStage) {
  switch (currentStage) {
    case (WizardStage.servers):
      return WizardStage.oneSignal;
    case (WizardStage.oneSignal):
      return WizardStage.closing;
    case (WizardStage.closing):
      return WizardStage.servers;
    default:
      return WizardStage.closing;
  }
}
