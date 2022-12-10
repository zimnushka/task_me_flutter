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
  final Config config;

  const AppProviderState({
    required this.theme,
    required this.config,
    this.user,
  });

  AppProviderState copyWith({User? user, ThemeData? theme, bool nullUser = false, Config? config}) {
    return AppProviderState(
      config: config ?? this.config,
      theme: theme ?? this.theme,
      user: nullUser ? null : user ?? this.user,
    );
  }
}

class AppProvider extends Cubit<AppProviderState> {
  AppProvider(Config config) : super(AppProviderState(theme: lightTheme, config: config)) {
    load();
  }

  final ThemeLocalRepository _themeLocalRepository = ThemeLocalRepository();
  final UserLocalRepository _userLocalRepository = UserLocalRepository();
  final UserApiRepository _userApiRepository = UserApiRepository();

  Future<void> load() async {
    ApiRepository.url = state.config.apiBaseUrl;
    final token = await _userLocalRepository.getUser();
    User? user;
    if (token != null) {
      ApiRepository.session = TaskMeSession(token: token);
      final userData = await _userApiRepository.getUserMe();
      user = userData.data;
    }
    final stateWithTheme = state.copyWith(
      theme: await _setTheme(color: user != null ? Color(user.color) : defaultPrimaryColor),
      user: user,
    );
    emit(stateWithTheme);
  }

  Future<void> setTheme({required Color color, bool? isLightTheme}) async {
    if (state.user != null) {
      await _userApiRepository.editUser(state.user!.copyWith(color: color.value));
    }
    emit(state.copyWith(theme: await _setTheme(color: color, isLightTheme: isLightTheme)));
  }

  Future<ThemeData> _setTheme({required Color color, bool? isLightTheme}) async {
    if (isLightTheme != null) {
      await _themeLocalRepository.setTheme(isLight: isLightTheme);
    }
    return setPrimaryColor(await _themeLocalRepository.getTheme(), color);
  }

  Future<void> updateUser(User user) async {
    await _userApiRepository.editUser(user);
    await load();
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
