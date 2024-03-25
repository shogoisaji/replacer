import 'package:flutter/material.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';

SnackBar customSnackBar(String text, bool isOrangeBg) {
  final bgColor = isOrangeBg ? const Color(MyColors.orange1) : const Color(MyColors.light);
  final subColor = isOrangeBg ? const Color(MyColors.light) : const Color(MyColors.orange1);
  return SnackBar(
    duration: const Duration(milliseconds: 1700),
    padding: EdgeInsets.zero,
    backgroundColor: bgColor,
    content: Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: subColor,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: bgColor,
        ),
        Container(
          width: double.infinity,
          height: 2,
          color: subColor,
        ),
        Container(
          width: double.infinity,
          height: 2,
          color: bgColor,
        ),
        Container(
          width: double.infinity,
          height: 3,
          color: subColor,
        ),
        Container(
          width: double.infinity,
          height: 3,
          color: bgColor,
        ),
        Container(
          width: double.infinity,
          height: 4,
          color: subColor,
        ),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            color: bgColor,
            child: Center(
                child: Text(text, style: isOrangeBg ? MyTextStyles.largeBodyLight : MyTextStyles.largeBodyOrange))),
      ],
    ),
  );
}
