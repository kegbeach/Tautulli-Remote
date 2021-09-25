import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/new_geo_ip.dart';
import '../../domain/usecases/new_get_geo_ip.dart';

part 'new_geo_ip_event.dart';
part 'new_geo_ip_state.dart';

Map<String, NewGeoIp> geoIpMapCache = {};

class NewGeoIpBloc extends Bloc<NewGeoIpEvent, NewGeoIpState> {
  final NewGetGeoIp getGeoIp;

  NewGeoIpBloc(this.getGeoIp) : super(NewGeoIpInitial()) {
    on<NewGeoIpLoad>((event, emit) => _onNewGeoIpLoad(event, emit));
  }

  void _onNewGeoIpLoad(NewGeoIpLoad event, Emitter<NewGeoIpState> emit) async {
    if (geoIpMapCache.containsKey(event.ipAddress)) {
      emit(
        NewGeoIpSuccess(geoIpMap: geoIpMapCache),
      );
    } else {
      emit(
        NewGeoIpInProgress(),
      );

      final failureOrGeoIp = await getGeoIp(
        tautulliId: event.tautulliId,
        ipAddress: event.ipAddress,
      );

      failureOrGeoIp.fold(
        (failure) {
          //TODO: Log geo ip failure
          print('Geo IP failed');

          emit(
            NewGeoIpFailure(geoIpMap: geoIpMapCache),
          );
        },
        (response) {
          geoIpMapCache[event.ipAddress] = response.data;

          emit(
            NewGeoIpSuccess(geoIpMap: geoIpMapCache),
          );
        },
      );
    }
  }
}
