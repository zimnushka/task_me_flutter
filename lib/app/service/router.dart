import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/app/app.dart';

abstract class AppRouter {
  static GlobalKey<NavigatorState>? _navigatorKey = null;

  static Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;
  }

  static Future<void> goTo(AppPage page) async {
    _navigatorKey!.currentContext!.goNamed(
      page.name,
      params: page.params ?? {},
      queryParams: page.queryParams ?? {},
    );
  }

  static Future<void> dialog(WidgetBuilder builder) async {
    await showDialog(context: navigatorKey.currentContext!, builder: builder);
    return;
  }
}

abstract class AppPage {
  String get name;
  Map<String, String>? get params;
  Map<String, String>? get queryParams;
}
