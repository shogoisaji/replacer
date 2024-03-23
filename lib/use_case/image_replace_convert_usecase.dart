import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:replacer/use_case/clip_image_usecase.dart';

class ImageReplaceConvertUseCase {
  Future<Uint8List> convertImage(ui.Image image, ReplaceFormat format, double w) async {
    final clippedImageDataList = <ClippedImageData>[];
    final sizeConvertRate = image.width / w;
    for (ReplaceData data in format.replaceDataList) {
      final area = data.area;
      final rect = Rect.fromPoints(Offset(area.firstPointX * sizeConvertRate, area.firstPointY * sizeConvertRate),
          Offset(area.secondPointX * sizeConvertRate, area.secondPointY * sizeConvertRate));
      final clippedImage = await ClipImageUseCase().clipImage(image, rect);
      final offsetOrigin = Offset(min(area.firstPointX, area.secondPointX) + data.moveDelta.dx,
          min(area.firstPointY, area.secondPointY) + data.moveDelta.dy);
      clippedImageDataList.add(ClippedImageData(image: clippedImage, offsetOrigin: offsetOrigin));
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    canvas.drawImage(image, Offset.zero, paint);

    for (final clippedImageData in clippedImageDataList) {
      final imageSize = Size(clippedImageData.image.width.toDouble(), clippedImageData.image.height.toDouble());
      final src = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
      final dstOffset = Offset(
          clippedImageData.offsetOrigin.dx * sizeConvertRate, clippedImageData.offsetOrigin.dy * sizeConvertRate);
      print(dstOffset);
      final dst = Rect.fromLTWH(dstOffset.dx, dstOffset.dy, imageSize.width, imageSize.height);
      canvas.drawImageRect(clippedImageData.image, src, dst, paint);
    }

    final picture = recorder.endRecording();
    final combinedImage = await picture.toImage((image.width).toInt(), (image.height).toInt());
    final byteData = await combinedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

class ClippedImageData {
  final ui.Image image;
  final Offset offsetOrigin;

  const ClippedImageData({
    required this.image,
    required this.offsetOrigin,
  });
}
