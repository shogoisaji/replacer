import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:replacer/use_case/clip_image_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'capture_screen_state.g.dart';

@riverpod
class CaptureScreenState extends _$CaptureScreenState {
  @override
  ui.Image? build() => null;

  void clear() => state = null;

  Future<void> clipImage(ui.Image image, Rect rect) async {
    final clippedImage = await ClipImageUseCase().clipImage(image, rect);
    state = clippedImage;
  }
}
