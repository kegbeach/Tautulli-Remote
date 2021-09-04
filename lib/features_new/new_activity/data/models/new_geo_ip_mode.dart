import '../../../../core_new/helpers/new_value_helper.dart';
import '../../domain/entities/new_geo_ip.dart';

class NewGeoIpModel extends NewGeoIp {
  NewGeoIpModel({
    required String city,
    required String code,
    required String country,
    required String region,
  }) : super(
          city: city,
          code: code,
          country: country,
          region: region,
        );

  factory NewGeoIpModel.fromJson(Map<String, dynamic> json) {
    return NewGeoIpModel(
      city: NewValueHelper.cast(
        json['city'],
        CastType.string,
      ),
      code: NewValueHelper.cast(
        json['code'],
        CastType.string,
      ),
      country: NewValueHelper.cast(
        json['country'],
        CastType.string,
      ),
      region: NewValueHelper.cast(
        json['region'],
        CastType.string,
      ),
    );
  }
}
