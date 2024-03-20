import 'package:freezed_annotation/freezed_annotation.dart';

part 'area_model.freezed.dart';
part 'area_model.g.dart';

@freezed
class AreaModel with _$AreaModel {
  const factory AreaModel({
    @Default(0.0) double firstPointX,
    @Default(0.0) double firstPointY,
    @Default(0.0) double secondPointX,
    @Default(0.0) double secondPointY,
  }) = _AreaModel;

  factory AreaModel.fromJson(Map<String, dynamic> json) => _$AreaModelFromJson(json);
}
