import '../../domain/repository/new_cache_repository.dart';
import '../datasources/new_cache_data_source.dart';

class NewCacheRepositoryImpl implements NewCacheRepository {
  final NewCacheDataSource dataSource;

  NewCacheRepositoryImpl(this.dataSource);

  @override
  Future<void> clearCache() async {
    return await dataSource.clearCache();
  }
}
