import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:task_me_flutter/domain/models/error.dart';
import 'package:task_me_flutter/domain/service/router.dart';
import 'package:task_me_flutter/domain/service/snackbar.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/service/task.dart';

class TaskVM extends ChangeNotifier {
  final Function(int) _onTaskClick;
  final _taskService = TaskService();

  List<TaskUi> _tasks;
  List<TaskUi> get tasks => _tasks;

  List<TaskUi> _filteredTasks;
  List<TaskUi> get filteredTasks => _filteredTasks;

  TaskViewFilterModel _filter;
  TaskViewFilterModel get filter => _filter;

  TaskViewState _state;
  TaskViewState get state => _state;

  TaskVM({
    required Function(int) onTaskClick,
    required List<TaskUi> tasks,
    required TaskViewState state,
  })  : _tasks = tasks,
        _state = state,
        _filter = const TaskViewFilterModel(openedStatuses: TaskStatus.values),
        _onTaskClick = onTaskClick,
        _filteredTasks = tasks;

  Future<void> onTaskTap(int taskId) async {
    _onTaskClick(taskId);
  }

  Future<void> onChangeViewState(TaskViewState newState) async {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  Future<void> onTaskStatusTap(TaskStatus taskStatus) async {
    final statuses = List.of(_filter.openedStatuses);
    if (_filter.openedStatuses.contains(taskStatus)) {
      statuses.remove(taskStatus);
    } else {
      statuses.add(taskStatus);
    }
    _filter = TaskViewFilterModel(openedStatuses: statuses);
    notifyListeners();
  }

  Future<void> onChangeTaskStatus(TaskUi taskUi, TaskStatus taskStatus) async {
    try {
      if (await _taskService.editTaskStatus(taskUi.task, taskStatus, [])) {
        final List<TaskUi> taskUIList = List.of(_tasks);
        taskUIList.removeWhere((element) => element.task.id == taskUi.task.id);
        taskUIList.add(taskUi.copyWith(task: taskUi.task.copyWith(status: taskStatus)));
        taskUIList.sort((a, b) => a.task.status.index.compareTo(b.task.status.index));

        _tasks = [...taskUIList];
        _filteredTasks = [..._filter.getTaskByFilter(taskUIList)];
        notifyListeners();
      }
    } on LogicalException catch (e) {
      AppSnackBar.show(AppRouter.context, e.message, AppSnackBarType.error);
    } catch (e) {
      AppSnackBar.show(AppRouter.context, e.toString(), AppSnackBarType.error);
    }
  }

  Future<void> onTaskFilterChange(TaskViewFilterModel filter) async {
    _filter = filter;
    _filteredTasks = [...filter.getTaskByFilter(_tasks)];
    notifyListeners();
  }
}
