import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/task/task_bloc.dart';
import 'package:task_me_flutter/layers/bloc/task/task_event.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/task/cards.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

part 'task_list_view.dart';
part 'task_board_view.dart';

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
      if (state.state == TaskViewState.list) {
        return _TaskListView(state);
      }
      return _TaskBoardView(state);
    });
  }
}


  //  Tab(
  //                                 child: Row(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                     Icon(
  //                                       Icons.auto_awesome_mosaic_outlined,
  //                                       size: 14,
  //                                       color: Theme.of(context).textTheme.bodyMedium!.color,
  //                                     ),
  //                                     const SizedBox(width: 10),
  //                                     AppText(
  //                                       'Board',
  //                                       color: Theme.of(context).textTheme.bodyMedium!.color,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),