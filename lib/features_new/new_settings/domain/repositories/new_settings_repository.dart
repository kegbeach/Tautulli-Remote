abstract class NewSettingsRespository {
  Future<List<int>> getCustomCertHashList();

  Future<bool> setCustomCertHashList(List<int> certHashList);

  Future<int> getServerTimeout();

  Future<bool> setServerTimeout(int value);
}
