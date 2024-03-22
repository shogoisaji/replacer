import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ThumbnailResizeUint8ListConverter {
  Future<Uint8List> convertThumbnail(ui.Image uiImage, int targetWidth, int targetHeight) async {
    // リサイズ処理
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;
    final scale = targetWidth / uiImage.width;
    final rect = Rect.fromLTWH(0, 0, targetWidth.toDouble(), (uiImage.height * scale).toDouble());
    canvas.drawImageRect(
        uiImage, Rect.fromLTWH(0, 0, uiImage.width.toDouble(), uiImage.height.toDouble()), rect, paint);
    final picture = recorder.endRecording();
    final resizedImage = await picture.toImage(targetWidth, targetHeight);

    // Uint8List に変換
    final byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) throw Exception('Failed to convert resized ui.Image to ByteData');
    return byteData.buffer.asUint8List();
  }
}
