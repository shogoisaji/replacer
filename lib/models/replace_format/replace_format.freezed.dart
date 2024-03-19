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
  String get templateId => throw _privateConstructorUsedError;
  String get templateName => throw _privateConstructorUsedError;
  String get thumbnailImage => throw _privateConstructorUsedError;
  ReplaceData get replaceData => throw _privateConstructorUsedError;
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
      {String templateId,
      String templateName,
      String thumbnailImage,
      ReplaceData replaceData,
      DateTime createdAt});

  $ReplaceDataCopyWith<$Res> get replaceData;
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
    Object? templateId = null,
    Object? templateName = null,
    Object? thumbnailImage = null,
    Object? replaceData = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailImage: null == thumbnailImage
          ? _value.thumbnailImage
          : thumbnailImage // ignore: cast_nullable_to_non_nullable
              as String,
      replaceData: null == replaceData
          ? _value.replaceData
          : replaceData // ignore: cast_nullable_to_non_nullable
              as ReplaceData,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReplaceDataCopyWith<$Res> get replaceData {
    return $ReplaceDataCopyWith<$Res>(_value.replaceData, (value) {
      return _then(_value.copyWith(replaceData: value) as $Val);
    });
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
      {String templateId,
      String templateName,
      String thumbnailImage,
      ReplaceData replaceData,
      DateTime createdAt});

  @override
  $ReplaceDataCopyWith<$Res> get replaceData;
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
    Object? templateId = null,
    Object? templateName = null,
    Object? thumbnailImage = null,
    Object? replaceData = null,
    Object? createdAt = null,
  }) {
    return _then(_$ReplaceFormatImpl(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailImage: null == thumbnailImage
          ? _value.thumbnailImage
          : thumbnailImage // ignore: cast_nullable_to_non_nullable
              as String,
      replaceData: null == replaceData
          ? _value.replaceData
          : replaceData // ignore: cast_nullable_to_non_nullable
              as ReplaceData,
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
      {required this.templateId,
      required this.templateName,
      required this.thumbnailImage,
      required this.replaceData,
      required this.createdAt});

  factory _$ReplaceFormatImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReplaceFormatImplFromJson(json);

  @override
  final String templateId;
  @override
  final String templateName;
  @override
  final String thumbnailImage;
  @override
  final ReplaceData replaceData;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ReplaceFormat(templateId: $templateId, templateName: $templateName, thumbnailImage: $thumbnailImage, replaceData: $replaceData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplaceFormatImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            (identical(other.thumbnailImage, thumbnailImage) ||
                other.thumbnailImage == thumbnailImage) &&
            (identical(other.replaceData, replaceData) ||
                other.replaceData == replaceData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, templateId, templateName,
      thumbnailImage, replaceData, createdAt);

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
      {required final String templateId,
      required final String templateName,
      required final String thumbnailImage,
      required final ReplaceData replaceData,
      required final DateTime createdAt}) = _$ReplaceFormatImpl;

  factory _ReplaceFormat.fromJson(Map<String, dynamic> json) =
      _$ReplaceFormatImpl.fromJson;

  @override
  String get templateId;
  @override
  String get templateName;
  @override
  String get thumbnailImage;
  @override
  ReplaceData get replaceData;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ReplaceFormatImplCopyWith<_$ReplaceFormatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
