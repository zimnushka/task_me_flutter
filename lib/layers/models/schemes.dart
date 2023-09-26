import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

DateTime? _dateTimeFromString(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

class Config {
  final String apiBaseUrl;
  final bool isLightTheme;
  final TaskViewState taskView;
  final bool debug;

  const Config({
    required this.apiBaseUrl,
    required this.isLightTheme,
    required this.taskView,
    required this.debug,
  });

  ThemeData get theme => isLightTheme ? lightTheme : darkTheme;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'apiBaseUrl': apiBaseUrl,
      'isLightTheme': isLightTheme,
      'taskView': taskView.toInt(),
      'debug': debug,
    };
  }

  factory Config.fromJson(Map<String, dynamic> map) {
    return Config(
      apiBaseUrl: map['apiBaseUrl'] as String,
      isLightTheme: map['isLightTheme'] as bool,
      taskView: TaskViewState.fromInt(map['taskView'] as int),
      debug: map['debug'] as bool,
    );
  }

  Config copyWith({
    String? apiBaseUrl,
    bool? isLightTheme,
    TaskViewState? taskView,
    bool? debug,
  }) {
    return Config(
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      isLightTheme: isLightTheme ?? this.isLightTheme,
      taskView: taskView ?? this.taskView,
      debug: debug ?? this.debug,
    );
  }
}

class TaskViewFilterModel {
  final List<TaskStatus> openedStatuses;
  final String? text;

  const TaskViewFilterModel({
    required this.openedStatuses,
    this.text,
  });

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

  TaskViewFilterModel copyWith({
    List<TaskStatus>? openedStatuses,
    String? text,
  }) {
    return TaskViewFilterModel(
      openedStatuses: openedStatuses ?? this.openedStatuses,
      text: text ?? this.text,
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final int colorInt;
  final int cost;

  Color get color => Color(colorInt);

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.colorInt,
    required this.cost,
  });

  String get initials {
    final words = name.split(' ');
    if (words.length > 1) {
      words.removeRange(1, words.length);
    }
    return words.fold('', (previousValue, element) => previousValue + element.characters.first);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'color': colorInt,
      'cost': cost,
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      colorInt: map['color'] as int,
      cost: map['cost'] as int,
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    int? colorInt,
    int? cost,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      colorInt: colorInt ?? this.colorInt,
      cost: cost ?? this.cost,
    );
  }
}

class UserDTO {
  final int id;
  final String name;
  final String email;
  final int colorInt;

  const UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.colorInt,
  });

  String get initials {
    final words = name.split(' ');
    if (words.length > 1) {
      words.removeRange(1, words.length);
    }
    return words.fold('', (previousValue, element) => previousValue + element.characters.first);
  }

  Color get color => Color(colorInt);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'color': colorInt,
    };
  }

  factory UserDTO.fromJson(Map<String, dynamic> map) {
    return UserDTO(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      colorInt: map['color'] as int,
    );
  }
}

class Project {
  final String title;
  final int color;
  final int? ownerId;
  final int? id;

  const Project({
    required this.title,
    required this.color,
    this.ownerId,
    this.id,
  });

  factory Project.empty() => const Project(title: '', color: -1);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'color': color,
      'ownerId': ownerId,
      'id': id,
    };
  }

  factory Project.fromJson(Map<String, dynamic> map) {
    return Project(
      title: map['title'] as String,
      color: map['color'] as int,
      ownerId: map['ownerId'] != null ? map['ownerId'] as int : null,
      id: map['id'] != null ? map['id'] as int : null,
    );
  }
}

class TimeInterval {
  final int id;
  final String description;
  final TaskDTO task;
  final UserDTO user;
  final DateTime timeStart;
  final DateTime? timeEnd;
  const TimeInterval({
    required this.id,
    required this.description,
    required this.task,
    required this.user,
    required this.timeStart,
    required this.timeEnd,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'task': task.toJson(),
      'user': user.toJson(),
      'time_start': timeStart.toIso8601String(),
      'time_end': timeEnd?.toIso8601String(),
    };
  }

  factory TimeInterval.fromJson(Map<String, dynamic> map) {
    return TimeInterval(
      id: map['id'] as int,
      description: map['description'] as String,
      task: TaskDTO.fromJson(map['task'] as Map<String, dynamic>),
      user: UserDTO.fromJson(map['user'] as Map<String, dynamic>),
      timeStart: DateTime.parse(map['time_start'] as String),
      timeEnd: _dateTimeFromString(map['time_end']),
    );
  }
}

enum TaskStatus {
  open,
  progress,
  review,
  closed;

  static TaskStatus fromInt(int value) {
    switch (value) {
      case 0:
        return TaskStatus.open;
      case 1:
        return TaskStatus.progress;
      case 2:
        return TaskStatus.review;
      case 3:
        return TaskStatus.closed;
      default:
        return TaskStatus.closed;
    }
  }

  int toInt() {
    switch (this) {
      case TaskStatus.open:
        return 0;
      case TaskStatus.progress:
        return 1;
      case TaskStatus.review:
        return 2;
      case TaskStatus.closed:
        return 3;
    }
  }

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

class Task {
  final String title;
  final String description;
  final int projectId;
  final DateTime? stopDate;
  final DateTime startDate;
  final int cost;

  final TaskStatus status;
  final int? id;
  final List<int>? assigners;

  const Task({
    required this.title,
    required this.description,
    required this.projectId,
    required this.stopDate,
    required this.startDate,
    required this.cost,
    required this.status,
    this.id,
    this.assigners,
  });

  factory Task.empt() => Task(
        stopDate: null,
        title: '',
        description: '',
        projectId: 0,
        startDate: DateTime.now(),
        cost: 0,
        status: TaskStatus.open,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'projectId': projectId,
      'stopDate': stopDate?.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'cost': cost,
      'statusId': status.toInt(),
      'id': id,
      'assigners': assigners,
    };
  }

  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
      title: map['title'] as String,
      description: map['description'] as String,
      projectId: map['projectId'] as int,
      stopDate: _dateTimeFromString(map['stopDate'] as String),
      startDate: DateTime.parse(map['startDate'] as String),
      cost: map['cost'] as int,
      status: TaskStatus.fromInt(map['statusId'] as int),
      id: map['id'] != null ? map['id'] as int : null,
      assigners: map['assigners'] != null ? List<int>.from((map['assigners'])) : null,
    );
  }

  Task copyWith({
    String? title,
    String? description,
    int? projectId,
    DateTime? stopDate,
    DateTime? startDate,
    int? cost,
    TaskStatus? status,
    int? id,
    List<int>? assigners,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      stopDate: stopDate ?? this.stopDate,
      startDate: startDate ?? this.startDate,
      cost: cost ?? this.cost,
      status: status ?? this.status,
      id: id ?? this.id,
      assigners: assigners ?? this.assigners,
    );
  }
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

class TaskDTO {
  final int id;
  final int projectId;
  final String title;
  final TaskStatus status;
  final DateTime startDate;
  final DateTime? stopDate;
  final int cost;

  const TaskDTO({
    required this.id,
    required this.projectId,
    required this.title,
    required this.status,
    required this.startDate,
    required this.stopDate,
    required this.cost,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'projectId': projectId,
      'title': title,
      'statusId': status.toInt(),
      'startDate': startDate.millisecondsSinceEpoch,
      'stopDate': stopDate?.millisecondsSinceEpoch,
      'cost': cost,
    };
  }

  factory TaskDTO.fromJson(Map<String, dynamic> map) {
    return TaskDTO(
      id: map['id'] as int,
      projectId: map['projectId'] as int,
      title: map['title'] as String,
      status: TaskStatus.fromInt(map['statusId'] as int),
      startDate: DateTime.parse(map['startDate'] as String),
      stopDate: _dateTimeFromString(map['stopDate'] as String?),
      cost: map['cost'] as int,
    );
  }
}
