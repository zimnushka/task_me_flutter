import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/logout_event.dart';
import 'package:task_me_flutter/bloc/events/set_config_event.dart';
import 'package:task_me_flutter/domain/states/auth_state.dart';
import 'package:task_me_flutter/domain/states/sidebar_state.dart';
import 'package:task_me_flutter/repositories/api/api.dart';

import '../main_bloc.dart';
import '../main_state.dart';

setConfigHandler(SetConfigEvent event, Emitter<MainState> emit, MainBloc mainBloc) async {
  final repo = ApiRepository(
    url: event.config.apiBaseUrl,
    token: mainBloc.state.repo.token,
  );

  final user = (await repo.getUserMe()).data;

  if (user == null) {
    mainBloc.add(LogoutEvent());
    return;
  }

  final projects = (await repo.getProjectsAll()).data ?? [];

  emit(
    mainBloc.state.copyWith(
      authState: AuthState(AuthStepAuthenticated(token: mainBloc.state.repo.token!, user: user)),
      repo: repo,
      config: event.config,
      sideBarState: SideBarState(projects: projects),
    ),
  );
}
