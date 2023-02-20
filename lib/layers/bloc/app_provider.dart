import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';
import 'package:task_me_flutter/layers/repositories/api/project.dart';
import 'package:task_me_flutter/layers/service/config.dart';
import 'package:task_me_flutter/layers/service/user.dart';
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
      : super(AppProviderState(projects: [], theme: lightTheme, config: config)) {
    load();
  }

  final _configService = ConfigService();
  final _userService = UserService();
  final _projectApiRepository = ProjectApiRepository();

  Future<void> load() async {
    ApiRepository.url = state.config.apiBaseUrl;
    final List<Project> projects = [];
    final user = await _userService.getUserFromToken();

    if (user != null) {
      final projectData = (await _projectApiRepository.getAll()).data;
      projects.addAll(projectData ?? []);
    }

    final config = (await _configService.getConfig()) ?? state.config;

    final stateWithTheme = state.copyWith(
      theme: setPrimaryColor(config.theme, user != null ? Color(user.color) : defaultPrimaryColor),
      user: user,
      nullUser: user == null,
      projects: projects,
      config: config,
    );
    emit(stateWithTheme);
  }

  Future<void> setTheme({Color? color, bool? isLightTheme}) async {
    if (isLightTheme != null) {
      await _configService.setNewBright(isLightTheme);
    }
    final config = (await _configService.getConfig()) ?? state.config;

    if (color != null) {
      final user = await _userService.editUser(state.user!.copyWith(color: color.value));
      emit(
        state.copyWith(
          user: user,
          theme: setPrimaryColor(config.theme, Color(user?.color ?? state.user!.color)),
          config: config,
        ),
      );
    } else {
      emit(
        state.copyWith(
          theme: setPrimaryColor(config.theme, Color(state.user!.color)),
          config: config,
        ),
      );
    }
  }

  Future<void> updateUser(User user) async {
    await _userService.editUser(user);
    await load();
  }

  Future<void> setToken(String token) async {
    await _userService.saveToken(token);
    await load();
  }

  Future<void> deleteToken() async {
    await _userService.logOut();
    await load();
  }

  Future<void> changeTaskView(TaskViewState taskViewState) async {
    final config = await _configService.setNewTaskView(taskViewState);
    emit(state.copyWith(config: config));
  }
}
