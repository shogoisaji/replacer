// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateModelImpl _$$TemplateModelImplFromJson(Map<String, dynamic> json) =>
    _$TemplateModelImpl(
      templateId: json['templateId'] as String,
      templateName: json['templateName'] as String,
      thumbnailImage: json['thumbnailImage'] as String,
      replaceData:
          ReplaceData.fromJson(json['replaceData'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TemplateModelImplToJson(_$TemplateModelImpl instance) =>
    <String, dynamic>{
      'templateId': instance.templateId,
      'templateName': instance.templateName,
      'thumbnailImage': instance.thumbnailImage,
      'replaceData': instance.replaceData,
      'createdAt': instance.createdAt.toIso8601String(),
    };
