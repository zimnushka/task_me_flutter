import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/login_event.dart';
import 'package:task_me_flutter/bloc/events/logout_event.dart';
import 'package:task_me_flutter/domain/states/auth_state.dart';
import 'package:task_me_flutter/domain/states/sidebar_state.dart';
import 'package:task_me_flutter/repositories/api/api.dart';
import 'package:task_me_flutter/repositories/local/local_storage.dart';

import '../main_bloc.dart';
import '../main_state.dart';

loginHandler(LoginEvent event, Emitter<MainState> emit, MainBloc mainBloc) async {
  //TODO: get time interval
  final token = event.token;
  final config = await mainBloc.storage.getConfig();
  final repo = ApiRepository(
    url: config?.apiBaseUrl ?? mainBloc.state.config.apiBaseUrl,
    token: token,
  );

  final user = (await repo.getUserMe()).data;

  if (user == null) {
    mainBloc.add(LogoutEvent());
    return;
  }

  mainBloc.storage.saveToken(token);
  final projects = (await repo.getProjectsAll()).data ?? [];
  final intervals = (await repo.getMyIntervals()).data ?? [];

  emit(
    mainBloc.state.copyWith(
      authState: AuthState(AuthStepAuthenticated(token: token, user: user)),
      repo: repo,
      config: config,
      currentTimeInterval: intervals.isEmpty ? null : intervals.first,
      sideBarState: SideBarState(projects: projects),
    ),
  );
}
