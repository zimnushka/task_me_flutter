import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/logout_event.dart';
import 'package:task_me_flutter/bloc/events/update_project_list_event.dart';
import 'package:task_me_flutter/domain/states/sidebar_state.dart';
import 'package:task_me_flutter/repositories/api/api.dart';

import '../main_bloc.dart';
import '../main_state.dart';

uopdateProjectListHandler(
  UpdateProjectListEvent event,
  Emitter<MainState> emit,
  MainBloc mainBloc,
) async {
  final projects = (await mainBloc.state.repo.getProjectsAll()).data;
  if (projects == null) {
    mainBloc.add(LogoutEvent());
    return;
  }
  emit(mainBloc.state.copyWith(sideBarState: SideBarState(projects: projects)));
}
