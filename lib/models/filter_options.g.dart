// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FilterOptions _$FilterOptionsFromJson(Map<String, dynamic> json) =>
    _FilterOptions(
      contentType: $enumDecodeNullable(
        _$ContentTypeEnumMap,
        json['contentType'],
      ),
      selectedPlatforms:
          (json['selectedPlatforms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      selectedGenres:
          (json['selectedGenres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FilterOptionsToJson(_FilterOptions instance) =>
    <String, dynamic>{
      'contentType': _$ContentTypeEnumMap[instance.contentType],
      'selectedPlatforms': instance.selectedPlatforms,
      'selectedGenres': instance.selectedGenres,
    };

const _$ContentTypeEnumMap = {
  ContentType.movie: 'movie',
  ContentType.series: 'series',
};

_PlatformData _$PlatformDataFromJson(Map<String, dynamic> json) =>
    _PlatformData(
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
    );

Map<String, dynamic> _$PlatformDataToJson(_PlatformData instance) =>
    <String, dynamic>{'name': instance.name, 'logoUrl': instance.logoUrl};
