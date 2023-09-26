import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/task.dart';
import 'package:task_me_flutter/layers/ui/pages/settings/settings.dart';
import 'package:task_me_flutter/layers/ui/pages/task_detail/task_detail.dart';

class HomeVM extends ChangeNotifier {
  final taskApiRepository = TaskApiRepository();

  HomeVM() {
    _init();
  }

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    final responce = await taskApiRepository.getAll();
    responce.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
    if (responce.data != null) {
      _tasks = responce.data!;
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> onHeaderButtonTap() async {
    await AppRouter.goTo(SettingsPage.route());
  }

  Future<void> onTaskTap(int id) async {
    final task = _tasks.firstWhere((element) => element.id == id);
    await AppRouter.goTo(TaskPage.route(task.projectId, taskId: task.id));
  }

  Future<void> updateTasks() async {
    final responce = await taskApiRepository.getAll();
    responce.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
    if (responce.data != null) {
      _tasks = responce.data!;
      notifyListeners();
    }
  }
}
