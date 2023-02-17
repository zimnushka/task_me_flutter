part of 'task_view.dart';

class _TaskListView extends StatelessWidget {
  const _TaskListView(this.state);
  final TaskState state;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: state.tasks.length,
        (context, index) {
          final item = state.tasks[index];
          TaskStatus? status;
          for (final statusElement in TaskStatus.values) {
            if (index ==
                state.tasks.indexWhere((element) => element.task.status == statusElement)) {
              status = statusElement;
            }
          }
          final isShow = state.openedStatuses.contains(item.task.status);
          return TaskListStatusHeader(
            isShow: isShow,
            status: status,
            onTap: () => _bloc(context).add(OnTaskStatusTap(item.task.status)),
            child: isShow
                ? TaskListCard(item, () => _bloc(context).add(OnTaskTap(item.task.id!)))
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
