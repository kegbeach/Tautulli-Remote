import '../repositories/new_settings_repository.dart';

class NewSettings {
  final NewSettingsRespository respository;

  NewSettings(this.respository);

  /// A list of user approved certificate hashes.
  ///
  /// Used for communicating with servers that could not be authenticated by
  /// any of the built in trusted root certificates.
  Future<List<int>> getCustomCertHashList() async {
    return await respository.getCustomCertHashList();
  }

  /// Sets the list of approved custom cert hashes.
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return await respository.setCustomCertHashList(certHashList);
  }

  /// How long to wait in seconds before timing out the server connection.
  ///
  /// If no value is stored returns `15`.
  Future<int> getServerTimeout() async {
    return await respository.getServerTimeout();
  }

  /// Sets the time to wait in seconds before timing out the server connection.
  Future<bool> setServerTimeout(int value) async {
    return await respository.setServerTimeout(value);
  }
}
