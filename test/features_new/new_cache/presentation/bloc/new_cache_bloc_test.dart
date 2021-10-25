import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_cache/domain/usecases/new_clear_cache.dart';
import 'package:tautulli_remote/rewrite/features_new/new_cache/presentation/bloc/new_cache_bloc.dart';

class MockClearCache extends Mock implements NewClearCache {}

void main() {
  final mockClearCache = MockClearCache();

  test(
    'initial state should be NewCacheInitial',
    () async {
      // assert
      expect(NewCacheBloc(mockClearCache).state, NewCacheInitial());
    },
  );

  blocTest<NewCacheBloc, NewCacheState>(
    'emits [NewCacheInProgress, NewCacheSuccess] when NewCacheClear is added.',
    setUp: () {
      when(() => mockClearCache()).thenAnswer(
        (_) async => Future.value(),
      );
    },
    build: () => NewCacheBloc(mockClearCache),
    act: (bloc) => bloc.add(NewCacheClear()),
    expect: () => <NewCacheState>[NewCacheInProgress(), NewCacheSuccess()],
  );
}
