import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replace_format_state.g.dart';

@riverpod
class ReplaceFormatState extends _$ReplaceFormatState {
  @override
  ReplaceFormat? build() => null;

  void formatInit() => state = ReplaceFormat(
        templateId: '000001',
        templateName: 'templateName',
        thumbnailImage: 'thumbnailImage',
        replaceDataList: [],
        createdAt: DateTime.now(),
      );

  void addReplaceData(ReplaceData newReplaceData) {
    if (state == null) {
      print('state is null');
      return;
    }
    state = ReplaceFormat(
      templateId: state!.templateId,
      templateName: state!.templateName,
      thumbnailImage: state!.thumbnailImage,
      replaceDataList: [...state!.replaceDataList, newReplaceData],
      createdAt: state!.createdAt,
    );
  }

  void clear() => state = null;
}
