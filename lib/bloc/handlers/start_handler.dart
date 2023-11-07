import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/login_event.dart';
import 'package:task_me_flutter/bloc/events/logout_event.dart';
import 'package:task_me_flutter/bloc/events/start_event.dart';
import 'package:task_me_flutter/repositories/local/local_storage.dart';

import '../main_bloc.dart';
import '../main_state.dart';

startHandler(StartEvent event, Emitter<MainState> emit, MainBloc mainBloc) async {
  final token = await mainBloc.storage.getToken();

  if (token == null) {
    mainBloc.add(LogoutEvent());
    return;
  }
  mainBloc.add(LoginEvent(token: token));
}
