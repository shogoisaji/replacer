import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:replacer/repositories/sqflite/sqflite_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_format_list_state.g.dart';

@Riverpod(keepAlive: true)
class SavedFormatListState extends _$SavedFormatListState {
  @override
  List<ReplaceFormat> build() => [];

  void setFormatList(List<ReplaceFormat> list) => state = list;

  Future<int> fetchFormatList() async {
    final sqfliteRepository = SqfliteRepository.instance;
    final list = await sqfliteRepository.fetchSavedAllFormat();
    state = list;
    return list.length;
  }

  void clear() {
    state = [];
  }
}
