import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replace_edit_page_state.g.dart';

/// 使わないかも... 画面サイズに画像をリサイズするために使用
@Riverpod(keepAlive: true)
class ReplaceEditPageState extends _$ReplaceEditPageState {
  @override
  ReplaceEditPageStateModel build() => const ReplaceEditPageStateModel(width: 0.0);

  void setPageState(ReplaceEditPageStateModel pageState) => state = pageState;
}

class ReplaceEditPageStateModel {
  final double width;
  const ReplaceEditPageStateModel({
    required this.width,
  });
}
