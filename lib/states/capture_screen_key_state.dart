import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'capture_screen_key_state.g.dart';

@Riverpod(keepAlive: true)
class CaptureScreenKeyState extends _$CaptureScreenKeyState {
  @override
  GlobalKey? build() => null;

  void setKey(GlobalKey key) => state = key;

  void clear() => state = null;
}
