import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replace_format_state.g.dart';

@riverpod
class ReplaceFormatState extends _$ReplaceFormatState {
  @override
  ReplaceFormat build() => ReplaceFormat(
        templateId: '-',
        templateName: '-',
        thumbnailImage: '-',
        replaceDataList: [],
        createdAt: DateTime.now(),
      );

  void replaceDataReset() => state = ReplaceFormat(
        templateId: state.templateId,
        templateName: state.templateName,
        thumbnailImage: state.thumbnailImage,
        replaceDataList: [],
        createdAt: DateTime.now(),
      );

  void addReplaceData(ReplaceData newReplaceData) {
    state = ReplaceFormat(
      templateId: state.templateId,
      templateName: state.templateName,
      thumbnailImage: state.thumbnailImage,
      replaceDataList: [...state.replaceDataList, newReplaceData],
      createdAt: state.createdAt,
    );
  }

  void removeReplaceData(int index) {
    state = ReplaceFormat(
      templateId: state.templateId,
      templateName: state.templateName,
      thumbnailImage: state.thumbnailImage,
      replaceDataList: List.from(state.replaceDataList)..removeAt(index),
      createdAt: state.createdAt,
    );
  }
}
