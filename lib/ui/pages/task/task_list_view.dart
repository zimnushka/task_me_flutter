part of 'task_view.dart';

class _TaskListView extends StatelessWidget {
  const _TaskListView();

  @override
  Widget build(BuildContext context) {
    final filteredTasks = context.select((TaskVM vm) => vm.filteredTasks);
    final filter = context.select((TaskVM vm) => vm.filter);
    final vm = context.read<TaskVM>();

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
            onTap: () => vm.onTaskStatusTap(item.task.status),
            child: isShow
                ? TaskListCard(
                    item: item,
                    onTap: () => vm.onTaskTap(item.task.id!),
                    onStatusCnange: (value) => vm.onChangeTaskStatus(item, value),
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
