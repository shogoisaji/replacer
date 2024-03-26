import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replace_thumbnail_state.g.dart';

@Riverpod(keepAlive: true)
class ReplaceThumbnailState extends _$ReplaceThumbnailState {
  @override
  List<Uint8List> build() => [];

  void addThumbnail(Uint8List thumbnail) {
    state = [...state, thumbnail];
  }

  void removeThumbnail(int index) {
    state = List.from(state)..removeAt(index);
  }

  void clear() {
    state = [];
  }
}
