import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/repositories/local/theme.dart';
import 'package:task_me_flutter/layers/repositories/local/user.dart';
import 'package:task_me_flutter/layers/repositories/session/task_me.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class AppProviderState {
  final User? user;
  final ThemeData theme;
  final Color color;

  const AppProviderState({
    required this.theme,
    required this.color,
    this.user,
  });

  AppProviderState copyWith({User? user, ThemeData? theme, bool nullUser = false, Color? color}) {
    return AppProviderState(
      theme: theme ?? this.theme,
      color: color ?? this.color,
      user: nullUser ? null : user ?? this.user,
    );
  }
}

class AppProvider extends Cubit<AppProviderState> {
  AppProvider()
      : super(AppProviderState(
          theme: lightTheme,
          color: defaultPrimaryColor,
        )) {
    load();
  }

  final ThemeLocalRepository _themeLocalRepository = ThemeLocalRepository();
  final UserLocalRepository _userLocalRepository = UserLocalRepository();
  final UserApiRepository _userApiRepository = UserApiRepository();

  Future<void> load() async {
    final theme = await _themeLocalRepository.getTheme();
    final color = await _themeLocalRepository.getColor();
    AppProviderState stateWithTheme =
        AppProviderState(theme: setPrimaryColor(theme, color), color: color, user: null);
    final token = await _userLocalRepository.getUser();
    if (token != null) {
      ApiRepository.session = TaskMeSession(token: token);
      final userData = await _userApiRepository.getUserMe();
      if (userData.isSuccess) {
        stateWithTheme = stateWithTheme.copyWith(user: userData.data);
      }
    }
    emit(stateWithTheme);
  }

  Future<void> setTheme({required bool isLightTheme, required Color color}) async {
    await _themeLocalRepository.setTheme(isLight: isLightTheme);
    await _themeLocalRepository.setColor(color.value);
    emit(state.copyWith(
      color: color,
      theme: setPrimaryColor(await _themeLocalRepository.getTheme(), color),
    ));
  }

  Future<void> setToken(String token) async {
    await _userLocalRepository.setUser(token);
    await load();
  }

  Future<void> deleteToken() async {
    await _userLocalRepository.deleteUser();
    await load();
  }
}
