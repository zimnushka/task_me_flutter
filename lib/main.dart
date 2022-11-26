import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/layers/ui/pages/home.dart';
import 'package:task_me_flutter/layers/ui/pages/landing.dart';

void main() => runApp(TaskMyApp());

class TaskMyApp extends StatelessWidget {
  TaskMyApp({super.key});

  final GoRouter _route = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _route,
      title: 'Task Me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                return AppProviderWidget(child ?? const SizedBox());
              },
            ),
          ],
        );
      },
    );
  }
}
