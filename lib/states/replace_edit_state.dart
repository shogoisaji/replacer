import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replace_edit_state.g.dart';

enum ReplaceEditMode {
  areaSelect,
  moveSelect,
}

@riverpod
class ReplaceEditState extends _$ReplaceEditState {
  @override
  ReplaceEditMode build() => ReplaceEditMode.areaSelect;

  void changeMode(ReplaceEditMode mode) {
    print('mode: $mode');
    state = mode;
  }
}
