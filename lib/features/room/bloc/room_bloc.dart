import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:filmer/domain/repositories/room_repository.dart';
import 'package:filmer/domain/repositories/movie_repository.dart';
import 'package:filmer/core/utils/result.dart';
import 'package:filmer/models/user.dart';
import 'package:filmer/models/movie.dart';
import 'package:filmer/models/room.dart';
import 'room_event.dart';
import 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository _roomRepository;
  final MovieRepository _movieRepository;
  
  StreamSubscription? _roomSub;
  StreamSubscription? _participantsSub;
  StreamSubscription? _votesSub;

  RoomBloc(this._roomRepository, this._movieRepository) : super(RoomInitial()) {
    on<InitializeRoomSession>(_onInitializeRoomSession);
    on<CreateRoomRequested>(_onCreateRoomRequested);
    on<JoinRoomRequested>(_onJoinRoomRequested);
    on<VoteMovieRequested>(_onVoteMovieRequested);
    on<RoomUpdated>((event, emit) {
      if (state is RoomSession) {
        emit((state as RoomSession).copyWith(currentRoom: event.room));
      }
    });
    on<ParticipantsUpdated>((event, emit) {
      if (state is RoomSession) {
        emit((state as RoomSession).copyWith(participants: event.participants));
      }
    });
    on<VotesUpdated>((event, emit) {
      if (state is RoomSession) {
        final currentSession = state as RoomSession;
        emit(currentSession.copyWith(votes: event.votes));
        
        final room = currentSession.currentRoom;
        if (room != null && room.matchMovieId == null) {
          final pCount = currentSession.participants.length;
          if (pCount > 0) {
            final requiredVotes = (pCount ~/ 2) + 1;
            for (var entry in event.votes.entries) {
              if (entry.value.length >= requiredVotes) {
                _roomRepository.updateMatch(room.code, entry.key);
                break;
              }
            }
          }
        }
      }
    });
  }

  Future<void> _onInitializeRoomSession(InitializeRoomSession event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    final result = await _movieRepository.getPopularMovies();
    if (result is Success) {
      emit(RoomSession(
        currentUser: event.user,
        movies: (result as Success<List<Movie>>).value,
      ));
    } else {
      emit(const RoomError("Failed to load movies"));
    }
  }

  Future<void> _onCreateRoomRequested(CreateRoomRequested event, Emitter<RoomState> emit) async {
    if (state is! RoomSession) return;
    final currentState = state as RoomSession;
    
    final result = await _roomRepository.createRoom(currentState.currentUser);
    switch (result) {
      case Success(:final value):
        _listenToRoom(value);
      case Failure(:final error):
        emit(RoomError(error));
    }
  }

  Future<void> _onJoinRoomRequested(JoinRoomRequested event, Emitter<RoomState> emit) async {
    if (state is! RoomSession) return;
    final currentState = state as RoomSession;
    
    final result = await _roomRepository.joinRoom(event.code, currentState.currentUser);
    switch (result) {
      case Success():
        _listenToRoom(event.code);
      case Failure(:final error):
        emit(RoomError(error));
    }
  }

  Future<void> _onVoteMovieRequested(VoteMovieRequested event, Emitter<RoomState> emit) async {
    if (state is! RoomSession) return;
    final currentState = state as RoomSession;
    
    if (event.liked && event.movieObj != null) {
      final newLiked = Set.of(currentState.likedMovies)..add(event.movieObj!);
      emit(currentState.copyWith(likedMovies: newLiked));
    }
    
    if (currentState.currentRoom != null) {
      _roomRepository.voteMovie(currentState.currentRoom!.code, event.movieId, currentState.currentUser.id);
    } else if (event.liked) {
       final currentVotes = Map.of(currentState.votes);
       currentVotes.putIfAbsent(event.movieId, () => {}).add(currentState.currentUser.id);
       emit(currentState.copyWith(votes: currentVotes));
    }
  }

  void _listenToRoom(String code) {
    _roomSub?.cancel();
    _roomSub = _roomRepository.streamRoom(code).listen((snapshot) {
       if (snapshot.exists && snapshot.data() != null) {
         final data = snapshot.data() as Map<String, dynamic>;
         final room = Room.fromJson(data);
         add(RoomUpdated(room));
       }
    });

    _participantsSub?.cancel();
    _participantsSub = _roomRepository.streamParticipants(code).listen((snapshot) {
      final participants = snapshot.docs.map((doc) => User.fromJson(doc.data() as Map<String, dynamic>)).toList();
      add(ParticipantsUpdated(participants));
    });

    _votesSub?.cancel();
    _votesSub = _roomRepository.streamVotes(code).listen((snapshot) {
      final votesMap = <int, Set<String>>{};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final movieId = data['movieId'] as int;
        final votersList = data['voterIds'] as List<dynamic>? ?? [];
        votesMap[movieId] = votersList.map((e) => e.toString()).toSet();
      }
      add(VotesUpdated(votesMap));
    });
  }

  @override
  Future<void> close() {
    _roomSub?.cancel();
    _participantsSub?.cancel();
    _votesSub?.cancel();
    return super.close();
  }
}
