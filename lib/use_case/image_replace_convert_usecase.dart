import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:replacer/use_case/clip_image_usecase.dart';

class ImageReplaceConvertUseCase {
  Future<Uint8List> convertImage(
    ui.Image image,
    ReplaceFormat format,
    double imageSizeConvertRate,
  ) async {
    final clippedImageDataList = <ClippedImageData>[];
    for (ReplaceData data in format.replaceDataList) {
      final area = data.area;
      final rect =
          Rect.fromPoints(Offset(area.firstPointX, area.firstPointY), Offset(area.secondPointX, area.secondPointY));
      final clippedImage = await ClipImageUseCase().clipImage(image, rect);
      final offsetOrigin = Offset(min(area.firstPointX, area.secondPointX) + data.moveDelta.dx,
          min(area.firstPointY, area.secondPointY) + data.moveDelta.dy);
      clippedImageDataList.add(ClippedImageData(image: clippedImage, offsetOrigin: offsetOrigin));
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    canvas.translate(-format.canvasArea!.firstPointX, -format.canvasArea!.firstPointY);

    canvas.clipRect(Rect.fromPoints(Offset(format.canvasArea!.firstPointX, format.canvasArea!.firstPointY),
        Offset(format.canvasArea!.secondPointX, format.canvasArea!.secondPointY)));

    canvas.drawImage(image, Offset.zero, paint);

    for (final clippedImageData in clippedImageDataList) {
      final imageSize = Size(clippedImageData.image.width.toDouble(), clippedImageData.image.height.toDouble());
      final src = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
      final dstOffset = Offset(clippedImageData.offsetOrigin.dx, clippedImageData.offsetOrigin.dy);
      final dst = Rect.fromLTWH(dstOffset.dx, dstOffset.dy, imageSize.width, imageSize.height);
      canvas.drawImageRect(clippedImageData.image, src, dst, paint);
    }
    Size((format.canvasArea!.firstPointX - format.canvasArea!.secondPointX).abs(),
        (format.canvasArea!.firstPointY - format.canvasArea!.secondPointY).abs());
    final picture = recorder.endRecording();
    final combinedImage = await picture.toImage(
        (format.canvasArea!.firstPointX - format.canvasArea!.secondPointX).abs().toInt(),
        (format.canvasArea!.firstPointY - format.canvasArea!.secondPointY).abs().toInt());
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
