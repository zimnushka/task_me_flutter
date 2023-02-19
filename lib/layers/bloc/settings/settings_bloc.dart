import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/bloc/settings/settings_event.dart';
import 'package:task_me_flutter/layers/bloc/settings/settings_state.dart';
import 'package:task_me_flutter/layers/service/config.dart';
import 'package:task_me_flutter/layers/service/user.dart';

class SettingsBloc extends Bloc<SettingsEvent, AppState> {
  SettingsBloc() : super(SettingsLoadState()) {
    on<Load>(_load);
    on<LogOut>(_logOut);
    on<ChangeApiUrl>(_changeApiBaseUrl);
    on<ChangeTaskView>(_changeTaskView);
    on<ChangeTheme>(_changeTheme);
  }

  final _configService = ConfigService();
  final _userService = UserService();

  Future<void> _load(Load event, Emitter emit) async {}

  Future<void> _logOut(LogOut event, Emitter emit) async {}

  Future<void> _changeApiBaseUrl(ChangeApiUrl event, Emitter emit) async {}

  Future<void> _changeTaskView(ChangeTaskView event, Emitter emit) async {}

  Future<void> _changeTheme(ChangeTheme event, Emitter emit) async {}
}
