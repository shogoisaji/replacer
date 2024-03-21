// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AreaModelImpl _$$AreaModelImplFromJson(Map<String, dynamic> json) =>
    _$AreaModelImpl(
      firstPointX: (json['firstPointX'] as num?)?.toDouble() ?? 0.0,
      firstPointY: (json['firstPointY'] as num?)?.toDouble() ?? 0.0,
      secondPointX: (json['secondPointX'] as num?)?.toDouble() ?? 0.0,
      secondPointY: (json['secondPointY'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$AreaModelImplToJson(_$AreaModelImpl instance) =>
    <String, dynamic>{
      'firstPointX': instance.firstPointX,
      'firstPointY': instance.firstPointY,
      'secondPointX': instance.secondPointX,
      'secondPointY': instance.secondPointY,
    };
