import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replace_edit_state.g.dart';

enum ReplaceEditMode {
  areaSelect,
  areaDetailSelect,
  moveSelect,
  canvasSelect,
}

// extension ReplaceEditModeExtension on ReplaceEditMode {
//   String get modeName {
//     switch (this) {
//       case ReplaceEditMode.areaSelect:
//         return 'Select Area';
//       case ReplaceEditMode.moveSelect:
//         return 'Move Area';
//       case ReplaceEditMode.canvasSelect:
//         return 'Canvas Select';
//       default:
//         return 'none';
//     }
//   }
// }

@riverpod
class ReplaceEditState extends _$ReplaceEditState {
  @override
  ReplaceEditMode build() => ReplaceEditMode.areaSelect;

  void changeMode(ReplaceEditMode mode) {
    state = mode;
  }
}
