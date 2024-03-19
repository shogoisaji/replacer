// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'replace_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReplaceData _$ReplaceDataFromJson(Map<String, dynamic> json) {
  return _ReplaceData.fromJson(json);
}

/// @nodoc
mixin _$ReplaceData {
  String get replaceDataId => throw _privateConstructorUsedError;
  AreaModel get area => throw _privateConstructorUsedError;
  MoveDelta get moveDelta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReplaceDataCopyWith<ReplaceData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplaceDataCopyWith<$Res> {
  factory $ReplaceDataCopyWith(
          ReplaceData value, $Res Function(ReplaceData) then) =
      _$ReplaceDataCopyWithImpl<$Res, ReplaceData>;
  @useResult
  $Res call({String replaceDataId, AreaModel area, MoveDelta moveDelta});

  $AreaModelCopyWith<$Res> get area;
  $MoveDeltaCopyWith<$Res> get moveDelta;
}

/// @nodoc
class _$ReplaceDataCopyWithImpl<$Res, $Val extends ReplaceData>
    implements $ReplaceDataCopyWith<$Res> {
  _$ReplaceDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? replaceDataId = null,
    Object? area = null,
    Object? moveDelta = null,
  }) {
    return _then(_value.copyWith(
      replaceDataId: null == replaceDataId
          ? _value.replaceDataId
          : replaceDataId // ignore: cast_nullable_to_non_nullable
              as String,
      area: null == area
          ? _value.area
          : area // ignore: cast_nullable_to_non_nullable
              as AreaModel,
      moveDelta: null == moveDelta
          ? _value.moveDelta
          : moveDelta // ignore: cast_nullable_to_non_nullable
              as MoveDelta,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AreaModelCopyWith<$Res> get area {
    return $AreaModelCopyWith<$Res>(_value.area, (value) {
      return _then(_value.copyWith(area: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MoveDeltaCopyWith<$Res> get moveDelta {
    return $MoveDeltaCopyWith<$Res>(_value.moveDelta, (value) {
      return _then(_value.copyWith(moveDelta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReplaceDataImplCopyWith<$Res>
    implements $ReplaceDataCopyWith<$Res> {
  factory _$$ReplaceDataImplCopyWith(
          _$ReplaceDataImpl value, $Res Function(_$ReplaceDataImpl) then) =
      __$$ReplaceDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String replaceDataId, AreaModel area, MoveDelta moveDelta});

  @override
  $AreaModelCopyWith<$Res> get area;
  @override
  $MoveDeltaCopyWith<$Res> get moveDelta;
}

/// @nodoc
class __$$ReplaceDataImplCopyWithImpl<$Res>
    extends _$ReplaceDataCopyWithImpl<$Res, _$ReplaceDataImpl>
    implements _$$ReplaceDataImplCopyWith<$Res> {
  __$$ReplaceDataImplCopyWithImpl(
      _$ReplaceDataImpl _value, $Res Function(_$ReplaceDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? replaceDataId = null,
    Object? area = null,
    Object? moveDelta = null,
  }) {
    return _then(_$ReplaceDataImpl(
      replaceDataId: null == replaceDataId
          ? _value.replaceDataId
          : replaceDataId // ignore: cast_nullable_to_non_nullable
              as String,
      area: null == area
          ? _value.area
          : area // ignore: cast_nullable_to_non_nullable
              as AreaModel,
      moveDelta: null == moveDelta
          ? _value.moveDelta
          : moveDelta // ignore: cast_nullable_to_non_nullable
              as MoveDelta,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReplaceDataImpl implements _ReplaceData {
  const _$ReplaceDataImpl(
      {required this.replaceDataId,
      required this.area,
      required this.moveDelta});

  factory _$ReplaceDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReplaceDataImplFromJson(json);

  @override
  final String replaceDataId;
  @override
  final AreaModel area;
  @override
  final MoveDelta moveDelta;

  @override
  String toString() {
    return 'ReplaceData(replaceDataId: $replaceDataId, area: $area, moveDelta: $moveDelta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplaceDataImpl &&
            (identical(other.replaceDataId, replaceDataId) ||
                other.replaceDataId == replaceDataId) &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.moveDelta, moveDelta) ||
                other.moveDelta == moveDelta));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, replaceDataId, area, moveDelta);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplaceDataImplCopyWith<_$ReplaceDataImpl> get copyWith =>
      __$$ReplaceDataImplCopyWithImpl<_$ReplaceDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReplaceDataImplToJson(
      this,
    );
  }
}

abstract class _ReplaceData implements ReplaceData {
  const factory _ReplaceData(
      {required final String replaceDataId,
      required final AreaModel area,
      required final MoveDelta moveDelta}) = _$ReplaceDataImpl;

  factory _ReplaceData.fromJson(Map<String, dynamic> json) =
      _$ReplaceDataImpl.fromJson;

  @override
  String get replaceDataId;
  @override
  AreaModel get area;
  @override
  MoveDelta get moveDelta;
  @override
  @JsonKey(ignore: true)
  _$$ReplaceDataImplCopyWith<_$ReplaceDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
