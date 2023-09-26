import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:task_me_flutter/domain/models/error.dart';
import 'package:task_me_flutter/domain/service/router.dart';
import 'package:task_me_flutter/domain/service/snackbar.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/repositories/api/user.dart';
import 'package:task_me_flutter/service/task.dart';

enum TaskDetailPageState { view, edit, creation }

class TaskDetailVM extends ChangeNotifier {
  final _taskService = TaskService();
  final _userApiRepository = UserApiRepository();

  TaskDetailVM({required this.initProjectId, int? taskId}) {
    _initTaskId = taskId;
    _init();
  }
  final int initProjectId;

  int? _initTaskId;
  int? get initTaskId => _initTaskId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<User> _users = [];
  List<User> get users => _users;

  List<User> _assigners = [];
  List<User> get assigners => _assigners;

  Task? _task;
  Task? get task => _task;

  Task _editedTask = Task.empt();
  Task get editedTask => _editedTask;

  TaskDetailPageState _state = TaskDetailPageState.edit;
  TaskDetailPageState get state => _state;

  Future<void> _init() async {
    await _getData();
  }

  Future<void> _getData() async {
    _isLoading = true;
    notifyListeners();

    final usersData = await _userApiRepository.getUserFromProject(initProjectId);
    _users = usersData.data ?? [];

    if (initTaskId != null) {
      //TODO: optimaze
      _assigners = await _taskService.getTaskMembers(initTaskId!);
      _task = await _taskService.getTaskById(initTaskId!);

      if (_task != null) {
        _editedTask = _task!;
        _state = _task!.status == TaskStatus.closed
            ? TaskDetailPageState.view
            : TaskDetailPageState.edit;

        _isLoading = false;
        notifyListeners();
        return;
      }
    }
    _editedTask = _editedTask.copyWith(projectId: initProjectId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> delete() async {
    if (_task != null) {
      final responce = await _taskService.deleteTask(_task!.id!);
      if (responce) {
        _initTaskId = null;
        _task = null;
        await _getData();
      } else {
        AppSnackBar.show(AppRouter.context, 'Delete error', AppSnackBarType.error);
      }
    }
  }

  Future<void> save() async {
    try {
      // TODO: localize
      if (editedTask.id != null) {
        await _taskService.editTask(editedTask, users);
        AppSnackBar.show(AppRouter.context, 'Edited', AppSnackBarType.success);
        _initTaskId = editedTask.id;
      } else {
        final newTask = await _taskService.addTask(editedTask);
        AppSnackBar.show(AppRouter.context, 'Created', AppSnackBarType.success);
        _initTaskId = newTask.id;
      }
      await _getData();
    } on LogicalException catch (e) {
      AppSnackBar.show(AppRouter.context, e.message, AppSnackBarType.error);
    } catch (e) {
      AppSnackBar.show(AppRouter.context, e.toString(), AppSnackBarType.error);
    }
  }

  Future<void> onTaskStatusSwap(TaskStatus status) async {
    if (editedTask.status == status) {
      _editedTask = editedTask.copyWith(status: status);
      notifyListeners();
    }
  }

  Future<void> onUserSwap(List<User> users) async {
    try {
      await _taskService.editTaskMemberList(task!, users);
      // ignore: empty_catches
    } catch (e) {}

    _assigners = List.of(users);
    notifyListeners();
  }

  Future<void> onTitleUpdate(String value) async {
    _editedTask = editedTask.copyWith(title: value);
    notifyListeners();
  }

  Future<void> onDescriptionUpdate(String value) async {
    _editedTask = editedTask.copyWith(description: value);
    notifyListeners();
  }
}
