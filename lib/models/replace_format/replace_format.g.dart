// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replace_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReplaceFormatImpl _$$ReplaceFormatImplFromJson(Map<String, dynamic> json) =>
    _$ReplaceFormatImpl(
      formatId: json['formatId'] as String,
      formatName: json['formatName'] as String,
      thumbnailImage: const Uint8ListConverter()
          .fromJson(json['thumbnailImage'] as String?),
      replaceDataList: (json['replaceDataList'] as List<dynamic>)
          .map((e) => ReplaceData.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ReplaceFormatImplToJson(_$ReplaceFormatImpl instance) =>
    <String, dynamic>{
      'formatId': instance.formatId,
      'formatName': instance.formatName,
      'thumbnailImage':
          const Uint8ListConverter().toJson(instance.thumbnailImage),
      'replaceDataList': instance.replaceDataList,
      'createdAt': instance.createdAt.toIso8601String(),
    };
