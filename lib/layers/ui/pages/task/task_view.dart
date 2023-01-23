import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/task/task_bloc.dart';
import 'package:task_me_flutter/layers/bloc/task/task_event.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/task/cards.dart';

TaskBloc _bloc(BuildContext context) => BlocProvider.of(context);

class TasksProjectView extends StatefulWidget {
  final List<TaskUi> tasks;
  final Function(int) onTaskTap;

  const TasksProjectView({required this.tasks, required this.onTaskTap});

  @override
  State<TasksProjectView> createState() => _TasksProjectViewState();
}

class _TasksProjectViewState extends State<TasksProjectView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskBloc(widget.onTaskTap, widget.tasks),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<TaskBloc>(builder: (s, context) {
      final state = s as TaskState;
      return ListView.builder(
        itemCount: state.tasks.length,
        itemBuilder: (context, index) {
          final item = state.tasks[index];
          TaskStatus? status;
          for (final statusElement in TaskStatus.values) {
            if (index ==
                state.tasks.indexWhere((element) => element.task.status == statusElement)) {
              status = statusElement;
            }
          }
          final isShow = state.openedStatuses.contains(item.task.status);
          return TaskStatusHeader(
            isShow: isShow,
            status: status,
            onTap: () => _bloc(context).add(OnTaskStatusTap(item.task.status)),
            child: isShow
                ? TaskCard(item, () => _bloc(context).add(OnTaskTap(item.task.id!)))
                : const SizedBox(),
          );
        },
      );
    });
  }
}
