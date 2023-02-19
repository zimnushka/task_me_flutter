import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

abstract class SettingsEvent {}

class ChangeTheme extends SettingsEvent {
  final bool isLight;
  ChangeTheme({required this.isLight});
}

class ChangeTaskView extends SettingsEvent {
  final TaskViewState view;
  ChangeTaskView(this.view);
}

class ChangeApiUrl extends SettingsEvent {
  final String url;
  ChangeApiUrl(this.url);
}

class LogOut extends SettingsEvent {}

class Load extends SettingsEvent {
  final User user;
  final Config config;

  Load(this.config, this.user);
}
