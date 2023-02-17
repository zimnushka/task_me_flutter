import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/task/task_bloc.dart';
import 'package:task_me_flutter/layers/bloc/task/task_event.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/task/cards.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

part 'task_list_view.dart';
part 'task_board_view.dart';
part 'task_view_filter.dart';

TaskBloc _bloc(BuildContext context) => BlocProvider.of(context);

class TasksViewProvider extends StatefulWidget {
  final Widget child;
  final TaskBloc bloc;
  const TasksViewProvider({required this.child, required this.bloc});

  @override
  State<TasksViewProvider> createState() => _TasksViewProviderState();
}

class _TasksViewProviderState extends State<TasksViewProvider> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: widget.child,
    );
  }
}

class TaskView extends StatelessWidget {
  const TaskView();

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
