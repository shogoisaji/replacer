import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:replacer/repositories/sqflite/sqflite_repository.dart';
import 'package:replacer/states/saved_format_list_state.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatList = ref.watch(savedFormatListStateProvider);

    void fetchFormatList() {
      ref
          .read(savedFormatListStateProvider.notifier)
          .fetchFormatList()
          .then((value) => print('fetchFormatList length: $value'));
    }

    void deleteFormat(String formatId) async {
      final sqfliteRepository = SqfliteRepository.instance;
      final result = await sqfliteRepository.deleteRow(formatId);
      print('delete result: $result');
      fetchFormatList();
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchFormatList();
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: const Color(MyColors.orange1),
      body: SafeArea(
        bottom: false,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 32),
              Text(
                'Replacer',
                style: MyTextStyles.title,
              ),
              const SizedBox(height: 50),
              Container(
                  // width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(MyColors.orange1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(MyColors.light),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'NewReplace',
                          style: MyTextStyles.subtitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/replace_edit_page');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(MyColors.light),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Edit', style: MyTextStyles.subtitleOrange),
                        ),
                      )
                    ],
                  )),
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: const Color(MyColors.light),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(MyColors.light),
                    width: 2,
                  ),
                ),
                child: Lottie.asset(
                  'assets/lottie/demo.json',
                  repeat: true,
                ),
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.only(top: 0.8, left: 8, right: 8),
                    decoration: const BoxDecoration(
                      color: Color(MyColors.orange1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                      border: Border(
                        top: BorderSide(color: Color(MyColors.light), width: 2),
                        left: BorderSide(color: Color(MyColors.light), width: 2),
                        right: BorderSide(color: Color(MyColors.light), width: 2),
                      ),
                    ),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6, left: 8),
                            child: Text(
                              'ReplaceFormat',
                              style: MyTextStyles.subtitle,
                            ),
                          ),
                        ),
                        SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                  onLongPress: () async {
                                    deleteFormat(formatList[index].formatId);
                                  },
                                  child: _gridItem(formatList[index]));
                            },
                            childCount: formatList.length,
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 100),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridItem(ReplaceFormat format) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(MyColors.orange1),
        border: Border.all(
          color: const Color(MyColors.light),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Center(child: Text(format.formatName, style: MyTextStyles.largeBodyLight)),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(MyColors.light),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: format.thumbnailImage != null
                        ? Image.memory(
                            format.thumbnailImage!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('No', style: MyTextStyles.largeBodyOrange),
                              Text('Image', style: MyTextStyles.largeBodyOrange),
                            ],
                          )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
