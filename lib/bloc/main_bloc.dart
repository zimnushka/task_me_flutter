import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/edit_user_event.dart';
import 'package:task_me_flutter/bloc/events/login_event.dart';
import 'package:task_me_flutter/bloc/events/logout_event.dart';
import 'package:task_me_flutter/bloc/events/overlay_event.dart';
import 'package:task_me_flutter/bloc/events/set_config_event.dart';
import 'package:task_me_flutter/bloc/events/start_event.dart';
import 'package:task_me_flutter/bloc/events/time_interval_start_event.dart';
import 'package:task_me_flutter/bloc/events/time_interval_stop_event.dart';
import 'package:task_me_flutter/bloc/events/update_project_list_event.dart';
import 'package:task_me_flutter/bloc/handlers/edit_user_handler.dart';
import 'package:task_me_flutter/bloc/handlers/login_handler.dart';
import 'package:task_me_flutter/bloc/handlers/logout_handler.dart';
import 'package:task_me_flutter/bloc/handlers/overlay_handler.dart';
import 'package:task_me_flutter/bloc/handlers/set_config_handler.dart';
import 'package:task_me_flutter/bloc/handlers/start_handler.dart';
import 'package:task_me_flutter/bloc/handlers/time_interval_start_handler.dart';
import 'package:task_me_flutter/bloc/handlers/time_interval_stop_handler.dart';
import 'package:task_me_flutter/bloc/handlers/update_project_list_handler.dart';
import 'package:task_me_flutter/bloc/main_event.dart';
import 'package:task_me_flutter/repositories/local/local_storage.dart';
import 'package:task_me_flutter/router/app_router.dart';

import 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final AppRouter router;
  final LocalStorage storage;

  MainBloc(
    MainState initialState, {
    required this.router,
    required this.storage,
  }) : super(initialState) {
    on<MainEvent>(
      (event, emit) async {
        if (handlersMap.containsKey(event.runtimeType)) {
          await handlersMap[event.runtimeType]!(event, emit, this);
        } else {
          if (kDebugMode) {
            print('ga test: событию ${event.runtimeType} не назначен хэндлер.');
          }
        }
      },
      transformer: sequential(),
    );
  }
}

const Map<Type, Function> handlersMap = {
  LoginEvent: loginHandler,
  LogoutEvent: logoutHandler,
  OverlayEvent: overlayHandler,
  SetConfigEvent: setConfigHandler,
  StartEvent: startHandler,
  TimeIntervalStartEvent: timeIntervalStartHandler,
  TimeIntervalStopEvent: timeIntervalStopHandler,
  EditUserEvent: editUserHandler,
  UpdateProjectListEvent: uopdateProjectListHandler,
};
