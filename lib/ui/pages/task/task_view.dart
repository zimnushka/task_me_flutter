import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/ui/pages/task/task_vm.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/ui/pages/task/widgets/cards.dart';
import 'package:task_me_flutter/ui/styles/text.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';

part 'widgets/task_list_view.dart';
part 'widgets/task_board_view.dart';
part 'widgets/task_view_filter.dart';

class TaskView extends StatelessWidget {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((TaskVM bloc) => bloc.state);
    if (state == TaskViewState.list) {
      return const _TaskListView();
    }
    return const _TaskBoardView();
  }
}
