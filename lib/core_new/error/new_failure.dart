import 'package:equatable/equatable.dart';

abstract class NewFailure extends Equatable {
  @override
  List<Object> get props => [];
}

/// Device is not connected to a network.
class ConnectionFailure extends NewFailure {}

/// A catch-all Failure.
class GenericFailure extends NewFailure {}

// Server has provided an undesired response.
class ServerFailure extends NewFailure {}
