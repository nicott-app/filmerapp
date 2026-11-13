import 'package:equatable/equatable.dart';
import 'package:filmer/models/room.dart';
import 'package:filmer/models/user.dart';
import 'package:filmer/models/movie.dart';

abstract class RoomState extends Equatable {
  const RoomState();
  
  @override
  List<Object?> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomError extends RoomState {
  final String message;
  const RoomError(this.message);

  @override
  List<Object?> get props => [message];
}

class RoomSession extends RoomState {
  final User currentUser;
  final Room? currentRoom;
  final List<User> participants;
  final List<Movie> movies;
  final Set<Movie> likedMovies;
  final Map<int, Set<String>> votes;

  const RoomSession({
    required this.currentUser,
    this.currentRoom,
    this.participants = const [],
    this.movies = const [],
    this.likedMovies = const {},
    this.votes = const {},
  });

  RoomSession copyWith({
    User? currentUser,
    Room? currentRoom,
    List<User>? participants,
    List<Movie>? movies,
    Set<Movie>? likedMovies,
    Map<int, Set<String>>? votes,
  }) {
    return RoomSession(
      currentUser: currentUser ?? this.currentUser,
      currentRoom: currentRoom ?? this.currentRoom,
      participants: participants ?? this.participants,
      movies: movies ?? this.movies,
      likedMovies: likedMovies ?? this.likedMovies,
      votes: votes ?? this.votes,
    );
  }

  @override
  List<Object?> get props => [
    currentUser, 
    currentRoom, 
    participants, 
    movies, 
    likedMovies, 
    votes
  ];
}
