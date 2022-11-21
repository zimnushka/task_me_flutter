import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/repositories/local/theme.dart';
import 'package:task_me_flutter/layers/repositories/local/user.dart';
import 'package:task_me_flutter/layers/repositories/session/task_me.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class AppState {
  final User? user;
  final ThemeData theme;
  final Color color;

  const AppState({
    required this.theme,
    required this.color,
    this.user,
  });

  AppState copyWith({User? user, ThemeData? theme, bool nullUser = false, Color? color}) {
    return AppState(
      theme: theme ?? this.theme,
      color: color ?? this.color,
      user: nullUser ? null : user ?? this.user,
    );
  }
}

class AppCubit extends Cubit<AppState> {
  AppCubit()
      : super(AppState(
          theme: lightTheme,
          color: defaultPrimaryColor,
        )) {
    load();
  }

  final ThemeLocalRepository themeLocalRepository = ThemeLocalRepository();
  final UserLocalRepository userLocalRepository = UserLocalRepository();
  final UserApiRepository userApiRepository = UserApiRepository();

  Future<void> load() async {
    final token = await userLocalRepository.getUser();
    if (token != null) {
      final theme = await themeLocalRepository.getTheme();
      final color = await themeLocalRepository.getColor();
      final userData = await userApiRepository.getUserMe(TaskMeSession(token: token));
      if (userData.isSuccess) {
        emit(AppState(theme: theme, color: color, user: userData.data));
      }
    }
  }

  Future<void> setTheme({required bool isLightTheme, required Color color}) async {
    await themeLocalRepository.setTheme(isLight: isLightTheme);
    await themeLocalRepository.setColor(color.value);
    emit(state.copyWith(
      color: color,
      theme: await themeLocalRepository.getTheme(),
    ));
  }

  Future<void> setToken(String token) async {
    await userLocalRepository.setUser(token);
    await load();
  }

  Future<void> deleteToken() async {
    await userLocalRepository.deleteUser();
    await load();
  }
}
