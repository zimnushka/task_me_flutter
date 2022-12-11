// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:task_me_flutter/app/bloc/states.dart';
// import 'package:task_me_flutter/layers/models/schemes.dart';
// import 'package:task_me_flutter/layers/repositories/api/project.dart';
// import 'package:task_me_flutter/layers/repositories/api/task.dart';
// import 'package:task_me_flutter/layers/repositories/api/user.dart';

// class TaskState extends AppState {
//   final Project? project;
//   final List<User> users;
//   final List<Task tasks;
//   final ProjectPageState pageState;
//   final List<TaskStatus> openedStatuses;

//   const TaskState({
//     required this.users,
//     required this.tasks,
//     required this.openedStatuses,
//     this.project,
//     this.pageState = ProjectPageState.tasks,
//   });

//   TaskState copyWith({
//     Project? project,
//     List<User>? users,
//     List<Task>? tasks,
//     ProjectPageState? pageState,
//     List<TaskStatus>? openedStatuses,
//   }) {
//     return TaskState(
//       project: project ?? this.project,
//       users: users ?? this.users,
//       tasks: tasks ?? this.tasks,
//       pageState: pageState ?? this.pageState,
//       openedStatuses: openedStatuses ?? this.openedStatuses,
//     );
//   }
// }

// class ProjectCubit extends Cubit<AppState> {
//   final int projectId;
//   ProjectCubit(this.projectId)
//       : super(const TaskState(users: [], tasks: [], openedStatuses: TaskStatus.values)) {
//     load();
//   }

//   final ProjectApiRepository projectApiRepository = ProjectApiRepository();
//   final UserApiRepository userApiRepository = UserApiRepository();
//   final TaskApiRepository taskApiRepository = TaskApiRepository();

//   Future<void> load() async {
//     final projectData = await projectApiRepository.getById(projectId);
//     final users = await userApiRepository.getUserFromProject(projectId);
//     final tasks = await taskApiRepository.getByProject(projectId);
//     tasks.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
//     emit(
//       TaskState(
//         project: projectData.data,
//         users: users.data ?? [],
//         tasks: tasks.data ?? [],
//         openedStatuses: TaskStatus.values,
//       ),
//     );
//   }

//   Future<void> setPageState(ProjectPageState pageState) async {
//     if (pageState == (state as TaskState).pageState) {
//       return;
//     }
//     emit((state as TaskState).copyWith(pageState: pageState));
//   }

//   Future<void> setOpenStatuses(List<TaskStatus> statuses) async {
//     emit((state as TaskState).copyWith(openedStatuses: [...statuses]));
//   }

//   Future<void> updateTasks() async {
//     final tasks = await taskApiRepository.getByProject(projectId);
//     tasks.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
//     final newState = (state as TaskState).copyWith(tasks: tasks.data ?? []);
//     emit(newState);
//   }

//   Future<void> updateUsers() async {
//     final users = await userApiRepository.getUserFromProject(projectId);
//     emit((state as TaskState).copyWith(users: users.data ?? []));
//   }
// }
