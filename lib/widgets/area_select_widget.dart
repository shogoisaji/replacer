import 'package:flutter/material.dart';
import 'package:replacer/models/area_model/area_model.dart';

class AreaSelectWidget extends StatelessWidget {
  final AreaModel area;
  final Color color;
  final bool isSelected;
  const AreaSelectWidget({super.key, required this.area, required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: area.firstPointY < area.secondPointY ? area.firstPointY : area.secondPointY,
            left: area.firstPointX < area.secondPointX ? area.firstPointX : area.secondPointX,
            child: Container(
              width: (area.secondPointX - area.firstPointX).abs(),
              height: (area.secondPointY - area.firstPointY).abs(),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
                border: Border.all(color: color, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
