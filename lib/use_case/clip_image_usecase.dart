import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ClipImageUseCase {
  Future<ui.Image> clipImage(ui.Image image, Rect rect) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.translate(-rect.left, -rect.top);

    canvas.clipRect(rect);

    canvas.drawImage(image, Offset.zero, Paint());

    final picture = recorder.endRecording();
    final clippedImage = await picture.toImage(rect.width.toInt(), rect.height.toInt());

    return clippedImage;
  }
}
