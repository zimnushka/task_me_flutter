import 'package:task_me_flutter/domain/models/schemes.dart';

const defaultConfig = Config(
  apiBaseUrl: 'http://localhost:8080',
  debug: false,
  isLightTheme: true,
  taskView: TaskViewState.list,
);

const releaseWebConfig = Config(
  apiBaseUrl: 'http://192.168.17.9:8080',
  debug: false,
  isLightTheme: true,
  taskView: TaskViewState.list,
);

const debugConfig = Config(
  apiBaseUrl: 'http://localhost:8080',
  debug: true,
  isLightTheme: true,
  taskView: TaskViewState.list,
);
