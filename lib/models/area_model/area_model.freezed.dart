// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'area_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AreaModel _$AreaModelFromJson(Map<String, dynamic> json) {
  return _AreaModel.fromJson(json);
}

/// @nodoc
mixin _$AreaModel {
  double get firstPointX => throw _privateConstructorUsedError;
  double get firstPointY => throw _privateConstructorUsedError;
  double get secondPointX => throw _privateConstructorUsedError;
  double get secondPointY => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AreaModelCopyWith<AreaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AreaModelCopyWith<$Res> {
  factory $AreaModelCopyWith(AreaModel value, $Res Function(AreaModel) then) =
      _$AreaModelCopyWithImpl<$Res, AreaModel>;
  @useResult
  $Res call(
      {double firstPointX,
      double firstPointY,
      double secondPointX,
      double secondPointY});
}

/// @nodoc
class _$AreaModelCopyWithImpl<$Res, $Val extends AreaModel>
    implements $AreaModelCopyWith<$Res> {
  _$AreaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstPointX = null,
    Object? firstPointY = null,
    Object? secondPointX = null,
    Object? secondPointY = null,
  }) {
    return _then(_value.copyWith(
      firstPointX: null == firstPointX
          ? _value.firstPointX
          : firstPointX // ignore: cast_nullable_to_non_nullable
              as double,
      firstPointY: null == firstPointY
          ? _value.firstPointY
          : firstPointY // ignore: cast_nullable_to_non_nullable
              as double,
      secondPointX: null == secondPointX
          ? _value.secondPointX
          : secondPointX // ignore: cast_nullable_to_non_nullable
              as double,
      secondPointY: null == secondPointY
          ? _value.secondPointY
          : secondPointY // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AreaModelImplCopyWith<$Res>
    implements $AreaModelCopyWith<$Res> {
  factory _$$AreaModelImplCopyWith(
          _$AreaModelImpl value, $Res Function(_$AreaModelImpl) then) =
      __$$AreaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double firstPointX,
      double firstPointY,
      double secondPointX,
      double secondPointY});
}

/// @nodoc
class __$$AreaModelImplCopyWithImpl<$Res>
    extends _$AreaModelCopyWithImpl<$Res, _$AreaModelImpl>
    implements _$$AreaModelImplCopyWith<$Res> {
  __$$AreaModelImplCopyWithImpl(
      _$AreaModelImpl _value, $Res Function(_$AreaModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstPointX = null,
    Object? firstPointY = null,
    Object? secondPointX = null,
    Object? secondPointY = null,
  }) {
    return _then(_$AreaModelImpl(
      firstPointX: null == firstPointX
          ? _value.firstPointX
          : firstPointX // ignore: cast_nullable_to_non_nullable
              as double,
      firstPointY: null == firstPointY
          ? _value.firstPointY
          : firstPointY // ignore: cast_nullable_to_non_nullable
              as double,
      secondPointX: null == secondPointX
          ? _value.secondPointX
          : secondPointX // ignore: cast_nullable_to_non_nullable
              as double,
      secondPointY: null == secondPointY
          ? _value.secondPointY
          : secondPointY // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AreaModelImpl implements _AreaModel {
  const _$AreaModelImpl(
      {required this.firstPointX,
      required this.firstPointY,
      required this.secondPointX,
      required this.secondPointY});

  factory _$AreaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AreaModelImplFromJson(json);

  @override
  final double firstPointX;
  @override
  final double firstPointY;
  @override
  final double secondPointX;
  @override
  final double secondPointY;

  @override
  String toString() {
    return 'AreaModel(firstPointX: $firstPointX, firstPointY: $firstPointY, secondPointX: $secondPointX, secondPointY: $secondPointY)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AreaModelImpl &&
            (identical(other.firstPointX, firstPointX) ||
                other.firstPointX == firstPointX) &&
            (identical(other.firstPointY, firstPointY) ||
                other.firstPointY == firstPointY) &&
            (identical(other.secondPointX, secondPointX) ||
                other.secondPointX == secondPointX) &&
            (identical(other.secondPointY, secondPointY) ||
                other.secondPointY == secondPointY));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, firstPointX, firstPointY, secondPointX, secondPointY);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AreaModelImplCopyWith<_$AreaModelImpl> get copyWith =>
      __$$AreaModelImplCopyWithImpl<_$AreaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AreaModelImplToJson(
      this,
    );
  }
}

abstract class _AreaModel implements AreaModel {
  const factory _AreaModel(
      {required final double firstPointX,
      required final double firstPointY,
      required final double secondPointX,
      required final double secondPointY}) = _$AreaModelImpl;

  factory _AreaModel.fromJson(Map<String, dynamic> json) =
      _$AreaModelImpl.fromJson;

  @override
  double get firstPointX;
  @override
  double get firstPointY;
  @override
  double get secondPointX;
  @override
  double get secondPointY;
  @override
  @JsonKey(ignore: true)
  _$$AreaModelImplCopyWith<_$AreaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
