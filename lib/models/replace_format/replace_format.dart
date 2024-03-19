import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'replace_format.freezed.dart';
part 'replace_format.g.dart';

@freezed
class ReplaceFormat with _$ReplaceFormat {
  const factory ReplaceFormat({
    required String templateId,
    required String templateName,
    required String thumbnailImage,
    required ReplaceData replaceData,
    required DateTime createdAt,
  }) = _ReplaceFormat;

  factory ReplaceFormat.fromJson(Map<String, dynamic> json) => _$ReplaceFormatFromJson(json);
}
