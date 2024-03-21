import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replace_edit_page_state.g.dart';

/// 使わないかも... 画面サイズに画像をリサイズするために使用
@Riverpod(keepAlive: true)
class ReplaceEditPageState extends _$ReplaceEditPageState {
  @override
  ReplaceEditPageStateModel build() => const ReplaceEditPageStateModel(width: 0.0, isPicked: false);

  void setPageState(ReplaceEditPageStateModel pageState) => state = pageState;

  void pick() => state = ReplaceEditPageStateModel(width: state.width, isPicked: true);
  void unPick() => state = ReplaceEditPageStateModel(width: state.width, isPicked: false);

  void clear() => state = const ReplaceEditPageStateModel(width: 0.0, isPicked: false);
}

class ReplaceEditPageStateModel {
  final double width;
  final bool isPicked;
  const ReplaceEditPageStateModel({
    required this.width,
    required this.isPicked,
  });
}
