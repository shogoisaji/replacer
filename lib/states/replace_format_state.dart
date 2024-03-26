import 'dart:typed_data';

import 'package:replacer/models/area_model/area_model.dart';
import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replace_format_state.g.dart';

@Riverpod(keepAlive: true)
class ReplaceFormatState extends _$ReplaceFormatState {
  @override
  ReplaceFormat build() => ReplaceFormat(
        formatId: '000000',
        formatName: '${DateTime.now().month}/${DateTime.now().day}',
        thumbnailImage: null,
        replaceDataList: [],
        createdAt: DateTime.now(),
        canvasArea: null,
      );

  void resetFormat() => state = ReplaceFormat(
        formatId: '000000',
        formatName: '${DateTime.now().month}/${DateTime.now().day}',
        thumbnailImage: null,
        replaceDataList: [],
        createdAt: DateTime.now(),
        canvasArea: null,
      );

  void addReplaceData(ReplaceData newReplaceData) {
    state = ReplaceFormat(
      formatId: state.formatId,
      formatName: state.formatName,
      replaceDataList: [...state.replaceDataList, newReplaceData],
      createdAt: state.createdAt,
      canvasArea: state.canvasArea,
    );
  }

  void removeReplaceData(int index) {
    state = ReplaceFormat(
      formatId: state.formatId,
      formatName: state.formatName,
      thumbnailImage: state.thumbnailImage,
      replaceDataList: List.from(state.replaceDataList)..removeAt(index),
      createdAt: state.createdAt,
      canvasArea: state.canvasArea,
    );
  }

  void setCanvasArea(AreaModel canvasArea) {
    state = ReplaceFormat(
      formatId: state.formatId,
      formatName: state.formatName,
      thumbnailImage: state.thumbnailImage,
      replaceDataList: state.replaceDataList,
      createdAt: state.createdAt,
      canvasArea: canvasArea,
    );
  }

  void setThumbnailImage(Uint8List thumbnailImage) {
    state = ReplaceFormat(
      formatId: state.formatId,
      formatName: state.formatName,
      thumbnailImage: thumbnailImage,
      replaceDataList: state.replaceDataList,
      createdAt: state.createdAt,
      canvasArea: state.canvasArea,
    );
  }
}
