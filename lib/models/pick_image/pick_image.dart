import 'dart:ui' as ui;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pick_image.freezed.dart';

@freezed
class PickImage with _$PickImage {
  const factory PickImage({
    required ui.Image image,
  }) = _PickImage;
}
