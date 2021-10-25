import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/datasources/new_onesignal_data_source.dart';

part 'new_onesignal_health_event.dart';
part 'new_onesignal_health_state.dart';

class NewOnesignalHealthBloc
    extends Bloc<NewOnesignalHealthEvent, NewOnesignalHealthState> {
  final NewOnesignalDataSource onesignal;

  NewOnesignalHealthBloc(this.onesignal) : super(NewOnesignalHealthInitial()) {
    on<NewOnesignalHealthCheck>(
      (event, emit) => _onNewOnesignalHeathCheck(event, emit),
    );
  }

  void _onNewOnesignalHeathCheck(
    NewOnesignalHealthCheck event,
    Emitter<NewOnesignalHealthState> emit,
  ) async {
    emit(
      NewOnesignalHealthInProgress(),
    );
    if (await onesignal.isReachable) {
      emit(
        NewOnesignalHealthSuccess(),
      );
    } else {
      //TODO: Log failure
      emit(
        NewOnesignalHealthFailure(),
      );
    }
  }
}
