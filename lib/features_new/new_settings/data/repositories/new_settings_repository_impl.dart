import '../../../../core_new/database/data/datasources/new_database.dart';
import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../domain/repositories/new_settings_repository.dart';
import '../datasources/new_settings_data_source.dart';

class NewSettingsRepositoryImpl implements NewSettingsRepository {
  final NewSettingsDataSource dataSource;

  NewSettingsRepositoryImpl({required this.dataSource});

  @override
  Future<int> addServer(
    NewServerModel server,
  ) async {
    return await DBProvider.db.addServer(server);
  }

  @override
  Future<void> deleteServer(int id) async {
    await DBProvider.db.deleteServer(id);
  }

  @override
  Future<List<NewServerModel>> getAllServers() async {
    return await DBProvider.db.getAllServers();
  }

  @override
  Future<List<int>> getCustomCertHashList() async {
    return await dataSource.getCustomCertHashList();
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return dataSource.setCustomCertHashList(certHashList);
  }

  @override
  Future<NewServerModel> getServerByTautulliId(String tautulliId) async {
    return await dataSource.getServerByTautulliId(tautulliId);
  }

  @override
  Future<int> getServerTimeout() async {
    return await dataSource.getServerTimeout();
  }

  @override
  Future<bool> setServerTimeout(int value) async {
    return dataSource.setServerTimeout(value);
  }
}
