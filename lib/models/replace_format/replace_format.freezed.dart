// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'replace_format.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReplaceFormat _$ReplaceFormatFromJson(Map<String, dynamic> json) {
  return _ReplaceFormat.fromJson(json);
}

/// @nodoc
mixin _$ReplaceFormat {
  String get formatId => throw _privateConstructorUsedError;
  String get formatName => throw _privateConstructorUsedError;
  @Uint8ListConverter()
  Uint8List? get thumbnailImage => throw _privateConstructorUsedError;
  List<ReplaceData> get replaceDataList => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReplaceFormatCopyWith<ReplaceFormat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplaceFormatCopyWith<$Res> {
  factory $ReplaceFormatCopyWith(
          ReplaceFormat value, $Res Function(ReplaceFormat) then) =
      _$ReplaceFormatCopyWithImpl<$Res, ReplaceFormat>;
  @useResult
  $Res call(
      {String formatId,
      String formatName,
      @Uint8ListConverter() Uint8List? thumbnailImage,
      List<ReplaceData> replaceDataList,
      DateTime createdAt});
}

/// @nodoc
class _$ReplaceFormatCopyWithImpl<$Res, $Val extends ReplaceFormat>
    implements $ReplaceFormatCopyWith<$Res> {
  _$ReplaceFormatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formatId = null,
    Object? formatName = null,
    Object? thumbnailImage = freezed,
    Object? replaceDataList = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      formatId: null == formatId
          ? _value.formatId
          : formatId // ignore: cast_nullable_to_non_nullable
              as String,
      formatName: null == formatName
          ? _value.formatName
          : formatName // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailImage: freezed == thumbnailImage
          ? _value.thumbnailImage
          : thumbnailImage // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      replaceDataList: null == replaceDataList
          ? _value.replaceDataList
          : replaceDataList // ignore: cast_nullable_to_non_nullable
              as List<ReplaceData>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReplaceFormatImplCopyWith<$Res>
    implements $ReplaceFormatCopyWith<$Res> {
  factory _$$ReplaceFormatImplCopyWith(
          _$ReplaceFormatImpl value, $Res Function(_$ReplaceFormatImpl) then) =
      __$$ReplaceFormatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String formatId,
      String formatName,
      @Uint8ListConverter() Uint8List? thumbnailImage,
      List<ReplaceData> replaceDataList,
      DateTime createdAt});
}

/// @nodoc
class __$$ReplaceFormatImplCopyWithImpl<$Res>
    extends _$ReplaceFormatCopyWithImpl<$Res, _$ReplaceFormatImpl>
    implements _$$ReplaceFormatImplCopyWith<$Res> {
  __$$ReplaceFormatImplCopyWithImpl(
      _$ReplaceFormatImpl _value, $Res Function(_$ReplaceFormatImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formatId = null,
    Object? formatName = null,
    Object? thumbnailImage = freezed,
    Object? replaceDataList = null,
    Object? createdAt = null,
  }) {
    return _then(_$ReplaceFormatImpl(
      formatId: null == formatId
          ? _value.formatId
          : formatId // ignore: cast_nullable_to_non_nullable
              as String,
      formatName: null == formatName
          ? _value.formatName
          : formatName // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailImage: freezed == thumbnailImage
          ? _value.thumbnailImage
          : thumbnailImage // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      replaceDataList: null == replaceDataList
          ? _value._replaceDataList
          : replaceDataList // ignore: cast_nullable_to_non_nullable
              as List<ReplaceData>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReplaceFormatImpl implements _ReplaceFormat {
  const _$ReplaceFormatImpl(
      {required this.formatId,
      required this.formatName,
      @Uint8ListConverter() this.thumbnailImage,
      required final List<ReplaceData> replaceDataList,
      required this.createdAt})
      : _replaceDataList = replaceDataList;

  factory _$ReplaceFormatImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReplaceFormatImplFromJson(json);

  @override
  final String formatId;
  @override
  final String formatName;
  @override
  @Uint8ListConverter()
  final Uint8List? thumbnailImage;
  final List<ReplaceData> _replaceDataList;
  @override
  List<ReplaceData> get replaceDataList {
    if (_replaceDataList is EqualUnmodifiableListView) return _replaceDataList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replaceDataList);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ReplaceFormat(formatId: $formatId, formatName: $formatName, thumbnailImage: $thumbnailImage, replaceDataList: $replaceDataList, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplaceFormatImpl &&
            (identical(other.formatId, formatId) ||
                other.formatId == formatId) &&
            (identical(other.formatName, formatName) ||
                other.formatName == formatName) &&
            const DeepCollectionEquality()
                .equals(other.thumbnailImage, thumbnailImage) &&
            const DeepCollectionEquality()
                .equals(other._replaceDataList, _replaceDataList) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      formatId,
      formatName,
      const DeepCollectionEquality().hash(thumbnailImage),
      const DeepCollectionEquality().hash(_replaceDataList),
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplaceFormatImplCopyWith<_$ReplaceFormatImpl> get copyWith =>
      __$$ReplaceFormatImplCopyWithImpl<_$ReplaceFormatImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReplaceFormatImplToJson(
      this,
    );
  }
}

abstract class _ReplaceFormat implements ReplaceFormat {
  const factory _ReplaceFormat(
      {required final String formatId,
      required final String formatName,
      @Uint8ListConverter() final Uint8List? thumbnailImage,
      required final List<ReplaceData> replaceDataList,
      required final DateTime createdAt}) = _$ReplaceFormatImpl;

  factory _ReplaceFormat.fromJson(Map<String, dynamic> json) =
      _$ReplaceFormatImpl.fromJson;

  @override
  String get formatId;
  @override
  String get formatName;
  @override
  @Uint8ListConverter()
  Uint8List? get thumbnailImage;
  @override
  List<ReplaceData> get replaceDataList;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ReplaceFormatImplCopyWith<_$ReplaceFormatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
