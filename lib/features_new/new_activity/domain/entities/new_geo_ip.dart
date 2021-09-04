import 'package:equatable/equatable.dart';

class NewGeoIp extends Equatable {
  final String city;
  final String code;
  final String country;
  final String region;

  NewGeoIp({
    required this.city,
    required this.code,
    required this.country,
    required this.region,
  });

  @override
  List<Object?> get props => [
        city,
        code,
        country,
        region,
      ];
}
