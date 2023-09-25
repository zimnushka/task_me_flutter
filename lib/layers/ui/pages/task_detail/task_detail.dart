import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:provider/provider.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_bloc.dart';

import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/multi_user_show.dart';
import 'package:task_me_flutter/layers/ui/kit/multiselector.dart';
import 'package:task_me_flutter/layers/ui/kit/slide_animation_container.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';
import 'package:task_me_flutter/layers/ui/pages/task_detail/interval.dart';

part 'create_state.dart';
part 'edit_state.dart';
part 'cards.dart';
part 'view_state.dart';

class TaskRoute implements AppPage {
  final int projectId;
  final int? taskId;

  const TaskRoute(this.projectId, this.taskId);

  @override
  String get name => 'task';

  @override
  Map<String, String> get params => {'taskId': taskId.toString()};

  @override
  Map<String, String>? get queryParams => {'projectId': projectId.toString()};
}

class TaskPage extends StatelessWidget {
  const TaskPage({
    required this.projectId,
    this.taskId,
    super.key,
  });
  final int projectId;
  final int? taskId;

  static AppPage route(int projectId, {int? taskId}) => TaskRoute(projectId, taskId);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskDetailVM(initProjectId: projectId, taskId: taskId),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final state = context.select((TaskDetailVM vm) => vm.state);
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
