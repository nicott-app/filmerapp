// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
  code: json['code'] as String,
  hostId: json['hostId'] as String,
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  matchMovieId: (json['matchMovieId'] as num?)?.toInt(),
  requiredVotes: (json['requiredVotes'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'code': instance.code,
  'hostId': instance.hostId,
  'participants': instance.participants,
  'matchMovieId': instance.matchMovieId,
  'requiredVotes': instance.requiredVotes,
};
