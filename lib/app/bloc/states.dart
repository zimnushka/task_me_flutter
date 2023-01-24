import 'package:task_me_flutter/app/models/error.dart';

abstract class AppState {
  const AppState();
}

class AppErrorState extends AppState {
  final AppError error;

  const AppErrorState(this.error);
}

class AppLoadingState extends AppState {
  const AppLoadingState();
}

class AppLoadedState extends AppState {
  const AppLoadedState();
}
