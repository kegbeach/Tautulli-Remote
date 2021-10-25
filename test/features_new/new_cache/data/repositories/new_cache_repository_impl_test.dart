import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_cache/data/datasources/new_cache_data_source.dart';
import 'package:tautulli_remote/rewrite/features_new/new_cache/data/repository/new_cache_repository_impl.dart';

class MockCacheDataSource extends Mock implements NewCacheDataSource {}

void main() {
  final mockDataSource = MockCacheDataSource();
  final repository = NewCacheRepositoryImpl(mockDataSource);

  group('Clear Cache', () {
    test(
      'should forward the call to the data source to clear the cache',
      () async {
        // arrange
        when(() => mockDataSource.clearCache()).thenAnswer(
          (_) async => Future.value(),
        );
        // act
        await repository.clearCache();
        // assert
        verify(() => mockDataSource.clearCache()).called(1);
      },
    );
  });
}
