import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_bloc.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_event.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/multi_user_show.dart';
import 'package:task_me_flutter/layers/ui/kit/multiselector.dart';
import 'package:task_me_flutter/layers/ui/kit/slide_animation_container.dart';
import 'package:task_me_flutter/layers/ui/pages/interval/interval.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

part 'create_state.dart';
part 'edit_state.dart';
part 'cards.dart';
part 'view_state.dart';

TaskDetailBloc _bloc(BuildContext context) => BlocProvider.of(context);

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
    return BlocProvider<TaskDetailBloc>(
      create: (_) => TaskDetailBloc()..add(Load(projectId: projectId, taskId: taskId)),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<TaskDetailBloc>(builder: (state, context) {
      state as TaskDetailState;
      switch (state.state) {
        case TaskDetailPageState.view:
          return _TaskView(state);
        case TaskDetailPageState.edit:
          return _TaskEditView(state);
        case TaskDetailPageState.creation:
          return _TaskCreateView(state);
      }
    });
  }
}
