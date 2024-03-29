import 'package:replacer/states/capture_screen_state.dart';
import 'package:replacer/states/check_replace_data_state.dart';
import 'package:replacer/states/image_pick_state.dart';
import 'package:replacer/states/replace_edit_page_state.dart';
import 'package:replacer/states/replace_edit_state.dart';
import 'package:replacer/states/replace_format_state.dart';
import 'package:replacer/states/replace_thumbnail_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'refresh_cache_usecase.g.dart';

@riverpod
class RefreshCacheUseCase extends _$RefreshCacheUseCase {
  @override
  bool build() => false;

  void execute() {
    ref.read(pickImageStateProvider.notifier).clear();
    ref.read(checkReplaceDataStateProvider.notifier).clear();
    ref.read(replaceThumbnailStateProvider.notifier).clear();
    ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
    ref.read(replaceEditPageStateProvider.notifier).clear();
    ref.read(captureScreenStateProvider.notifier).clear();
    ref.read(replaceFormatStateProvider.notifier).resetFormat();
  }
}
