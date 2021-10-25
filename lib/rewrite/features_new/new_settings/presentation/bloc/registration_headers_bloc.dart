import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core_new/database/data/models/new_custom_header_model.dart';

part 'registration_headers_event.dart';
part 'registration_headers_state.dart';

List<NewCustomHeaderModel> headerListCache = [];

class RegistrationHeadersBloc
    extends Bloc<RegistrationHeadersEvent, RegistrationHeadersState> {
  RegistrationHeadersBloc() : super(RegistrationHeadersInitial()) {
    on<RegistrationHeadersClear>(
      (event, emit) => _onRegistrationHeadersClear(event, emit),
    );
    on<RegistrationHeadersDelete>(
      (event, emit) => _onRegistrationHeadersDelete(event, emit),
    );
    on<RegistrationHeadersUpdate>(
      (event, emit) => _onRegistrationHeadersUpdate(event, emit),
    );
  }

  void _onRegistrationHeadersClear(
    RegistrationHeadersClear event,
    Emitter<RegistrationHeadersState> emit,
  ) {
    headerListCache = [];

    emit(
      const RegistrationHeadersLoaded([]),
    );
  }

  void _onRegistrationHeadersDelete(
    RegistrationHeadersDelete event,
    Emitter<RegistrationHeadersState> emit,
  ) {
    List<NewCustomHeaderModel> newList = [...headerListCache];

    newList.removeWhere((header) => header.key == event.key);

    headerListCache = [...newList];

    emit(
      RegistrationHeadersLoaded(headerListCache),
    );
  }

  void _onRegistrationHeadersUpdate(
    RegistrationHeadersUpdate event,
    Emitter<RegistrationHeadersState> emit,
  ) {
    List<NewCustomHeaderModel> newList = [...headerListCache];

    if (event.basicAuth) {
      final currentIndex = newList.indexWhere(
        (header) => header.key == 'Authorization',
      );

      final String base64Value = base64Encode(
        utf8.encode('${event.key}:${event.value}'),
      );

      if (currentIndex == -1) {
        newList.add(
          NewCustomHeaderModel(
            key: 'Authorization',
            value: 'Basic $base64Value',
          ),
        );
      } else {
        newList[currentIndex] = NewCustomHeaderModel(
          key: 'Authorization',
          value: 'Basic $base64Value',
        );
      }
    } else {
      if (event.previousKey != null) {
        final oldIndex = newList.indexWhere(
          (header) => header.key == event.previousKey,
        );

        newList[oldIndex] = NewCustomHeaderModel(
          key: event.key,
          value: event.value,
        );
      } else {
        final currentIndex = newList.indexWhere(
          (header) => header.key == event.key,
        );

        if (currentIndex == -1) {
          newList.add(
            NewCustomHeaderModel(
              key: event.key,
              value: event.value,
            ),
          );
        } else {
          newList[currentIndex] = NewCustomHeaderModel(
            key: event.key,
            value: event.value,
          );
        }
      }
    }

    newList.sort((a, b) => a.key.compareTo(b.key));

    headerListCache = [...newList];

    emit(
      RegistrationHeadersLoaded(headerListCache),
    );
  }
}
