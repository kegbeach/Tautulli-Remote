import '../repository/new_cache_repository.dart';

class NewClearCache {
  final NewCacheRepository repository;

  NewClearCache(this.repository);

  Future<void> call() async {
    return await repository.clearCache();
  }
}
