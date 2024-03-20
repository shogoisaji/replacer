// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pick_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PickImage {
  XFile? get image => throw _privateConstructorUsedError;
  Size? get size => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PickImageCopyWith<PickImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PickImageCopyWith<$Res> {
  factory $PickImageCopyWith(PickImage value, $Res Function(PickImage) then) =
      _$PickImageCopyWithImpl<$Res, PickImage>;
  @useResult
  $Res call({XFile? image, Size? size});
}

/// @nodoc
class _$PickImageCopyWithImpl<$Res, $Val extends PickImage>
    implements $PickImageCopyWith<$Res> {
  _$PickImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = freezed,
    Object? size = freezed,
  }) {
    return _then(_value.copyWith(
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as XFile?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PickImageImplCopyWith<$Res>
    implements $PickImageCopyWith<$Res> {
  factory _$$PickImageImplCopyWith(
          _$PickImageImpl value, $Res Function(_$PickImageImpl) then) =
      __$$PickImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({XFile? image, Size? size});
}

/// @nodoc
class __$$PickImageImplCopyWithImpl<$Res>
    extends _$PickImageCopyWithImpl<$Res, _$PickImageImpl>
    implements _$$PickImageImplCopyWith<$Res> {
  __$$PickImageImplCopyWithImpl(
      _$PickImageImpl _value, $Res Function(_$PickImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = freezed,
    Object? size = freezed,
  }) {
    return _then(_$PickImageImpl(
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as XFile?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as Size?,
    ));
  }
}

/// @nodoc

class _$PickImageImpl implements _PickImage {
  const _$PickImageImpl({this.image, this.size});

  @override
  final XFile? image;
  @override
  final Size? size;

  @override
  String toString() {
    return 'PickImage(image: $image, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickImageImpl &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.size, size) || other.size == size));
  }

  @override
  int get hashCode => Object.hash(runtimeType, image, size);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PickImageImplCopyWith<_$PickImageImpl> get copyWith =>
      __$$PickImageImplCopyWithImpl<_$PickImageImpl>(this, _$identity);
}

abstract class _PickImage implements PickImage {
  const factory _PickImage({final XFile? image, final Size? size}) =
      _$PickImageImpl;

  @override
  XFile? get image;
  @override
  Size? get size;
  @override
  @JsonKey(ignore: true)
  _$$PickImageImplCopyWith<_$PickImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
