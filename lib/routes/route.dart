import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:replacer/pages/export_page.dart';
import 'package:replacer/pages/format_preview_page.dart';
import 'package:replacer/pages/home_page.dart';
import 'package:replacer/pages/replace_edit_page.dart';

class PageConfig {
  final String name;
  final Widget page;

  const PageConfig({required this.name, required this.page});
}

List<PageConfig> pages = [
  const PageConfig(name: '/', page: HomePage()),
  const PageConfig(name: '/replace_edit_page', page: ReplaceEditPage()),
  const PageConfig(name: '/export_page', page: ExportPage()),
  const PageConfig(name: '/format_preview_page', page: FormatPreviewPage()),
];

GoRouter myRouter() {
  final routes = pages
      .map((pageConfig) => GoRoute(
            path: pageConfig.name,
            builder: (BuildContext context, GoRouterState state) {
              return pageConfig.page;
            },
          ))
      .toList();

  return GoRouter(
    initialLocation: '/',
    routes: routes,
  );
}
