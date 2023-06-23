import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/home/home.dart';
import 'package:task_me_flutter/layers/ui/pages/landing.dart';
import 'package:task_me_flutter/layers/ui/pages/project/project.dart';
import 'package:task_me_flutter/layers/ui/pages/settings/settings.dart';
import 'package:task_me_flutter/layers/ui/pages/task_detail/task_detail.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TaskMyApp extends StatelessWidget {
  TaskMyApp({required this.config, super.key});
  final Config config;
  late final AppProvider provider = AppProvider(config);

  late final GoRouter _route = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        pageBuilder: (context, state) => builder(state, const HomePage()),
      ),
      GoRoute(
        name: 'settings',
        path: '/settings',
        pageBuilder: (context, state) => builder(state, const SettingsPage()),
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
    return MaterialApp.router(
      routeInformationProvider: _route.routeInformationProvider,
      routeInformationParser: _route.routeInformationParser,
      routerDelegate: _route.routerDelegate,
      debugShowCheckedModeBanner: config.debug,
      title: 'Task Me',
      builder: (context, child) {
        return BlocProvider.value(
            value: provider,
            child: Overlay(initialEntries: [
              OverlayEntry(
                builder: (context) {
                  return child ?? const SizedBox();
                },
              )
            ]));
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
