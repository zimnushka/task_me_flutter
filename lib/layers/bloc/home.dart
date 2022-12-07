// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/project.dart';
import 'package:task_me_flutter/layers/repositories/api/task.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';

class HomeState extends AppState {
  final List<User> users;
  final List<Task> tasks;
  final List<TaskStatus> openedStatuses;

  const HomeState({
    required this.users,
    required this.tasks,
    required this.openedStatuses,
  });

  HomeState copyWith({
    Project? project,
    List<User>? users,
    List<Task>? tasks,
    List<TaskStatus>? openedStatuses,
  }) {
    return HomeState(
      users: users ?? this.users,
      tasks: tasks ?? this.tasks,
      openedStatuses: openedStatuses ?? this.openedStatuses,
    );
  }
}

class HomeCubit extends Cubit<AppState> {
  final int userId;
  HomeCubit(this.userId)
      : super(const HomeState(users: [], tasks: [], openedStatuses: TaskStatus.values)) {
    load();
  }

  final TaskApiRepository taskApiRepository = TaskApiRepository();

  Future<void> load() async {
    final tasks = await taskApiRepository.getAll();
    tasks.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
    emit(
      HomeState(
        users: [],
        tasks: tasks.data ?? [],
        openedStatuses: TaskStatus.values,
      ),
    );
  }

  Future<void> setOpenStatuses(List<TaskStatus> statuses) async {
    emit((state as HomeState).copyWith(openedStatuses: [...statuses]));
  }

  Future<void> updateTasks() async {
    final tasks = await taskApiRepository.getAll();
    tasks.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
    final newState = (state as HomeState).copyWith(tasks: tasks.data ?? []);
    emit(newState);
  }
}
