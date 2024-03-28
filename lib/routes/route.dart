import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:replacer/pages/custom_license_page.dart';
import 'package:replacer/pages/export_page.dart';
import 'package:replacer/pages/format_preview_page.dart';
import 'package:replacer/pages/home_page.dart';
import 'package:replacer/pages/replace_edit_page.dart';
import 'package:replacer/widgets/loading_widget.dart';

class PageConfig {
  final String name;
  final Widget page;

  const PageConfig({required this.name, required this.page});
}

List<PageConfig> pages = [
  const PageConfig(name: '/', page: HomePage()),
  const PageConfig(name: '/replace_edit_page', page: ReplaceEditPage()),
  const PageConfig(name: '/export_page', page: ExportPage(isUseFormat: false)),
  const PageConfig(name: '/format_preview_page', page: FormatPreviewPage()),
  const PageConfig(name: '/license', page: CustomLicensePage()),
];

GoRouter myRouter() {
  final routes = [
    ShellRoute(
        builder: (_, __, child) => Scaffold(
                body: Stack(
              children: [
                child,
                const LoadingWidget(),
              ],
            )),
        routes: pages
            .map((pageConfig) => GoRoute(
                  path: pageConfig.name,
                  builder: (
                    BuildContext context,
                    GoRouterState state,
                  ) {
                    if (pageConfig.name == '/format_preview_page') {
                      return FormatPreviewPage(formatId: state.extra as String);
                    }
                    if (pageConfig.name == '/export_page') {
                      return ExportPage(isUseFormat: state.extra as bool);
                    }
                    return pageConfig.page;
                  },
                ))
            .toList())
  ];

  return GoRouter(
    initialLocation: '/',
    routes: routes,
  );
}
