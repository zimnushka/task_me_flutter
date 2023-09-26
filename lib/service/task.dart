import 'package:task_me_flutter/domain/models/error.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/repositories/api/interval.dart';
import 'package:task_me_flutter/repositories/api/task.dart';
import 'package:task_me_flutter/repositories/api/user.dart';

class TaskService {
  final _taskApiRepository = TaskApiRepository();
  final _userApiRepository = UserApiRepository();
  final _intervalsApiRepository = IntervalApiRepository();

  Future<List<User>> getTaskMembers(int id) async {
    return (await _userApiRepository.getUserFromTask(id)).data ?? [];
  }

  Future<Task?> getTaskById(int id) async {
    return (await _taskApiRepository.getById(id)).data;
  }

  Future<bool> deleteTask(int id) async {
    return (await _taskApiRepository.delete(id)).data ?? false;
  }

  Future<Task> addTask(Task task) async {
    final newTask = task.copyWith(
      description: task.description.replaceAll(r'\n', r'\\n'),
      startDate: DateTime.now(),
      cost: 0,
    );

    final responce = await _taskApiRepository.create(newTask);
    if (responce.isSuccess) {
      return responce.data!;
    }
    throw Exception(responce.message);
  }

  Future<bool> editTask(Task task, List<User> projectUsers) async {
    int cost = 0;
    final List<TimeInterval> intervals =
        (await _intervalsApiRepository.getTaskIntervals(task.id!)).data ?? [];
    if (task.status == TaskStatus.closed) {
      if (intervals.where((element) => element.timeEnd == null).isNotEmpty) {
        throw const LogicalException('Please end all intervals');
      }
      for (final user in projectUsers) {
        final duration = intervals
            .where((element) => element.user.id == user.id)
            .map((e) => e.timeStart.difference(e.timeEnd!).abs())
            .fold(const Duration(), (previousValue, element) => previousValue + element);
        cost = cost + duration.inHours * user.cost;
      }
    }
    final newTask = task.copyWith(
      description: task.description.replaceAll(r'\n', r'\\n'),
      startDate: task.startDate,
      cost: cost,
    );
    final responce = await _taskApiRepository.edit(newTask);
    if (responce.isSuccess) {
      return responce.data!;
    }
    throw Exception(responce.message);
  }

  Future<bool> editTaskStatus(Task task, TaskStatus status, List<User> projectUsers) async {
    final newTask = task.copyWith(status: status);
    if (task.status == TaskStatus.closed) {
      throw const LogicalException('This task is closed');
    }

    if (status == TaskStatus.closed) {
      return editTask(newTask, projectUsers);
    } else {
      final responce = await _taskApiRepository.edit(newTask);
      if (responce.isSuccess) {
        return responce.data!;
      }
      throw Exception(responce.message);
    }
  }

  Future<bool> editTaskMemberList(Task task, List<User> assigners) async {
    if (task.id != null) {
      return (await _userApiRepository.updateTaskMemberList(task.id!, assigners)).data ?? false;
    }
    throw const LogicalException('Task not initialize');
  }
}
