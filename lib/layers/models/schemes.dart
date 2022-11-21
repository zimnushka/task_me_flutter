import 'package:freezed_annotation/freezed_annotation.dart';

part 'schemes.g.dart';
part 'schemes.freezed.dart';

@freezed
class User with _$User {
  // @JsonSerializable(fieldRename: FieldRename.snake)
  factory User({
    required final int id,
    required final String name,
    required final String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Project with _$Project {
  // @JsonSerializable(fieldRename: FieldRename.snake)
  factory Project({
    required final int id,
    required final String title,
    required final int color,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}

@freezed
class Task with _$Task {
  // @JsonSerializable(fieldRename: FieldRename.snake)
  factory Task({
    required final int id,
    required final String title,
    required final String description,
    required final int projectId,
    required final DateTime dueDate,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
