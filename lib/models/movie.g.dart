// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Movie _$MovieFromJson(Map<String, dynamic> json) => _Movie(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? 'Untitled',
  year: json['year'] as String? ?? 'Unknown',
  duration: json['duration'] as String? ?? 'Unknown',
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  imageUrl:
      json['imageUrl'] as String? ?? 'https://via.placeholder.com/500x750',
  platforms:
      (json['platforms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  type:
      $enumDecodeNullable(_$ContentTypeEnumMap, json['type']) ??
      ContentType.movie,
  synopsis: json['synopsis'] as String? ?? 'No synopsis available',
);

Map<String, dynamic> _$MovieToJson(_Movie instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'year': instance.year,
  'duration': instance.duration,
  'rating': instance.rating,
  'genres': instance.genres,
  'imageUrl': instance.imageUrl,
  'platforms': instance.platforms,
  'type': _$ContentTypeEnumMap[instance.type]!,
  'synopsis': instance.synopsis,
};

const _$ContentTypeEnumMap = {
  ContentType.movie: 'movie',
  ContentType.series: 'series',
};
