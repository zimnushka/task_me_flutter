import 'dart:html';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/home.dart';
import 'package:task_me_flutter/layers/ui/pages/landing.dart';
import 'package:task_me_flutter/layers/ui/pages/project/project.dart';
import 'package:task_me_flutter/layers/ui/pages/task_page.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class TaskMyApp extends StatelessWidget {
  TaskMyApp({required this.config, super.key});
  final Config config;
  late final AppProvider provider = AppProvider(config);

  late final GoRouter _route = GoRouter(
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        pageBuilder: (context, state) => builder(context, state, const HomePage()),
      ),
      GoRoute(
        name: 'project',
        path: '/project/:projectId',
        pageBuilder: (context, state) => builder(
            context,
            state,
            ProjectPage(
              int.parse(state.params['projectId']!),
              key: ValueKey(state.params['projectId']!),
            )),
      ),
      GoRoute(
        name: 'task',
        path: '/task/:taskId',
        pageBuilder: (context, state) => builder(
            context,
            state,
            TaskPage(
              taskId: int.tryParse(state.params['taskId'] ?? ''),
              projectId: int.parse(state.queryParams['projectId']!),
            )),
      ),
    ],
  );

  CustomTransitionPage builder(BuildContext context, GoRouterState state, Widget child) {
    return buildPageWithDefaultTransition(
      context: context,
      state: state,
      child: AppProviderWidget(child, provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    var url = window.location.href;
    return MaterialApp.router(
      routeInformationProvider: _route.routeInformationProvider,
      routeInformationParser: _route.routeInformationParser,
      routerDelegate: _route.routerDelegate,
      debugShowCheckedModeBanner: config.debug,
      title: 'Task Me',
      theme: setPrimaryColor(lightTheme, defaultPrimaryColor),
      builder: (context, child) {
        return child ?? const SizedBox();
      },
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
