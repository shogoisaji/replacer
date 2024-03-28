import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:replacer/repositories/shared_preferences/shared_preferences_key.dart';
import 'package:replacer/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:replacer/repositories/sqflite/sqflite_repository.dart';
import 'package:replacer/states/saved_format_list_state.dart';
import 'package:replacer/states/settings_state.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatList = ref.watch(savedFormatListStateProvider);
    final currentMode = ref.watch(settingsStateProvider);

    final menuItems = [
      {'title': 'License', 'func': () => context.go('/license')},
      {
        'title': 'Dark/Light',
        'func': () {
          if (ref.read(settingsStateProvider).themeMode == ThemeMode.dark) {
            ref.read(settingsStateProvider.notifier).changeToLightMode();
            ref.read(sharedPreferencesRepositoryProvider).saveIsDarkMode(SharedPreferencesKey.isDarkMode, false);
            return;
          }
          ref.read(settingsStateProvider.notifier).changeToDarkMode();
          ref.read(sharedPreferencesRepositoryProvider).saveIsDarkMode(SharedPreferencesKey.isDarkMode, true);
        },
      }
    ];

    void fetchFormatList() {
      ref.read(savedFormatListStateProvider.notifier).fetchFormatList();
    }

    void deleteFormat(String formatId) async {
      final sqfliteRepository = SqfliteRepository.instance;
      await sqfliteRepository.deleteRow(formatId);
      fetchFormatList();
    }

    void fetchIsDarkMode() {
      final isDarkMode = ref.read(sharedPreferencesRepositoryProvider).fetchIsDarkMode(SharedPreferencesKey.isDarkMode);
      if (isDarkMode == null) return;
      if (isDarkMode) {
        if (currentMode.themeMode == ThemeMode.dark) return;
        ref.read(settingsStateProvider.notifier).changeToDarkMode();
      } else {
        if (currentMode.themeMode == ThemeMode.light) return;
        ref.read(settingsStateProvider.notifier).changeToLightMode();
      }
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchFormatList();
        fetchIsDarkMode();
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: const Color(MyColors.orange1),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 32,
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<Map<String, dynamic>>(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      icon: const Icon(Icons.menu, color: Color(MyColors.orange2), size: 28),
                      onSelected: (Map<String, dynamic> item) {
                        (item['func'] as Function).call();
                      },
                      itemBuilder: (BuildContext context) {
                        return menuItems.map((item) {
                          return PopupMenuItem<Map<String, dynamic>>(
                            value: item,
                            child: Text(item['title'] as String, style: MyTextStyles.middleOrange),
                          );
                        }).toList();
                      },
                    )),
                Text(
                  'Replacer',
                  style: MyTextStyles.title.copyWith(color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 50),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(MyColors.orange1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
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
                            style: MyTextStyles.subtitle.copyWith(color: Theme.of(context).primaryColor),
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
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('Edit',
                                style: MyTextStyles.subtitle.copyWith(color: const Color(MyColors.orange1))),
                          ),
                        )
                      ],
                    )),
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
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
                      decoration: BoxDecoration(
                        color: const Color(MyColors.orange1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                        border: Border(
                          top: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                          left: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                          right: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        ),
                      ),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6, left: 8),
                              child: Text(
                                'ReplaceFormat',
                                style: MyTextStyles.subtitle.copyWith(color: Theme.of(context).primaryColor),
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
                                    onTap: () {
                                      context.push('/format_preview_page', extra: formatList[index].formatId);
                                    },
                                    child: gridItem(formatList[index], context));
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
      ),
    );
  }

  Widget gridItem(ReplaceFormat format, BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(MyColors.orange1),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Center(
              child: Text(format.formatName,
                  style: MyTextStyles.middleOrange.copyWith(color: Theme.of(context).primaryColor))),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: format.thumbnailImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              format.thumbnailImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('No', style: MyTextStyles.largeBody.copyWith(color: const Color(MyColors.orange1))),
                              Text('Image',
                                  style: MyTextStyles.largeBody.copyWith(color: const Color(MyColors.orange1))),
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
