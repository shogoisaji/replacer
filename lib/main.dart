import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:replacer/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:replacer/routes/route.dart';
import 'package:replacer/states/settings_state.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  late final SharedPreferences sharedPreferences;
  WidgetsFlutterBinding.ensureInitialized();
  // 画面の向きを固定.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  sharedPreferences = await SharedPreferences.getInstance();
  const app = MyApp();
  final scope = ProviderScope(overrides: [
    sharedPreferencesRepositoryProvider.overrideWithValue(SharedPreferencesRepository(sharedPreferences)),
  ], child: app);
  runApp(scope);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsStateProvider).themeMode;
    return MaterialApp.router(
      theme: ThemeData(
        primaryColor: const Color(MyColors.light),
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(MyColors.dark),
      ),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: myRouter(),
    );
  }
}
