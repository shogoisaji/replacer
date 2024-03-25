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
      );

  void replaceDataReset() => state = ReplaceFormat(
        formatId: state.formatId,
        formatName: state.formatName,
        thumbnailImage: state.thumbnailImage,
        replaceDataList: [],
        createdAt: DateTime.now(),
      );

  void addReplaceData(ReplaceData newReplaceData) {
    state = ReplaceFormat(
      formatId: state.formatId,
      formatName: state.formatName,
      replaceDataList: [...state.replaceDataList, newReplaceData],
      createdAt: state.createdAt,
    );
  }

  void removeReplaceData(int index) {
    state = ReplaceFormat(
      formatId: state.formatId,
      formatName: state.formatName,
      thumbnailImage: state.thumbnailImage,
      replaceDataList: List.from(state.replaceDataList)..removeAt(index),
      createdAt: state.createdAt,
    );
  }
}
