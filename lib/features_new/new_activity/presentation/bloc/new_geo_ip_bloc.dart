import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/new_geo_ip.dart';
import '../../domain/usecases/new_get_geo_ip.dart';

part 'new_geo_ip_event.dart';
part 'new_geo_ip_state.dart';

Map<String, NewGeoIp> _geoIpMapCache = {};

class NewGeoIpBloc extends Bloc<NewGeoIpEvent, NewGeoIpState> {
  final NewGetGeoIp getGeoIp;

  NewGeoIpBloc(this.getGeoIp) : super(NewGeoIpInitial());

  @override
  Stream<NewGeoIpState> mapEventToState(
    NewGeoIpEvent event,
  ) async* {
    if (event is NewGeoIpLoad) {
      if (_geoIpMapCache.containsKey(event.ipAddress)) {
        yield NewGeoIpSuccess(geoIpMap: _geoIpMapCache);
      } else {
        yield NewGeoIpInProgress();

        final failureOrGeoIp = await getGeoIp(
          tautulliId: event.tautulliId,
          ipAddress: event.ipAddress,
        );

        yield* failureOrGeoIp.fold(
          (failure) async* {
            //TODO: Log geo ip failure
            print('Geo IP failed');

            yield NewGeoIpFailure(geoIpMap: _geoIpMapCache);
          },
          (response) async* {
            _geoIpMapCache[event.ipAddress] = response.data;

            yield NewGeoIpSuccess(geoIpMap: _geoIpMapCache);
          },
        );
      }
    }
  }
}
