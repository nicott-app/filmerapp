import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmer/models/user.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  FirestoreService();

  /// Creates a new room and returns the room code.
  Future<String> createRoom(User host) async {
    try {
      final code = _generateRoomCode();
      
      // Create Room Document
      await _db.collection('rooms').doc(code).set({
        'code': code,
        'hostId': host.id,
        'createdAt': FieldValue.serverTimestamp(),
        'matchMovieId': null,
        'requiredVotes': 1, // Will update as people join
      });

      // Add Host as Participant
      await joinRoom(code, host);
      
      return code;
    } catch (e) {
      debugPrint("Error creating room: $e");
      throw Exception("Failed to create room. Please try again.");
    }
  }

  /// Adds a user to an existing room.
  /// Throws error if room doesn't exist.
  Future<void> joinRoom(String code, User user) async {
    final roomRef = _db.collection('rooms').doc(code);
      
    // Transaction to ensure atomicity checking room existence and adding user
    return await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(roomRef);
      if (!snapshot.exists) {
        throw Exception("Room $code not found");
      }

      // Add user to participants sub-collection
      final participantRef = roomRef.collection('participants').doc(user.id);
      transaction.set(participantRef, {
        'uid': user.id,
        'name': user.name,
        'avatarUrl': user.avatarUrl,
        'joinedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Streams the room data.
  Stream<DocumentSnapshot> streamRoom(String code) {
    return _db.collection('rooms').doc(code).snapshots();
  }

  /// Streams the participants of a room.
  Stream<QuerySnapshot> streamParticipants(String code) {
    return _db.collection('rooms').doc(code).collection('participants').snapshots();
  }

  /// Streams the votes of a room.
  Stream<QuerySnapshot> streamVotes(String code) {
    return _db.collection('rooms').doc(code).collection('votes').snapshots();
  }

  /// Casts a vote for a movie.
  Future<void> voteMovie(String code, int movieId, String userId) async {
    final roomRef = _db.collection('rooms').doc(code);
    final voteRef = roomRef.collection('votes').doc(movieId.toString());

    return await _db.runTransaction((transaction) async {
      final voteSnapshot = await transaction.get(voteRef);

      if (voteSnapshot.exists) {
        // Add user to existing voters list
        transaction.update(voteRef, {
          'voterIds': FieldValue.arrayUnion([userId])
        });
      } else {
        // Create new vote document
        transaction.set(voteRef, {
          'movieId': movieId,
          'voterIds': [userId]
        });
      }
    });
  }

  /// Generates a random 6-character code securely
  String _generateRoomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(random.nextInt(chars.length))
    ));
  }

  /// Updates the room with a match movie id.
  Future<void> updateMatch(String code, int movieId) async {
    await _db.collection('rooms').doc(code).update({
      'matchMovieId': movieId,
    });
  }
}
