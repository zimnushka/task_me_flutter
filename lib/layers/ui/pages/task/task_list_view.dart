part of 'task_view.dart';

class _TaskListView extends StatelessWidget {
  const _TaskListView();

  @override
  Widget build(BuildContext context) {
    final filteredTasks = context.select((TaskBloc bloc) => bloc.state.filteredTasks);
    final filter = context.select((TaskBloc bloc) => bloc.state.filter);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: filteredTasks.length,
        (context, index) {
          final item = filteredTasks[index];
          TaskStatus? status;
          for (final statusElement in TaskStatus.values) {
            if (index ==
                filteredTasks.indexWhere((element) => element.task.status == statusElement)) {
              status = statusElement;
            }
          }
          final isShow = filter.openedStatuses.contains(item.task.status);
          return TaskListStatusHeader(
            isShow: isShow,
            status: status,
            onTap: () => _bloc(context).add(OnTaskStatusTap(item.task.status)),
            child: isShow
                ? TaskListCard(
                    item: item,
                    onTap: () => _bloc(context).add(OnTaskTap(item.task.id!)),
                    onStatusCnange: (value) => _bloc(context).add(OnChangeTaskStatus(item, value)),
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
