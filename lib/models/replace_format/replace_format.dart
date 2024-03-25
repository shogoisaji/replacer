import 'dart:convert';
import 'dart:typed_data';

import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'replace_format.freezed.dart';
part 'replace_format.g.dart';

@freezed
class ReplaceFormat with _$ReplaceFormat {
  const factory ReplaceFormat({
    required String formatId,
    required String formatName,
    @Uint8ListConverter() Uint8List? thumbnailImage,
    required List<ReplaceData> replaceDataList,
    required DateTime createdAt,
  }) = _ReplaceFormat;

  factory ReplaceFormat.fromJson(Map<String, dynamic> json) => _$ReplaceFormatFromJson(json);
}

class Uint8ListConverter implements JsonConverter<Uint8List?, String?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(String? json) {
    if (json == null) return null;
    return base64Decode(json);
  }

  @override
  String? toJson(Uint8List? data) {
    if (data == null) return null;
    return base64Encode(data);
  }
}
