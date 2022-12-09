import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/project.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/project/cards.dart';
import 'package:task_me_flutter/layers/ui/pages/task_page.dart';

ProjectCubit _bloc(BuildContext context) => BlocProvider.of(context);

class TasksProjectView extends StatelessWidget {
  const TasksProjectView(
    this.state,
  );
  final ProjectState state;

  User? getUserTask(int? id) {
    if (id == null) {
      return null;
    }
    final users = state.users.where((element) => element.id == id);
    if (users.isEmpty) {
      return null;
    }
    return users.first;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = _bloc(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: state.tasks.length,
        (context, index) {
          final item = state.tasks[index];
          TaskStatus? status;
          for (final statusElement in TaskStatus.values) {
            if (index == state.tasks.indexWhere((element) => element.status == statusElement)) {
              status = statusElement;
            }
          }
          final isShow = state.openedStatuses.contains(item.status);
          return TaskStatusHeader(
            isShow: isShow,
            status: status,
            onTap: () {
              final newStats = [...state.openedStatuses];
              if (isShow) {
                newStats.remove(item.status);
                cubit.setOpenStatuses(newStats);
              } else {
                newStats.add(item.status);
                cubit.setOpenStatuses(newStats);
              }
            },
            child: isShow
                ? TaskCard(
                    item,
                    () => TaskPage.route(context, item.projectId, taskId: item.id!),
                    user: getUserTask(item.assignerId),
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
