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

@freezed
class Task with _$Task {
  factory Task({
    required final int id,
    required final String title,
    required final String description,
    required final int projectId,
    required final DateTime dueDate,
    @JsonKey(name: 'statusId') required final TaskStatus status,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
