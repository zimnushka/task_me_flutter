// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

part 'schemes.freezed.dart';
part 'schemes.g.dart';

String? getStringDateTime(Map<dynamic, dynamic> data, String key) {
  if (data[key] is String) {
    if ((data[key] as String).isNotEmpty) {
      if (DateTime.tryParse(data[key]) != null) {
        return data[key];
      }
    }
  }
  return null;
}

@freezed
class Config with _$Config {
  const factory Config({
    required final String apiBaseUrl,
    required final bool isLightTheme,
    required final TaskViewState taskView,
    required final bool debug,
  }) = _Config;

  const Config._();

  ThemeData get theme => isLightTheme ? lightTheme : darkTheme;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}

@Freezed(makeCollectionsUnmodifiable: false)
class TaskViewFilterModel with _$TaskViewFilterModel {
  const factory TaskViewFilterModel({
    required final List<TaskStatus> openedStatuses,
    final String? text,
  }) = _TaskViewFilterModel;

  const TaskViewFilterModel._();

  List<TaskUi> getTaskByFilter(List<TaskUi> tasks) {
    List<TaskUi> filteredTasks = List.of(tasks);
    if (text != null) {
      filteredTasks = filteredTasks
          .where(
            (element) => element.task.title.toUpperCase().contains(
                  text!.toUpperCase(),
                ),
          )
          .toList();
    }
    return filteredTasks;
  }

  factory TaskViewFilterModel.fromJson(Map<String, dynamic> json) =>
      _$TaskViewFilterModelFromJson(json);
}

@freezed
class User with _$User {
  factory User({
    required final int id,
    required final String name,
    required final String email,
    @JsonKey(name: 'color') required final int colorInt,
    required final int cost,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String get initials {
    final words = name.split(' ');
    if (words.length > 1) {
      words.removeRange(1, words.length);
    }
    return words.fold('', (previousValue, element) => previousValue + element.characters.first);
  }

  Color get color => Color(colorInt);
}

@freezed
class UserDTO with _$UserDTO {
  factory UserDTO({
    required final int id,
    required final String name,
    required final String email,
    @JsonKey(name: 'color') required final int colorInt,
  }) = _UserDTO;

  const UserDTO._();

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

  String get initials {
    final words = name.split(' ');
    if (words.length > 1) {
      words.removeRange(1, words.length);
    }
    return words.fold('', (previousValue, element) => previousValue + element.characters.first);
  }

  Color get color => Color(colorInt);
}

@freezed
class Project with _$Project {
  factory Project({
    required final String title,
    required final int color,
    final int? ownerId,
    final int? id,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}

@freezed
class TimeInterval with _$TimeInterval {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory TimeInterval({
    required final int id,
    required final String description,
    required final TaskDTO task,
    required final UserDTO user,
    required final DateTime timeStart,
    @JsonKey(readValue: getStringDateTime) required final DateTime? timeEnd,
  }) = _TimeInterval;

  factory TimeInterval.fromJson(Map<String, dynamic> json) => _$TimeIntervalFromJson(json);
}

enum TaskStatus {
  @JsonValue(0)
  open,
  @JsonValue(1)
  progress,
  @JsonValue(2)
  review,
  @JsonValue(3)
  closed,
}

extension TaskStatusExt on TaskStatus {
  Color get color {
    switch (this) {
      case TaskStatus.open:
        return const Color.fromARGB(255, 207, 114, 0);
      case TaskStatus.progress:
        return const Color.fromARGB(255, 2, 127, 190);
      case TaskStatus.review:
        return const Color.fromARGB(255, 99, 1, 192);
      case TaskStatus.closed:
        return const Color.fromARGB(255, 44, 186, 1);
    }
  }

  String get label {
    switch (this) {
      case TaskStatus.open:
        return 'Open';
      case TaskStatus.progress:
        return 'In progress';
      case TaskStatus.review:
        return 'Review';
      case TaskStatus.closed:
        return 'Closed';
    }
  }
}

@freezed
class Task with _$Task {
  factory Task({
    required final String title,
    required final String description,
    required final int projectId,
    @JsonKey(readValue: getStringDateTime) required final DateTime? stopDate,
    required final DateTime startDate,
    required final int cost,
    @JsonKey(name: 'statusId') required final TaskStatus status,
    final int? id,
    final List<int>? assigners,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

class TaskUi {
  final Task task;
  final List<User> users;

  const TaskUi(this.task, this.users);

  TaskUi copyWith({
    Task? task,
    List<User>? users,
  }) {
    return TaskUi(
      task ?? this.task,
      users ?? this.users,
    );
  }
}

@freezed
class TaskDTO with _$TaskDTO {
  factory TaskDTO({
    required final int id,
    required final int projectId,
    required final String title,
    @JsonKey(name: 'statusId') required final TaskStatus status,
    required final DateTime startDate,
    @JsonKey(readValue: getStringDateTime) required final DateTime? stopDate,
    required final int cost,
  }) = _TaskDTO;

  factory TaskDTO.fromJson(Map<String, dynamic> json) => _$TaskDTOFromJson(json);
}
