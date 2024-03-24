import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:replacer/models/area_model/area_model.dart';

class AreaSelectWidget extends HookConsumerWidget {
  final AreaModel area;
  final Color color;
  final bool isSelected;
  final double resizeRate;
  const AreaSelectWidget({
    super.key,
    required this.area,
    required this.color,
    required this.isSelected,
    required this.resizeRate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: area.firstPointY < area.secondPointY ? area.firstPointY / resizeRate : area.secondPointY / resizeRate,
            left: area.firstPointX < area.secondPointX ? area.firstPointX / resizeRate : area.secondPointX / resizeRate,
            child: Container(
              width: (area.secondPointX - area.firstPointX).abs() / resizeRate,
              height: (area.secondPointY - area.firstPointY).abs() / resizeRate,
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
                border: Border.all(color: color, width: 2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
