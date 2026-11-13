import 'package:filmer/models/user.dart';
import 'package:filmer/core/utils/result.dart';
import 'package:filmer/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RoomRepository {
  Future<Result<String>> createRoom(User host);
  Future<Result<void>> joinRoom(String code, User user);
  Future<Result<void>> voteMovie(String code, int movieId, String userId);
  Future<Result<void>> updateMatch(String code, int movieId);
  Stream<DocumentSnapshot> streamRoom(String code);
  Stream<QuerySnapshot> streamParticipants(String code);
  Stream<QuerySnapshot> streamVotes(String code);
}

class RoomRepositoryImpl implements RoomRepository {
  final FirestoreService _firestoreService;

  RoomRepositoryImpl(this._firestoreService);

  @override
  Future<Result<String>> createRoom(User host) async {
    try {
      final code = await _firestoreService.createRoom(host);
      return Success(code);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> joinRoom(String code, User user) async {
    try {
      await _firestoreService.joinRoom(code, user);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> voteMovie(String code, int movieId, String userId) async {
     try {
      await _firestoreService.voteMovie(code, movieId, userId);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> updateMatch(String code, int movieId) async {
     try {
      await _firestoreService.updateMatch(code, movieId);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Stream<DocumentSnapshot> streamRoom(String code) {
    return _firestoreService.streamRoom(code);
  }

  @override
  Stream<QuerySnapshot> streamParticipants(String code) {
     return _firestoreService.streamParticipants(code);
  }

  @override
  Stream<QuerySnapshot> streamVotes(String code) {
     return _firestoreService.streamVotes(code);
  }
}
