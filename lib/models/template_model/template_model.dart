import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_model.freezed.dart';
part 'template_model.g.dart';

@freezed
class TemplateModel with _$TemplateModel {
  const factory TemplateModel({
    required String templateId,
    required String templateName,
    required String thumbnailImage,
    required ReplaceData replaceData,
    required DateTime createdAt,
  }) = _TemplateModel;

  factory TemplateModel.fromJson(Map<String, dynamic> json) => _$TemplateModelFromJson(json);
}
