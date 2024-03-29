import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/bloc/events/start_event.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/bloc/main_state.dart';
import 'package:task_me_flutter/domain/configs.dart';

import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/domain/states/auth_state.dart';
import 'package:task_me_flutter/domain/states/overlay_state.dart';
import 'package:task_me_flutter/domain/states/sidebar_state.dart';
import 'package:task_me_flutter/repositories/api/api.dart';
import 'package:task_me_flutter/repositories/local/local_storage.dart';
import 'package:task_me_flutter/router/app_router.dart';
import 'package:task_me_flutter/service/snackbar.dart';
import 'package:task_me_flutter/ui/pages/home/home.dart';
import 'package:task_me_flutter/ui/pages/landing.dart';
import 'package:task_me_flutter/ui/pages/project/project.dart';
import 'package:task_me_flutter/ui/pages/settings/settings.dart';
import 'package:task_me_flutter/ui/pages/task_detail/task_detail.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TaskMyApp(config: debugConfig));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TaskMyApp extends StatelessWidget {
  TaskMyApp({required this.config, super.key});
  final Config config;

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
              onTaskUpdate: state.extra is VoidCallback ? state.extra as VoidCallback : null,
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
    return MaterialApp.router(
      routeInformationProvider: _route.routeInformationProvider,
      routeInformationParser: _route.routeInformationParser,
      routerDelegate: _route.routerDelegate,
      debugShowCheckedModeBanner: config.debug,
      title: 'Task Me',
      builder: (context, child) {
        return BlocProvider(
          create: (context) => MainBloc(
            MainState(
              authState: AuthState.empty(),
              overlayState: const OverlayMessageState(message: '', type: OverlayType.none),
              repo: ApiRepository(url: config.apiBaseUrl),
              config: config,
              sideBarState: const SideBarState(projects: []),
            ),
            router: AppRouter(_route),
            storage: LocalStorage(),
          )..add(StartEvent()),
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) {
                  return child ?? const SizedBox();
                },
              )
            ],
          ),
        );
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
