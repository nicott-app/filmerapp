import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmer/models/user.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
abstract class Room with _$Room {
  const factory Room({
    required String code,
    required String hostId,
    @Default([]) List<User> participants,
    int? matchMovieId,
    @Default(1) int requiredVotes,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
