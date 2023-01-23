import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class HomeLoadingState extends AppLoadingState {}

class HomeLoadedState extends AppLoadedState {
  final List<Task> tasks;

  const HomeLoadedState({required this.tasks});

  HomeLoadedState copyWith({List<Task>? tasks}) => HomeLoadedState(tasks: tasks ?? this.tasks);
}
