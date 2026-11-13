import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmer/models/movie.dart';

part 'filter_options.freezed.dart';
part 'filter_options.g.dart';

@freezed
abstract class FilterOptions with _$FilterOptions {
  const FilterOptions._();
  const factory FilterOptions({
    ContentType? contentType,
    @Default([]) List<String> selectedPlatforms,
    @Default([]) List<String> selectedGenres,
  }) = _FilterOptions;

  factory FilterOptions.fromJson(Map<String, dynamic> json) => _$FilterOptionsFromJson(json);
}

@freezed
abstract class PlatformData with _$PlatformData {
  const PlatformData._();
  const factory PlatformData({
    required String name,
    required String logoUrl,
  }) = _PlatformData;

  factory PlatformData.fromJson(Map<String, dynamic> json) => _$PlatformDataFromJson(json);
}

const List<PlatformData> availablePlatforms = [
  PlatformData(name: 'Netflix', logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/75/Netflix_icon.svg'),
  PlatformData(name: 'HBO Max', logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/17/HBO_Max_Logo.svg'),
  PlatformData(name: 'Disney+', logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/3e/Disney%2B_logo.svg'),
  PlatformData(name: 'Prime Video', logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f1/Prime_Video.png'), 
  PlatformData(name: 'Apple TV+', logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/28/Apple_TV_Plus_Logo.svg'),
  PlatformData(name: 'Movistar+', logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Movistar_Plus%2B.svg/1200px-Movistar_Plus%2B.svg.png'), 
  PlatformData(name: 'SkyShowtime', logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e0/SkyShowtime.svg'), 
];

const List<String> availableGenres = [
  "Acción",
  "Aventura",
  "Comedia",
  "Drama",
  "Fantasía",
  "Terror",
  "Sci-Fi",
  "Thriller",
  "Romance",
  "Documental",
  "Animación",
  "Crimen",
  "Misterio",
  "Musical",
  "Guerra",
  "Western",
  "Familia",
  "Historia",
];
