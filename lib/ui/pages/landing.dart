import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/ui/pages/auth/auth.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';

class Landing extends StatelessWidget {
  const Landing({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final user = context.select((MainBloc vm) => vm.state.authState.user);
    return user == null ? const _LandingAuth() : _LandingUser(child);
  }
}

class _LandingAuth extends StatelessWidget {
  const _LandingAuth();

  @override
  Widget build(BuildContext context) {
    final theme = setPrimaryColor(lightTheme, defaultPrimaryColor);
    return Theme(
      data: theme,
      child: ColoredBox(
        color: theme.colorScheme.background,
        child: const AuthPage(),
      ),
    );
  }
}

class _LandingUser extends StatelessWidget {
  const _LandingUser(this.child);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final user = context.select((MainBloc vm) => vm.state.authState.user);
    final isLightTheme = context.select((MainBloc vm) => vm.state.config.isLightTheme);
    if (user == null) {
      return const _LandingAuth();
    }
    ThemeData theme = isLightTheme ? lightTheme : darkTheme;
    theme = setPrimaryColor(theme, user.color);

    return Theme(
      data: theme,
      child: ColoredBox(
        color: theme.colorScheme.background,
        child: Scaffold(body: child),
      ),
    );
  }
}
