import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/domain/service/router.dart';
import 'package:task_me_flutter/bloc/app_provider.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/repositories/api/project.dart';
import 'package:task_me_flutter/repositories/api/task.dart';
import 'package:task_me_flutter/repositories/api/user.dart';
import 'package:task_me_flutter/ui/pages/task_detail/task_detail.dart';
import 'package:task_me_flutter/ui/widgets/overlays/invite_member.dart';
import 'package:task_me_flutter/ui/widgets/overlays/project_dialog.dart';

enum ProjectPageState { tasks, users, info }

extension ProjectPageStateExt on ProjectPageState {
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
  final projectApiRepository = ProjectApiRepository();
  final userApiRepository = UserApiRepository();
  final taskApiRepository = TaskApiRepository();

  ProjectVM({required this.projectId}) {
    _init();
  }

  final int projectId;

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

    final projectData = await projectApiRepository.getById(projectId);
    final users = await userApiRepository.getUserFromProject(projectId);
    final tasksData = await taskApiRepository.getByProject(projectId);
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
      final users = await userApiRepository.getUserFromProject(projectId);
      _users = users.data ?? [];
    }
    if (project) {
      final projectData = await projectApiRepository.getById(projectId);
      final provider = AppRouter.context.read<AppProvider>();
      await provider.load();
      if (projectData.data != null) {
        _project = projectData.data!;
      }
    }
    if (tasks) {
      final tasksData = await taskApiRepository.getByProject(projectId);
      final tasks = tasksData.data ?? [];
      tasks.sort((a, b) => a.status.index.compareTo(b.status.index));
      _tasks =
          tasks.map((task) => TaskUi(task, _getUserTask(task.assigners ?? [], users))).toList();
    }

    notifyListeners();
  }

  Future<void> onDeleteUser(int userId) async {
    await userApiRepository.deleteMemberFromProject(userId, projectId);
    refresh(user: true);
  }

  Future<void> onHeaderButtonTap() async {
    switch (pageState) {
      case ProjectPageState.tasks:
        await AppRouter.goTo(TaskPage.route(projectId));
        break;
      case ProjectPageState.users:
        await AppRouter.dialog(
          (context) => InviteMemberDialog(
            projectId: projectId,
            onInvite: () => refresh(user: true),
          ),
        );
        break;
      case ProjectPageState.info:
        await AppRouter.dialog((context) => ProjectDialog(
              project: project,
              onUpdate: () => refresh(project: true),
            ));
        break;
    }
  }

  Future<void> onTaskTap(int taskId) async {
    await AppRouter.goTo(TaskPage.route(projectId, taskId: taskId));
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
