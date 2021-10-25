import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_cache/domain/repository/new_cache_repository.dart';
import 'package:tautulli_remote/rewrite/features_new/new_cache/domain/usecases/new_clear_cache.dart';

class MockCacheRepository extends Mock implements NewCacheRepository {}

void main() {
  final mockCacheRepository = MockCacheRepository();
  final usecase = NewClearCache(mockCacheRepository);

  test(
    'should forward the call to the repository to clear the cache',
    () async {
      // arrange
      when(() => mockCacheRepository.clearCache()).thenAnswer(
        (_) async => Future.value(),
      );
      // act
      await usecase();
      // assert
      verify(() => mockCacheRepository.clearCache()).called(1);
    },
  );
}
