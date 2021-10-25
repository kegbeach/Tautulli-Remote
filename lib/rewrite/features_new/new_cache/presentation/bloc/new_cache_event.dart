part of 'new_cache_bloc.dart';

abstract class NewCacheEvent extends Equatable {
  const NewCacheEvent();

  @override
  List<Object> get props => [];
}

class NewCacheClear extends NewCacheEvent {}
