// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:replacer/states/capture_screen_key_state.dart';
// import 'package:replacer/states/capture_screen_state.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'capture_area_screen_usecase.g.dart';

// @Riverpod(keepAlive: true)
// Future<void> captureAreaScreenUseCase(CaptureAreaScreenUseCaseRef ref) async {
//   final key = ref.watch(captureScreenKeyStateProvider);
//   if (key == null) {
//     print('key null');
//     return;
//   } else if (key.currentContext == null) {
//     print('key.currentContext null');
//     return;
//   }

//   try {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       ui.Image image = await boundary.toImage();
//       ref.read(captureScreenStateProvider.notifier).setCaptureScreen(image);
//       print('Captured screen : ${image.width} x ${image.height}');
//     });
//   } catch (e) {
//     print('Failed to capture screen: $e');
//     return;
//   }
// }
