import 'dart:ui' as ui;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'capture_screen_state.g.dart';

@riverpod
class CaptureScreenState extends _$CaptureScreenState {
  @override
  ui.Image? build() => null;

  void setCaptureScreen(ui.Image image) => state = image;

  void clear() => state = null;
}
