import 'dart:ui' as ui;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'convert_image_cache_state.g.dart';

@riverpod
class ConvertImageCacheState extends _$ConvertImageCacheState {
  @override
  List<ui.Image> build() => [];

  void addCacheImage(ui.Image image) => state = [...state, image];

  void clear() => state = [];
}
