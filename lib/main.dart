import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/ui/pages/auth.dart';
import 'package:task_me_flutter/layers/ui/pages/home.dart';
import 'package:task_me_flutter/layers/ui/pages/landing.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

void main() => runApp(TaskMyApp());

class TaskMyApp extends StatelessWidget {
  TaskMyApp({super.key});
  final AppProvider provider = AppProvider();

  late final GoRouter _route = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        // builder: (context, state) => builder(state, const HomePage()),
        pageBuilder: (context, state) => builder(context, state, const HomePage()),
      ),
    ],
  );

  CustomTransitionPage builder(BuildContext context, GoRouterState state, Widget child) =>
      buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: AppProviderWidget(child, provider),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _route.routeInformationProvider,
      routeInformationParser: _route.routeInformationParser,
      routerDelegate: _route.routerDelegate,
      title: 'Task Me',
      theme: setPrimaryColor(lightTheme, defaultPrimaryColor),
    );
  }
}

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SizeTransition(sizeFactor: animation, child: child),
  );
}
