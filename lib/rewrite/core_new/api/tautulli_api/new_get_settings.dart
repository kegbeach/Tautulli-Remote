import 'new_connection_handler.dart';

abstract class NewGetSettings {
  Future<Map<String, dynamic>> call({
    required String tautulliId,
  });
}

class NewGetSettingsImpl implements NewGetSettings {
  final NewConnectionHandler connectionHandler;

  NewGetSettingsImpl(this.connectionHandler);

  @override
  Future<Map<String, dynamic>> call({
    required String tautulliId,
  }) async {
    final response = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_settings',
      params: {},
    );

    return response;
  }
}
