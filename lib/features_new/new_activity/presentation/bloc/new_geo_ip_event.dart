part of 'new_geo_ip_bloc.dart';

abstract class NewGeoIpEvent extends Equatable {
  const NewGeoIpEvent();

  @override
  List<Object> get props => [];
}

class NewGeoIpLoad extends NewGeoIpEvent {
  final String tautulliId;
  final String ipAddress;

  NewGeoIpLoad({
    required this.tautulliId,
    required this.ipAddress,
  });

  @override
  List<Object> get props => [tautulliId, ipAddress];
}
