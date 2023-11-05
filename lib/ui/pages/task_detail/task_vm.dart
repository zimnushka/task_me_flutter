import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:task_me_flutter/bloc/events/overlay_event.dart';
import 'package:task_me_flutter/bloc/events/time_interval_start_event.dart';
import 'package:task_me_flutter/bloc/events/time_interval_stop_event.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/domain/models/error.dart';
import 'package:task_me_flutter/repositories/api/api.dart';
import 'package:task_me_flutter/service/snackbar.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';

enum TaskDetailPageState { view, edit, creation }

class TaskDetailVM extends ChangeNotifier {
  final MainBloc mainBloc;

  TaskDetailVM({
    required this.initProjectId,
    required this.mainBloc,
    required this.onTaskUpdate,
    int? taskId,
  }) {
    _initTaskId = taskId;
    _init();
  }
  final int initProjectId;
  final VoidCallback? onTaskUpdate;

  int? _initTaskId;
  int? get initTaskId => _initTaskId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<User> _users = [];
  List<User> get users => _users;

  List<User> _assigners = [];
  List<User> get assigners => _assigners;

  List<TimeInterval> _intervals = [];
  List<TimeInterval> get intervals => _intervals;

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

    final usersData = await mainBloc.state.repo.getUserFromProject(initProjectId);
    _users = usersData.data ?? [];

    if (initTaskId != null) {
      //TODO: optimaze
      _assigners = (await mainBloc.state.repo.getUserFromTask(initTaskId!)).data ?? [];
      _task = (await mainBloc.state.repo.getTaskById(initTaskId!)).data;

      if (_task != null) {
        _editedTask = _task!;
        _state = _task!.status == TaskStatus.closed
            ? TaskDetailPageState.view
            : TaskDetailPageState.edit;
      }
      _intervals = (await mainBloc.state.repo.getTaskIntervals(initTaskId!)).data ?? [];
      _intervals = [..._intervals.reversed];
      _isLoading = false;
      notifyListeners();
      return;
    }
    _state = TaskDetailPageState.creation;
    _editedTask = _editedTask.copyWith(projectId: initProjectId);

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> delete() async {
    if (_task != null) {
      final responce = (await mainBloc.state.repo.deleteTask(_task!.id!)).data ?? false;
      if (responce) {
        _initTaskId = null;
        _task = null;
        onTaskUpdate?.call();
        return true;
      } else {
        mainBloc.add(OverlayEvent(message: 'Delete error', type: OverlayType.error));
        return false;
      }
    }
    return false;
  }

  Future<void> save() async {
    try {
      // TODO: localize
      if (editedTask.id != null) {
        await mainBloc.state.repo.editTask(editedTask);
        onTaskUpdate?.call();
        mainBloc.add(OverlayEvent(message: 'Edited', type: OverlayType.success));
        _initTaskId = editedTask.id;
      } else {
        // TODO:
        final newTask = editedTask.copyWith(startDate: DateTime.now());
        final createdTask = (await mainBloc.state.repo.createTask(newTask)).data!;
        onTaskUpdate?.call();
        mainBloc.add(OverlayEvent(message: 'Created', type: OverlayType.success));
        _initTaskId = createdTask.id;
      }

      await _getData();
    } on LogicalException catch (e) {
      mainBloc.add(OverlayEvent(message: e.message, type: OverlayType.error));
    } catch (e) {
      mainBloc.add(OverlayEvent(message: e.toString(), type: OverlayType.error));
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
      //TODO: fix !
      await mainBloc.state.repo.updateTaskMemberList(task!.id!, users);
      onTaskUpdate?.call();
      // ignore: empty_catches
    } catch (e) {}

    _assigners = [...users];
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

  Future<void> updateIntervals() async {
    if (editedTask.id == null) return;

    _isLoading = true;
    notifyListeners();

    _intervals = (await mainBloc.state.repo.getTaskIntervals(editedTask.id!)).data ?? [];
    _intervals = [..._intervals.reversed];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> stopInterval(String? desc) async {
    mainBloc.add(TimeIntervalStopEvent(desc: desc));
  }

  Future<void> startInterval() async {
    if (editedTask.id == null) return;
    mainBloc.add(TimeIntervalStartEvent(taskId: editedTask.id!));
  }
}
