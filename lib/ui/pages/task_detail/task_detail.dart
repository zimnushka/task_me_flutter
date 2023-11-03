import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:provider/provider.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/router/app_router.dart';
import 'package:task_me_flutter/ui/pages/task_detail/task_vm.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/ui/pages/task_detail/widgets/interval.dart';
import 'package:task_me_flutter/ui/styles/text.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';
import 'package:task_me_flutter/ui/widgets/load_container.dart';
import 'package:task_me_flutter/ui/widgets/multi_user_show.dart';
import 'package:task_me_flutter/ui/widgets/multiselector.dart';
import 'package:task_me_flutter/ui/widgets/slide_animation_container.dart';

part 'widgets/create_state.dart';
part 'widgets/edit_state.dart';
part 'widgets/cards.dart';
part 'widgets/view_state.dart';
part 'widgets/load_state.dart';

class TaskRoute implements AppPage {
  final int projectId;
  final int? taskId;
  final VoidCallback? onTaskUpdate;

  const TaskRoute(this.projectId, this.taskId, {this.onTaskUpdate});

  @override
  String get name => 'task';

  @override
  Map<String, String> get params => {'taskId': taskId.toString()};

  @override
  Map<String, String>? get queryParams => {'projectId': projectId.toString()};

  @override
  VoidCallback? get extra => onTaskUpdate;
}

class TaskPage extends StatelessWidget {
  const TaskPage({
    required this.projectId,
    this.taskId,
    this.onTaskUpdate,
    super.key,
  });
  final int projectId;
  final int? taskId;
  final VoidCallback? onTaskUpdate;

  static AppPage route(
    int projectId, {
    int? taskId,
    VoidCallback? onTaskUpdate,
  }) =>
      TaskRoute(
        projectId,
        taskId,
        onTaskUpdate: onTaskUpdate,
      );

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return ChangeNotifierProvider(
      create: (_) => TaskDetailVM(
        onTaskUpdate: onTaskUpdate,
        initProjectId: projectId,
        taskId: taskId,
        mainBloc: mainBloc,
      ),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final state = context.select((TaskDetailVM vm) => vm.state);
    final isLoading = context.select((TaskDetailVM vm) => vm.isLoading);
    if (isLoading) {
      return const _LoadState();
    }
    switch (state) {
      case TaskDetailPageState.view:
        return const _TaskView();
      case TaskDetailPageState.edit:
        return const _TaskEditView();
      case TaskDetailPageState.creation:
        return const _TaskCreateView();
    }
  }
}
