import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:replacer/models/area_model/area_model.dart';
import 'package:replacer/models/pick_image/pick_image.dart';
import 'package:replacer/states/image_pick_state.dart';

class CaptureWidget extends HookConsumerWidget {
  final AreaModel area;
  final Color color;
  final GlobalKey clipKey;
  const CaptureWidget({
    Key? key,
    required this.area,
    required this.color,
    required this.clipKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final PickImage? pickImage = ref.watch(pickImageStateProvider);

    return pickImage != null
        ? SizedBox(
            width: w,
            height: w * (pickImage.image.height / pickImage.image.width),
            child: RepaintBoundary(
              key: clipKey,
              child: CustomPaint(
                painter: ClipPainter(
                  area: area,
                  image: pickImage.image,
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

class ClipPainter extends CustomPainter {
  final AreaModel area;
  final ui.Image image;
  const ClipPainter({
    required this.area,
    required this.image,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // クリッピングするパスを定義
    Path clipPath = Path()
      ..addRect(
          Rect.fromPoints(Offset(area.firstPointX, area.firstPointY), Offset(area.secondPointX, area.secondPointY)));
    canvas.clipPath(clipPath);
    // 画像を描画
    final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
