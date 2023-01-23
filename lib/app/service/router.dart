import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/app/app.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';

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
    final provider = _navigatorKey!.currentContext!.read<AppProvider>();
    await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return Theme(
            data: provider.state.theme,
            child: builder(context),
          );
        });
    return;
  }
}

abstract class AppPage {
  String get name;
  Map<String, String>? get params;
  Map<String, String>? get queryParams;
}
