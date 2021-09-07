import '../../../../core_new/database/data/datasources/new_database.dart';
import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/local_storage/local_storage.dart';

abstract class NewSettingsDataSource {
  Future<List<int>> getCustomCertHashList();

  Future<bool> setCustomCertHashList(List<int> certHashList);

  Future<NewServerModel> getServerByTautulliId(String tautulliId);

  Future<int> getServerTimeout();

  Future<bool> setServerTimeout(int value);
}

const CUSTOM_CERT_HASH_LIST = 'CUSTOM_CERT_HASH_LIST';
const SETTINGS_SERVER_TIMEOUT = 'SETTINGS_SERVER_TIMEOUT';

class NewSettingsDataSourceImpl implements NewSettingsDataSource {
  final LocalStorage localStorage;

  NewSettingsDataSourceImpl({
    required this.localStorage,
  });

  @override
  Future<List<int>> getCustomCertHashList() {
    List<String> stringList;
    List<int> intList = [];

    stringList = localStorage.getStringList(CUSTOM_CERT_HASH_LIST) ?? [];
    intList = stringList.map((i) => int.parse(i)).toList();

    return Future.value(intList);
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) {
    final List<String> stringList =
        certHashList.map((i) => i.toString()).toList();

    return localStorage.setStringList(CUSTOM_CERT_HASH_LIST, stringList);
  }

  @override
  Future<NewServerModel> getServerByTautulliId(String tautulliId) async {
    return await DBProvider.db.getServerByTautulliId(tautulliId);
  }

  @override
  Future<int> getServerTimeout() {
    return Future.value(localStorage.getInt(SETTINGS_SERVER_TIMEOUT) ?? 15);
  }

  @override
  Future<bool> setServerTimeout(int value) {
    return localStorage.setInt(SETTINGS_SERVER_TIMEOUT, value);
  }
}
