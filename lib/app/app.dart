// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/home.dart';
import 'package:task_me_flutter/layers/ui/pages/landing.dart';
import 'package:task_me_flutter/layers/ui/pages/project/project.dart';
import 'package:task_me_flutter/layers/ui/pages/task_detail/task_detail.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TaskMyApp extends StatelessWidget {
  TaskMyApp({required this.config, super.key});
  final Config config;
  late final AppProvider provider;

  late final GoRouter _route = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        pageBuilder: (context, state) => builder(state, const HomePage()),
      ),
      GoRoute(
        name: 'project',
        path: '/project/:projectId',
        pageBuilder: (context, state) => builder(
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
            state,
            TaskPage(
              taskId: int.tryParse(state.params['taskId'] ?? ''),
              projectId: int.parse(state.queryParams['projectId']!),
            )),
      ),
    ],
  );

  CustomTransitionPage builder(GoRouterState state, Widget child) {
    return buildTransition(
      state: state,
      child: Landing(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppRouter.init(navigatorKey);
    String url = config.apiBaseUrl;
    // try {
    //   if (config.setUrlFromHTML) {
    //     final port = window.location.port;
    //     final origin = window.location.origin;
    //     url = origin.replaceAll(port, '8080');
    //   }
    // } catch (e) {
    url = config.apiBaseUrl;
    // }

    provider = AppProvider(config.copyWith(apiBaseUrl: url));
    return MaterialApp.router(
      routeInformationProvider: _route.routeInformationProvider,
      routeInformationParser: _route.routeInformationParser,
      routerDelegate: _route.routerDelegate,
      debugShowCheckedModeBanner: config.debug,
      title: 'Task Me',
      theme: setPrimaryColor(lightTheme, defaultPrimaryColor),
      builder: (context, child) {
        return Overlay(initialEntries: [
          OverlayEntry(
            builder: (context) {
              return BlocProvider.value(value: provider, child: child);
            },
          )
        ]);
      },
    );
  }
}

CustomTransitionPage buildTransition<T>({
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
