import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/edit_user_event.dart';
import 'package:task_me_flutter/bloc/events/logout_event.dart';
import 'package:task_me_flutter/domain/states/auth_state.dart';
import 'package:task_me_flutter/repositories/api/api.dart';

import '../main_bloc.dart';
import '../main_state.dart';

editUserHandler(EditUserEvent event, Emitter<MainState> emit, MainBloc mainBloc) async {
  final user = (await mainBloc.state.repo.editUser(event.user)).data;
  if (user == null) {
    mainBloc.add(LogoutEvent());
    return;
  }
  emit(
    mainBloc.state.copyWith(
      authState: AuthState(
        AuthStepAuthenticated(
          token: mainBloc.state.repo.token!,
          user: user,
        ),
      ),
    ),
  );
}
