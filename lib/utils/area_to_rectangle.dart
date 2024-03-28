import 'dart:math';
import 'dart:ui';

import 'package:replacer/models/area_model/area_model.dart';

class AreaToRectangle {
  Rect convert(AreaModel area) {
    //
    final basePointX = min(area.firstPointX, area.secondPointX);
    final basePointY = min(area.firstPointY, area.secondPointY);
    final width = (area.firstPointX - area.secondPointX).abs();
    final height = (area.firstPointY - area.secondPointY).abs();

    return Rect.fromPoints(Offset(basePointX, basePointY), Offset(basePointX + width, basePointY + height));
  }
}
