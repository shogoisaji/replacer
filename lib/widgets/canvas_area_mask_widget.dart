import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:replacer/models/area_model/area_model.dart';
import 'package:replacer/theme/color_theme.dart';

class CanvasAreaMaskWidget extends HookConsumerWidget {
  final AreaModel area;
  final double resizeRate;
  final Size imageSize;
  const CanvasAreaMaskWidget({
    super.key,
    required this.area,
    required this.resizeRate,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          CustomPaint(
            painter: MaskPaint(area, resizeRate, imageSize),
            child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
          )
        ],
      ),
    );
  }
}

class MaskPaint extends CustomPainter {
  final AreaModel area;
  final double resizeRate;
  final Size imageSize;
  MaskPaint(this.area, this.resizeRate, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint()
      ..color = const Color(MyColors.orange2).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    path.moveTo(0, 0);
    path.lineTo(imageSize.width / resizeRate, 0);
    path.lineTo(imageSize.width / resizeRate, imageSize.height / resizeRate);
    path.lineTo(0, imageSize.height / resizeRate);
    path.lineTo(area.firstPointX / resizeRate, area.secondPointY / resizeRate);
    path.lineTo(area.secondPointX / resizeRate, area.secondPointY / resizeRate);
    path.lineTo(area.secondPointX / resizeRate, area.firstPointY / resizeRate);
    path.lineTo(area.firstPointX / resizeRate, area.firstPointY / resizeRate);
    path.lineTo(area.firstPointX / resizeRate, area.secondPointY / resizeRate);

    path.lineTo(0, imageSize.height / resizeRate);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
