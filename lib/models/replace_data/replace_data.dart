import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:replacer/models/area_model/area_model.dart';
import 'package:replacer/models/move_delta/move_delta.dart';

part 'replace_data.freezed.dart';
part 'replace_data.g.dart';

@freezed
class ReplaceData with _$ReplaceData {
  const factory ReplaceData({
    required String replaceDataId,
    required AreaModel area,
    required MoveDelta moveDelta,
  }) = _ReplaceData;

  factory ReplaceData.fromJson(Map<String, dynamic> json) => _$ReplaceDataFromJson(json);
}
