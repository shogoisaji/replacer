import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:replacer/models/pick_image/pick_image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_pick_state.g.dart';

@riverpod
class PickImageState extends _$PickImageState {
  @override
  PickImage? build() => null;

  void setPickImage(ui.Image image) => state = PickImage(image: image);

  void clear() => state = null;
}
