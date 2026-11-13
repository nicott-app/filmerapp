import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

enum ContentType { movie, series }

@freezed
abstract class Movie with _$Movie {
  const Movie._();

  const factory Movie({
    @Default(0) int id,
    @Default('Untitled') String title,
    @Default('Unknown') String year,
    @Default('Unknown') String duration,
    @Default(0.0) double rating,
    @Default([]) List<String> genres,
    @Default('https://via.placeholder.com/500x750') String imageUrl,
    @Default([]) List<String> platforms,
    @Default(ContentType.movie) ContentType type,
    @Default('No synopsis available') String synopsis,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}
