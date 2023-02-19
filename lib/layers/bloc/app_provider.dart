import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';
import 'package:task_me_flutter/layers/repositories/api/project.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/repositories/local/user.dart';
import 'package:task_me_flutter/layers/repositories/session/task_me.dart';
import 'package:task_me_flutter/layers/service/config.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class AppProviderState {
  final User? user;
  final ThemeData theme;
  final Config config;
  final List<Project> projects;

  const AppProviderState({
    required this.theme,
    required this.config,
    required this.projects,
    this.user,
  });

  AppProviderState copyWith({
    User? user,
    ThemeData? theme,
    bool nullUser = false,
    Config? config,
    List<Project>? projects,
  }) {
    return AppProviderState(
      config: config ?? this.config,
      theme: theme ?? this.theme,
      projects: projects ?? this.projects,
      user: nullUser ? null : user ?? this.user,
    );
  }
}

class AppProvider extends Cubit<AppProviderState> {
  AppProvider(Config config)
      : super(
          AppProviderState(
            projects: [],
            theme: lightTheme,
            config: config,
          ),
        ) {
    load();
  }

  final _configService = ConfigService();
  final _userLocalRepository = UserStorage();
  final _userApiRepository = UserApiRepository();
  final _projectApiRepository = ProjectApiRepository();

  Future<void> load() async {
    ApiRepository.url = state.config.apiBaseUrl;
    final token = await _userLocalRepository.get();
    final List<Project> projects = [];
    User? user;
    if (token != null) {
      ApiRepository.session = TaskMeSession(token: token);
      final userData = await _userApiRepository.getUserMe();
      user = userData.data;
      if (user != null) {
        final projectData = (await _projectApiRepository.getAll()).data;
        projects.addAll(projectData ?? []);
      }
    }

    final stateWithTheme = state.copyWith(
      theme: await _generateTheme(color: user != null ? Color(user.color) : defaultPrimaryColor),
      user: user,
      nullUser: user == null,
      projects: projects,
      config: await _configService.getConfig(),
    );
    emit(stateWithTheme);
  }

  Future<void> setTheme({required Color color, bool? isLightTheme}) async {
    if (state.user != null) {
      await _userApiRepository.editUser(state.user!.copyWith(color: color.value));
    }
    emit(state.copyWith(
        theme: await _generateTheme(color: color, isLightTheme: isLightTheme),
        config: state.config.copyWith(isLightTheme: isLightTheme ?? state.config.isLightTheme)));
  }

  Future<ThemeData> _generateTheme({required Color color, bool? isLightTheme}) async {
    if (isLightTheme != null) {
      await _configService.setNewBright(isLightTheme);
    }
    return setPrimaryColor(await _configService.getTheme(), color);
  }

  Future<void> updateUser(User user) async {
    await _userApiRepository.editUser(user);
    await load();
  }

  Future<void> setToken(String token) async {
    await _userLocalRepository.save(token);
    await load();
  }

  Future<void> deleteToken() async {
    await _userLocalRepository.delete();
    await load();
  }
}
