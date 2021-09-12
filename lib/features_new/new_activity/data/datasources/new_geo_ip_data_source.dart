import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/api/tautulli_api/new_tautulli_api.dart'
    as tautulli_api;
import '../models/new_geo_ip_model.dart';

abstract class NewGeoIpDataSource {
  Future<ApiResponseData> getGeoIp({
    required String tautulliId,
    required String ipAddress,
  });
}

class NewGeoIpDataSourceImpl implements NewGeoIpDataSource {
  final tautulli_api.NewGetGeoipLookup apiGetGeoipLookup;

  NewGeoIpDataSourceImpl(this.apiGetGeoipLookup);

  @override
  Future<ApiResponseData> getGeoIp({
    required String tautulliId,
    required String ipAddress,
  }) async {
    final response = await apiGetGeoipLookup(
      tautulliId: tautulliId,
      ipAddress: ipAddress,
    );

    return ApiResponseData(
      data: NewGeoIpModel.fromJson(
        response['responseData']['response']['data'],
      ),
      primaryActive: response['primaryActive'],
    );
  }
}
