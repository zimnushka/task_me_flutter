import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class SettingsLoadedState extends AppLoadedState {
  final User user;
  final Config config;

  const SettingsLoadedState({required this.config, required this.user});
}

class SettingsLoadState extends AppLoadingState {}
