import 'package:flutter/material.dart';
import 'package:replacer/theme/color_theme.dart';

class MyTextStyles {
  static TextStyle get title {
    return const TextStyle(
        fontSize: 54, fontWeight: FontWeight.w900, fontFamily: 'InterTight', overflow: TextOverflow.ellipsis);
  }

  static TextStyle get subtitle {
    return const TextStyle(
        fontSize: 32, fontWeight: FontWeight.w700, fontFamily: 'InterTight', overflow: TextOverflow.ellipsis);
  }

  // static TextStyle get subtitleOrange {
  //   return const TextStyle(
  //       fontSize: 32,
  //       fontWeight: FontWeight.w700,
  //       color: Color(MyColors.orange1),
  //       fontFamily: 'InterTight',
  //       overflow: TextOverflow.ellipsis);
  // }

  static TextStyle get largeBody {
    return const TextStyle(fontWeight: FontWeight.w700, fontSize: 24, overflow: TextOverflow.ellipsis);
  }

  // static TextStyle get largeBodyOrange {
  //   return const TextStyle(
  //       color: Color(MyColors.orange1), fontWeight: FontWeight.w700, fontSize: 24, overflow: TextOverflow.ellipsis);
  // }

  static TextStyle get middleOrange {
    return const TextStyle(
        color: Color(MyColors.orange1), fontWeight: FontWeight.w700, fontSize: 20, overflow: TextOverflow.ellipsis);
  }

  static TextStyle get body {
    return const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis);
  }

  // static TextStyle get bodyOrange {
  //   return const TextStyle(
  //       color: Color(MyColors.orange1), fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis);
  // }

  static TextStyle get small {
    return const TextStyle(height: 0.7, fontWeight: FontWeight.w500, fontSize: 12, overflow: TextOverflow.ellipsis);
  }

  // static TextStyle get smallOrange {
  //   return const TextStyle(
  //       color: Color(MyColors.orange1),
  //       height: 0.7,
  //       fontWeight: FontWeight.w500,
  //       fontSize: 12,
  //       overflow: TextOverflow.ellipsis);
  // }
}
