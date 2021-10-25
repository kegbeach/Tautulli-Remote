import 'package:flutter_cache_manager/flutter_cache_manager.dart';

abstract class NewCacheDataSource {
  Future<void> clearCache();
}

class NewCacheDataSourceImpl implements NewCacheDataSource {
  final DefaultCacheManager cacheManager;

  NewCacheDataSourceImpl(this.cacheManager);

  @override
  Future<void> clearCache() async {
    return await cacheManager.emptyCache();
  }
}
