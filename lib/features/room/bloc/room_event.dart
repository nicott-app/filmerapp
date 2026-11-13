import 'package:equatable/equatable.dart';
import 'package:filmer/models/user.dart';
import 'package:filmer/models/room.dart';
import 'package:filmer/models/movie.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object?> get props => [];
}

class InitializeRoomSession extends RoomEvent {
  final User user;
  const InitializeRoomSession(this.user);

  @override
  List<Object?> get props => [user];
}

class CreateRoomRequested extends RoomEvent {}

class JoinRoomRequested extends RoomEvent {
  final String code;
  const JoinRoomRequested(this.code);

  @override
  List<Object?> get props => [code];
}

class VoteMovieRequested extends RoomEvent {
  final int movieId;
  final bool liked;
  final Movie? movieObj;

  const VoteMovieRequested(this.movieId, this.liked, this.movieObj);

  @override
  List<Object?> get props => [movieId, liked];
}

class RoomUpdated extends RoomEvent {
  final Room room;
  const RoomUpdated(this.room);

  @override
  List<Object?> get props => [room];
}

class ParticipantsUpdated extends RoomEvent {
  final List<User> participants;
  const ParticipantsUpdated(this.participants);

  @override
  List<Object?> get props => [participants];
}

class VotesUpdated extends RoomEvent {
  final Map<int, Set<String>> votes;
  const VotesUpdated(this.votes);

  @override
  List<Object?> get props => [votes];
}
