import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
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
}

abstract class AppPage {
  String get name;
  Map<String, String>? get params;
  Map<String, String>? get queryParams;
}
