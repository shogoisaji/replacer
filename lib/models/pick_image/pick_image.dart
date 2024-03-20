import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'pick_image.freezed.dart';

@freezed
class PickImage with _$PickImage {
  const factory PickImage({
    XFile? image,
    Size? size,
  }) = _PickImage;
}
