import 'new_connection_handler.dart';

abstract class NewGetActivity {
  Future<Map<String, dynamic>> call({
    required String tautulliId,
  });
}

class NewGetActivityImpl implements NewGetActivity {
  final NewConnectionHandler connectionHandler;

  NewGetActivityImpl(this.connectionHandler);

  @override
  Future<Map<String, dynamic>> call({
    required String tautulliId,
  }) async {
    final response = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_activity',
      params: {},
    );

    return response;
  }
}
