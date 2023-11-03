import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:task_me_flutter/bloc/events/update_project_list_event.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/repositories/api/api.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/ui/pages/home/home.dart';
import 'package:task_me_flutter/ui/pages/task_detail/task_detail.dart';

enum ProjectPageState {
  tasks,
  users,
  info;

  String get headerButtonLabel {
    switch (this) {
      case ProjectPageState.tasks:
        return 'Create task';
      case ProjectPageState.users:
        return 'Invite user';
      case ProjectPageState.info:
        return 'Edit project';
    }
  }
}

class ProjectVM extends ChangeNotifier {
  final MainBloc mainBloc;
  final int projectId;

  ProjectVM({required this.projectId, required this.mainBloc}) {
    _init();
  }

  Project _project = Project.empty();
  Project get project => _project;

  List<User> _users = [];
  List<User> get users => _users;

  List<TaskUi> _tasks = [];
  List<TaskUi> get tasks => _tasks;

  ProjectPageState _pageState = ProjectPageState.tasks;
  ProjectPageState get pageState => _pageState;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    final projectData = await mainBloc.state.repo.getProjectById(projectId);
    final users = await mainBloc.state.repo.getUserFromProject(projectId);
    final tasksData = await mainBloc.state.repo.getTasksByProject(projectId);
    final tasks = tasksData.data ?? [];
    tasks.sort((a, b) => a.status.index.compareTo(b.status.index));

    _project = projectData.data!;
    _users = users.data ?? [];
    _tasks = tasks
        .map((task) => TaskUi(task, _getUserTask(task.assigners ?? [], users.data ?? [])))
        .toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh({bool user = false, bool project = false, bool tasks = false}) async {
    if (user) {
      final users = await mainBloc.state.repo.getUserFromProject(projectId);
      _users = users.data ?? [];
    }
    if (project) {
      final projectData = await mainBloc.state.repo.getProjectById(projectId);
      mainBloc.add(UpdateProjectListEvent());
      if (projectData.data != null) {
        _project = projectData.data!;
      }
    }
    if (tasks) {
      final tasksData = await mainBloc.state.repo.getTasksByProject(projectId);
      final tasks = tasksData.data ?? [];
      tasks.sort((a, b) => a.status.index.compareTo(b.status.index));
      _tasks =
          tasks.map((task) => TaskUi(task, _getUserTask(task.assigners ?? [], users))).toList();
    }

    notifyListeners();
  }

  Future<void> onDeleteUser(int userId) async {
    await mainBloc.state.repo.deleteMemberFromProject(userId, projectId);
    refresh(user: true);
  }

  Future<void> onDeleteProject() async {
    await mainBloc.state.repo.deleteProject(projectId);
    mainBloc.add(UpdateProjectListEvent());
    //TODO: clear routs?
    mainBloc.router.goTo(HomeRoute());
  }

  Future<void> onTaskTap(int taskId) async {
    await mainBloc.router.goTo(
      TaskPage.route(
        projectId,
        taskId: taskId,
        onTaskUpdate: () {
          refresh(tasks: true);
        },
      ),
    );
  }

  Future<void> onTabTap(ProjectPageState page) async {
    if (page != pageState) {
      _pageState = page;
      notifyListeners();
    }
  }

  List<User> _getUserTask(List<int> assignersIds, List<User> users) {
    return users.where((element) => assignersIds.contains(element.id)).toList();
  }
}
