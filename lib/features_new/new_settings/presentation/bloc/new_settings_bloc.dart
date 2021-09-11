import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../domain/usecases/new_settings.dart';

part 'new_settings_event.dart';
part 'new_settings_state.dart';

class NewSettingsBloc extends Bloc<NewSettingsEvent, NewSettingsState> {
  final NewSettings settings;

  NewSettingsBloc(this.settings) : super(NewSettingsInitial());
  @override
  Stream<NewSettingsState> mapEventToState(
    NewSettingsEvent event,
  ) async* {
    if (event is NewSettingsLoad) {
      yield NewSettingsInProgress();

      final List<NewServerModel> serverList = await settings.getAllServers();

      yield NewSettingsSuccess(
        serverList: serverList,
      );
    }
  }
}
