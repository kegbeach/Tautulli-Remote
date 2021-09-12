part of 'new_geo_ip_bloc.dart';

abstract class NewGeoIpState extends Equatable {
  const NewGeoIpState();

  @override
  List<Object> get props => [];
}

class NewGeoIpInitial extends NewGeoIpState {}

class NewGeoIpInProgress extends NewGeoIpState {}

class NewGeoIpSuccess extends NewGeoIpState {
  final Map<String, NewGeoIp> geoIpMap;

  NewGeoIpSuccess({
    required this.geoIpMap,
  });

  @override
  List<Object> get props => [geoIpMap];
}

class NewGeoIpFailure extends NewGeoIpState {
  final Map<String, NewGeoIp> geoIpMap;

  NewGeoIpFailure({
    required this.geoIpMap,
  });

  @override
  List<Object> get props => [geoIpMap];
}
