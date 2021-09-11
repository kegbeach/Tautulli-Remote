part of 'new_activity_bloc.dart';

abstract class NewActivityState extends Equatable {
  const NewActivityState();
}

class NewActivityInitial extends NewActivityState {
  @override
  List<Object> get props => [];
}

class NewActivityFailure extends NewActivityState {
  final NewFailure failure;

  NewActivityFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

class NewActivityLoaded extends NewActivityState {
  final Map<String, Map<String, dynamic>> activityMap;
  final DateTime loadedAt;

  NewActivityLoaded({
    required this.activityMap,
    required this.loadedAt,
  });

  @override
  List<Object> get props => [
        activityMap,
        loadedAt,
      ];
}
