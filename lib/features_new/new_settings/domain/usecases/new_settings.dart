import 'package:tautulli_remote/core_new/database/data/models/new_server_model.dart';

import '../repositories/new_settings_repository.dart';

class NewSettings {
  final NewSettingsRepository repository;

  NewSettings(this.repository);

  /// A list of user approved certificate hashes.
  ///
  /// Used for communicating with servers that could not be authenticated by
  /// any of the built in trusted root certificates.
  Future<List<int>> getCustomCertHashList() async {
    return await repository.getCustomCertHashList();
  }

  /// Sets the list of approved custom cert hashes.
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return await repository.setCustomCertHashList(certHashList);
  }

  /// Retrives a ServerModel for the corresponding Tautulli ID.
  Future<NewServerModel> getServerByTautulliId(String tautulliId) async {
    return await repository.getServerByTautulliId(tautulliId);
  }

  /// How long to wait in seconds before timing out the server connection.
  ///
  /// If no value is stored returns `15`.
  Future<int> getServerTimeout() async {
    return await repository.getServerTimeout();
  }

  /// Sets the time to wait in seconds before timing out the server connection.
  Future<bool> setServerTimeout(int value) async {
    return await repository.setServerTimeout(value);
  }
}
