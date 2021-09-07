import '../../../../core_new/database/data/models/new_server_model.dart';

abstract class NewSettingsRepository {
  Future<List<int>> getCustomCertHashList();

  Future<bool> setCustomCertHashList(List<int> certHashList);

  Future<NewServerModel> getServerByTautulliId(String tautulliId);

  Future<int> getServerTimeout();

  Future<bool> setServerTimeout(int value);
}
