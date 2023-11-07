import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/logout_event.dart';
import 'package:task_me_flutter/bloc/events/time_interval_stop_event.dart';
import 'package:task_me_flutter/domain/states/auth_state.dart';
import 'package:task_me_flutter/domain/states/sidebar_state.dart';
import 'package:task_me_flutter/repositories/api/api.dart';

import '../main_bloc.dart';
import '../main_state.dart';

logoutHandler(LogoutEvent event, Emitter<MainState> emit, MainBloc mainBloc) async {
  await mainBloc.storage.clear();
  final repo = ApiRepository(url: mainBloc.state.repo.url, token: null);

  //TODO: test this
  mainBloc.add(TimeIntervalStopEvent());

  emit(
    mainBloc.state.withOutTimeInterval.copyWith(
      repo: repo,
      authState: const AuthState(AuthStepUnauthenticated()),
      sideBarState: const SideBarState(projects: []),
    ),
  );
}
