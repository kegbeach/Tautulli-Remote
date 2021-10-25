part of 'new_cache_bloc.dart';

abstract class NewCacheState extends Equatable {
  const NewCacheState();

  @override
  List<Object> get props => [];
}

class NewCacheInitial extends NewCacheState {}

class NewCacheInProgress extends NewCacheState {}

class NewCacheSuccess extends NewCacheState {}
