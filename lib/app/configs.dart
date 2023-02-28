import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

const defaultConfig = Config(
  apiBaseUrl: 'http://localhost:8080',
  debug: false,
  isLightTheme: true,
  taskView: TaskViewState.list,
);

// const releaseWebConfig = Config(
//   apiBaseUrl: 'http://192.168.81.199:8080',
//   setUrlFromHTML: false,
//   debug: false,
// );

const debugConfig = Config(
  apiBaseUrl: 'http://localhost:8080',
  debug: false,
  isLightTheme: true,
  taskView: TaskViewState.list,
);
