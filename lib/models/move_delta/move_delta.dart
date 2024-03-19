import 'package:freezed_annotation/freezed_annotation.dart';

part 'move_delta.freezed.dart';
part 'move_delta.g.dart';

@freezed
class MoveDelta with _$MoveDelta {
  const factory MoveDelta({
    required double dx,
    required double dy,
  }) = _MoveDelta;

  factory MoveDelta.fromJson(Map<String, dynamic> json) => _$MoveDeltaFromJson(json);
}
