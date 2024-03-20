import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replacer/models/pick_image/pick_image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_pick_state.g.dart';

@riverpod
class PickImageState extends _$PickImageState {
  @override
  PickImage? build() => const PickImage(image: null, size: null);

  void setPickImage(XFile image, Size size) => state = PickImage(image: image, size: size);

  void clear() => state = const PickImage(image: null, size: null);
}
