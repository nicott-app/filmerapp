// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FilterOptions {

 ContentType? get contentType; List<String> get selectedPlatforms; List<String> get selectedGenres;
/// Create a copy of FilterOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterOptionsCopyWith<FilterOptions> get copyWith => _$FilterOptionsCopyWithImpl<FilterOptions>(this as FilterOptions, _$identity);

  /// Serializes this FilterOptions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterOptions&&(identical(other.contentType, contentType) || other.contentType == contentType)&&const DeepCollectionEquality().equals(other.selectedPlatforms, selectedPlatforms)&&const DeepCollectionEquality().equals(other.selectedGenres, selectedGenres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentType,const DeepCollectionEquality().hash(selectedPlatforms),const DeepCollectionEquality().hash(selectedGenres));

@override
String toString() {
  return 'FilterOptions(contentType: $contentType, selectedPlatforms: $selectedPlatforms, selectedGenres: $selectedGenres)';
}


}

/// @nodoc
abstract mixin class $FilterOptionsCopyWith<$Res>  {
  factory $FilterOptionsCopyWith(FilterOptions value, $Res Function(FilterOptions) _then) = _$FilterOptionsCopyWithImpl;
@useResult
$Res call({
 ContentType? contentType, List<String> selectedPlatforms, List<String> selectedGenres
});




}
/// @nodoc
class _$FilterOptionsCopyWithImpl<$Res>
    implements $FilterOptionsCopyWith<$Res> {
  _$FilterOptionsCopyWithImpl(this._self, this._then);

  final FilterOptions _self;
  final $Res Function(FilterOptions) _then;

/// Create a copy of FilterOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentType = freezed,Object? selectedPlatforms = null,Object? selectedGenres = null,}) {
  return _then(_self.copyWith(
contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType?,selectedPlatforms: null == selectedPlatforms ? _self.selectedPlatforms : selectedPlatforms // ignore: cast_nullable_to_non_nullable
as List<String>,selectedGenres: null == selectedGenres ? _self.selectedGenres : selectedGenres // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FilterOptions].
extension FilterOptionsPatterns on FilterOptions {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilterOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilterOptions() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilterOptions value)  $default,){
final _that = this;
switch (_that) {
case _FilterOptions():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilterOptions value)?  $default,){
final _that = this;
switch (_that) {
case _FilterOptions() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContentType? contentType,  List<String> selectedPlatforms,  List<String> selectedGenres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilterOptions() when $default != null:
return $default(_that.contentType,_that.selectedPlatforms,_that.selectedGenres);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContentType? contentType,  List<String> selectedPlatforms,  List<String> selectedGenres)  $default,) {final _that = this;
switch (_that) {
case _FilterOptions():
return $default(_that.contentType,_that.selectedPlatforms,_that.selectedGenres);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContentType? contentType,  List<String> selectedPlatforms,  List<String> selectedGenres)?  $default,) {final _that = this;
switch (_that) {
case _FilterOptions() when $default != null:
return $default(_that.contentType,_that.selectedPlatforms,_that.selectedGenres);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FilterOptions extends FilterOptions {
  const _FilterOptions({this.contentType, final  List<String> selectedPlatforms = const [], final  List<String> selectedGenres = const []}): _selectedPlatforms = selectedPlatforms,_selectedGenres = selectedGenres,super._();
  factory _FilterOptions.fromJson(Map<String, dynamic> json) => _$FilterOptionsFromJson(json);

@override final  ContentType? contentType;
 final  List<String> _selectedPlatforms;
@override@JsonKey() List<String> get selectedPlatforms {
  if (_selectedPlatforms is EqualUnmodifiableListView) return _selectedPlatforms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedPlatforms);
}

 final  List<String> _selectedGenres;
@override@JsonKey() List<String> get selectedGenres {
  if (_selectedGenres is EqualUnmodifiableListView) return _selectedGenres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedGenres);
}


/// Create a copy of FilterOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterOptionsCopyWith<_FilterOptions> get copyWith => __$FilterOptionsCopyWithImpl<_FilterOptions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilterOptionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterOptions&&(identical(other.contentType, contentType) || other.contentType == contentType)&&const DeepCollectionEquality().equals(other._selectedPlatforms, _selectedPlatforms)&&const DeepCollectionEquality().equals(other._selectedGenres, _selectedGenres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentType,const DeepCollectionEquality().hash(_selectedPlatforms),const DeepCollectionEquality().hash(_selectedGenres));

@override
String toString() {
  return 'FilterOptions(contentType: $contentType, selectedPlatforms: $selectedPlatforms, selectedGenres: $selectedGenres)';
}


}

/// @nodoc
abstract mixin class _$FilterOptionsCopyWith<$Res> implements $FilterOptionsCopyWith<$Res> {
  factory _$FilterOptionsCopyWith(_FilterOptions value, $Res Function(_FilterOptions) _then) = __$FilterOptionsCopyWithImpl;
@override @useResult
$Res call({
 ContentType? contentType, List<String> selectedPlatforms, List<String> selectedGenres
});




}
/// @nodoc
class __$FilterOptionsCopyWithImpl<$Res>
    implements _$FilterOptionsCopyWith<$Res> {
  __$FilterOptionsCopyWithImpl(this._self, this._then);

  final _FilterOptions _self;
  final $Res Function(_FilterOptions) _then;

/// Create a copy of FilterOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentType = freezed,Object? selectedPlatforms = null,Object? selectedGenres = null,}) {
  return _then(_FilterOptions(
contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType?,selectedPlatforms: null == selectedPlatforms ? _self._selectedPlatforms : selectedPlatforms // ignore: cast_nullable_to_non_nullable
as List<String>,selectedGenres: null == selectedGenres ? _self._selectedGenres : selectedGenres // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PlatformData {

 String get name; String get logoUrl;
/// Create a copy of PlatformData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformDataCopyWith<PlatformData> get copyWith => _$PlatformDataCopyWithImpl<PlatformData>(this as PlatformData, _$identity);

  /// Serializes this PlatformData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformData&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,logoUrl);

@override
String toString() {
  return 'PlatformData(name: $name, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class $PlatformDataCopyWith<$Res>  {
  factory $PlatformDataCopyWith(PlatformData value, $Res Function(PlatformData) _then) = _$PlatformDataCopyWithImpl;
@useResult
$Res call({
 String name, String logoUrl
});




}
/// @nodoc
class _$PlatformDataCopyWithImpl<$Res>
    implements $PlatformDataCopyWith<$Res> {
  _$PlatformDataCopyWithImpl(this._self, this._then);

  final PlatformData _self;
  final $Res Function(PlatformData) _then;

/// Create a copy of PlatformData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? logoUrl = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformData].
extension PlatformDataPatterns on PlatformData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformData value)  $default,){
final _that = this;
switch (_that) {
case _PlatformData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformData value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformData() when $default != null:
return $default(_that.name,_that.logoUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String logoUrl)  $default,) {final _that = this;
switch (_that) {
case _PlatformData():
return $default(_that.name,_that.logoUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _PlatformData() when $default != null:
return $default(_that.name,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformData extends PlatformData {
  const _PlatformData({required this.name, required this.logoUrl}): super._();
  factory _PlatformData.fromJson(Map<String, dynamic> json) => _$PlatformDataFromJson(json);

@override final  String name;
@override final  String logoUrl;

/// Create a copy of PlatformData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformDataCopyWith<_PlatformData> get copyWith => __$PlatformDataCopyWithImpl<_PlatformData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformData&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,logoUrl);

@override
String toString() {
  return 'PlatformData(name: $name, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$PlatformDataCopyWith<$Res> implements $PlatformDataCopyWith<$Res> {
  factory _$PlatformDataCopyWith(_PlatformData value, $Res Function(_PlatformData) _then) = __$PlatformDataCopyWithImpl;
@override @useResult
$Res call({
 String name, String logoUrl
});




}
/// @nodoc
class __$PlatformDataCopyWithImpl<$Res>
    implements _$PlatformDataCopyWith<$Res> {
  __$PlatformDataCopyWithImpl(this._self, this._then);

  final _PlatformData _self;
  final $Res Function(_PlatformData) _then;

/// Create a copy of PlatformData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? logoUrl = null,}) {
  return _then(_PlatformData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
