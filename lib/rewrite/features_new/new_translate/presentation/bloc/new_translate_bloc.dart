import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'new_translate_event.dart';
part 'new_translate_state.dart';

class NewTranslateBloc extends Bloc<NewTranslateEvent, NewTranslateState> {
  NewTranslateBloc() : super(NewTranslateInitial()) {
    on<NewTranslateUpdate>((event, emit) => _onNewTranslateUpdate(event, emit));
  }

  void _onNewTranslateUpdate(
    NewTranslateUpdate event,
    Emitter<NewTranslateState> emit,
  ) {
    //TODO: Add logging for translation change
  }
}
