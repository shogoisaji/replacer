import 'package:flutter/material.dart';
import 'package:replacer/theme/color_theme.dart';

class MyTextStyles {
  static TextStyle get title {
    return const TextStyle(
        fontSize: 54,
        fontWeight: FontWeight.w900,
        color: Color(MyColors.light),
        fontFamily: 'InterTight',
        overflow: TextOverflow.ellipsis);
  }

  static TextStyle get subtitle {
    return const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Color(MyColors.light),
        fontFamily: 'InterTight',
        overflow: TextOverflow.ellipsis);
  }

  static TextStyle get subtitleOrange {
    return const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Color(MyColors.orange1),
        fontFamily: 'InterTight',
        overflow: TextOverflow.ellipsis);
  }

  static TextStyle get body {
    return const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis);
  }
}
