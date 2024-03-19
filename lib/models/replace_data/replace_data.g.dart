// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replace_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReplaceDataImpl _$$ReplaceDataImplFromJson(Map<String, dynamic> json) =>
    _$ReplaceDataImpl(
      replaceDataId: json['replaceDataId'] as String,
      area: AreaModel.fromJson(json['area'] as Map<String, dynamic>),
      moveDelta: MoveDelta.fromJson(json['moveDelta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReplaceDataImplToJson(_$ReplaceDataImpl instance) =>
    <String, dynamic>{
      'replaceDataId': instance.replaceDataId,
      'area': instance.area,
      'moveDelta': instance.moveDelta,
    };
