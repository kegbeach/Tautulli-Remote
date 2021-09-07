import 'new_connection_handler.dart';

abstract class NewGetGeoipLookup {
  Future<Map<String, dynamic>> call({
    required String tautulliId,
    required String ipAddress,
  });
}

class NewGetGeoipLookupImpl implements NewGetGeoipLookup {
  final NewConnectionHandler connectionHandler;

  NewGetGeoipLookupImpl(this.connectionHandler);

  @override
  Future<Map<String, dynamic>> call({
    required String tautulliId,
    required String ipAddress,
  }) async {
    final responseData = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_geoip_lookup',
      params: {'ip_address': ipAddress},
    );

    return responseData;
  }
}
