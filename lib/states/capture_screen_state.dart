import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'capture_screen_state.g.dart';

@riverpod
class CaptureScreenState extends _$CaptureScreenState {
  @override
  ui.Image? build() => null;

  // void setCaptureScreen(ui.Image image) => state = image;

  void clear() => state = null;

  Future<void> clipImage(ui.Image image, Rect rect) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.translate(-rect.left, -rect.top);

    canvas.clipRect(rect);

    canvas.drawImage(image, Offset.zero, Paint());

    final picture = recorder.endRecording();
    final clippedImage = await picture.toImage(rect.width.toInt(), rect.height.toInt());

    state = clippedImage;
  }
}
