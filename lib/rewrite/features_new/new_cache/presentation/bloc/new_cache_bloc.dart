import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/new_clear_cache.dart';

part 'new_cache_event.dart';
part 'new_cache_state.dart';

class NewCacheBloc extends Bloc<NewCacheEvent, NewCacheState> {
  final NewClearCache clearCache;

  NewCacheBloc(this.clearCache) : super(NewCacheInitial()) {
    on<NewCacheClear>((event, emit) => _onNewCacheClear(event, emit));
  }

  void _onNewCacheClear(
    NewCacheClear event,
    Emitter<NewCacheState> emit,
  ) async {
    emit(
      NewCacheInProgress(),
    );
    await clearCache();
    //TODO: Log cache clear
    emit(
      NewCacheSuccess(),
    );
  }
}
