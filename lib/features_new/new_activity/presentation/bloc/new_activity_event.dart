part of 'new_activity_bloc.dart';

abstract class NewActivityEvent extends Equatable {
  const NewActivityEvent();
}

class NewActivityLoad extends NewActivityEvent {
  final List<NewServerModel> serverList;

  NewActivityLoad(this.serverList);

  @override
  List<Object?> get props => [serverList];
}

class NewActivityLoadServer extends NewActivityEvent {
  final String tautulliId;
  final String plexName;
  final Either<NewFailure, ApiResponseData> failureOrActivityResponse;

  NewActivityLoadServer({
    required this.tautulliId,
    required this.plexName,
    required this.failureOrActivityResponse,
  });

  @override
  List<Object?> get props => [
        tautulliId,
        plexName,
        failureOrActivityResponse,
      ];
}

//TODO: Implement server auto refresh