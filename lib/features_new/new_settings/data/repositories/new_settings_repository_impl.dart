import '../../../../core_new/network_info/new_network_info.dart';
import '../../domain/repositories/new_settings_repository.dart';
import '../datasources/new_settings_data_source.dart';

class NewSettingsRepositoryImpl implements NewSettingsRespository {
  final NewSettingsDataSource dataSource;
  final NewNetworkInfo networkInfo;

  NewSettingsRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<List<int>> getCustomCertHashList() async {
    return await dataSource.getCustomCertHashList();
  }

  @override
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return dataSource.setCustomCertHashList(certHashList);
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
