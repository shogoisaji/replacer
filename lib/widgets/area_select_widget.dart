import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:replacer/models/area_model/area_model.dart';

class AreaSelectWidget extends HookConsumerWidget {
  final AreaModel area;
  final bool isSelected;
  final bool isRed;
  final double resizeRate;
  const AreaSelectWidget({
    super.key,
    required this.area,
    required this.isSelected,
    required this.isRed,
    required this.resizeRate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 4500),
    )..repeat(reverse: true);
    final fillColor = isRed ? Colors.red.shade300 : Colors.green;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: area.firstPointY < area.secondPointY ? area.firstPointY / resizeRate : area.secondPointY / resizeRate,
            left: area.firstPointX < area.secondPointX ? area.firstPointX / resizeRate : area.secondPointX / resizeRate,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Container(
                  width: (area.secondPointX - area.firstPointX).abs() / resizeRate,
                  height: (area.secondPointY - area.firstPointY).abs() / resizeRate,
                  decoration: BoxDecoration(
                    color: isSelected ? fillColor.withOpacity(0.2) : Colors.transparent,
                    border: Border.all(
                        color: isRed
                            ? HSVColor.fromAHSV(1.0, 55 * animationController.value, 0.7, 1).toColor()
                            : HSVColor.fromAHSV(1.0, 120 + 100 * animationController.value, 0.5, 1).toColor(),
                        width: 2.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
