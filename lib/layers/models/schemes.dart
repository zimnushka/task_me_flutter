import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'schemes.g.dart';
part 'schemes.freezed.dart';

@freezed
class User with _$User {
  factory User({
    required final int id,
    required final String name,
    required final String email,
    required final int color,
    required final int cost,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Project with _$Project {
  factory Project({
    required final String title,
    required final int color,
    final int? id,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}

enum TaskStatus {
  @JsonValue(0)
  open,
  @JsonValue(1)
  progress,
  @JsonValue(2)
  review,
  @JsonValue(3)
  done,
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
      case TaskStatus.done:
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
      case TaskStatus.done:
        return 'Done';
    }
  }
}

@freezed
class Task with _$Task {
  factory Task({
    required final String title,
    required final String description,
    required final int projectId,
    required final DateTime dueDate,
    @JsonKey(name: 'statusId') required final TaskStatus status,
    final int? id,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
