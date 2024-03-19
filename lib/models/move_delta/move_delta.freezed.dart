// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'move_delta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MoveDelta _$MoveDeltaFromJson(Map<String, dynamic> json) {
  return _MoveDelta.fromJson(json);
}

/// @nodoc
mixin _$MoveDelta {
  double get dx => throw _privateConstructorUsedError;
  double get dy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MoveDeltaCopyWith<MoveDelta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoveDeltaCopyWith<$Res> {
  factory $MoveDeltaCopyWith(MoveDelta value, $Res Function(MoveDelta) then) =
      _$MoveDeltaCopyWithImpl<$Res, MoveDelta>;
  @useResult
  $Res call({double dx, double dy});
}

/// @nodoc
class _$MoveDeltaCopyWithImpl<$Res, $Val extends MoveDelta>
    implements $MoveDeltaCopyWith<$Res> {
  _$MoveDeltaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
  }) {
    return _then(_value.copyWith(
      dx: null == dx
          ? _value.dx
          : dx // ignore: cast_nullable_to_non_nullable
              as double,
      dy: null == dy
          ? _value.dy
          : dy // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoveDeltaImplCopyWith<$Res>
    implements $MoveDeltaCopyWith<$Res> {
  factory _$$MoveDeltaImplCopyWith(
          _$MoveDeltaImpl value, $Res Function(_$MoveDeltaImpl) then) =
      __$$MoveDeltaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double dx, double dy});
}

/// @nodoc
class __$$MoveDeltaImplCopyWithImpl<$Res>
    extends _$MoveDeltaCopyWithImpl<$Res, _$MoveDeltaImpl>
    implements _$$MoveDeltaImplCopyWith<$Res> {
  __$$MoveDeltaImplCopyWithImpl(
      _$MoveDeltaImpl _value, $Res Function(_$MoveDeltaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
  }) {
    return _then(_$MoveDeltaImpl(
      dx: null == dx
          ? _value.dx
          : dx // ignore: cast_nullable_to_non_nullable
              as double,
      dy: null == dy
          ? _value.dy
          : dy // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoveDeltaImpl implements _MoveDelta {
  const _$MoveDeltaImpl({required this.dx, required this.dy});

  factory _$MoveDeltaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoveDeltaImplFromJson(json);

  @override
  final double dx;
  @override
  final double dy;

  @override
  String toString() {
    return 'MoveDelta(dx: $dx, dy: $dy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoveDeltaImpl &&
            (identical(other.dx, dx) || other.dx == dx) &&
            (identical(other.dy, dy) || other.dy == dy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, dx, dy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoveDeltaImplCopyWith<_$MoveDeltaImpl> get copyWith =>
      __$$MoveDeltaImplCopyWithImpl<_$MoveDeltaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoveDeltaImplToJson(
      this,
    );
  }
}

abstract class _MoveDelta implements MoveDelta {
  const factory _MoveDelta(
      {required final double dx, required final double dy}) = _$MoveDeltaImpl;

  factory _MoveDelta.fromJson(Map<String, dynamic> json) =
      _$MoveDeltaImpl.fromJson;

  @override
  double get dx;
  @override
  double get dy;
  @override
  @JsonKey(ignore: true)
  _$$MoveDeltaImplCopyWith<_$MoveDeltaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
