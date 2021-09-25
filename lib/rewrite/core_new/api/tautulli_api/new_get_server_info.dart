import 'new_connection_handler.dart';

abstract class NewGetServerInfo {
  Future<Map<String, dynamic>> call({
    required String tautulliId,
  });
}

class NewGetServerInfoImpl implements NewGetServerInfo {
  final NewConnectionHandler connectionHandler;

  NewGetServerInfoImpl(this.connectionHandler);

  @override
  Future<Map<String, dynamic>> call({
    required String tautulliId,
  }) async {
    final response = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_server_info',
      params: {},
    );

    return response;
  }
}
