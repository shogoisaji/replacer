import 'package:freezed_annotation/freezed_annotation.dart';

part 'area_model.freezed.dart';
part 'area_model.g.dart';

@freezed
class AreaModel with _$AreaModel {
  const factory AreaModel({
    required double firstPointX,
    required double firstPointY,
    required double secondPointX,
    required double secondPointY,
  }) = _AreaModel;

  factory AreaModel.fromJson(Map<String, dynamic> json) => _$AreaModelFromJson(json);
}
