import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_replace_data_state.g.dart';

@riverpod
class CheckReplaceDataState extends _$CheckReplaceDataState {
  @override
  ReplaceData? build() => null;

  void setData(ReplaceData area) => state = area;

  void clear() => state = null;
}
