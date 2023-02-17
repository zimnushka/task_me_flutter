part of 'task_view.dart';

class _TaskBoardView extends StatelessWidget {
  const _TaskBoardView(this.state);
  final TaskState state;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: defaultPadding),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: TaskStatus.values.map((e) {
                final List<TaskUi> tasks =
                    state.tasks.where((element) => element.task.status == e).toList();
                return Container(
                    width: 400,
                    color: e.color,
                    child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final item = tasks[index];
                          return Card(
                            child: Text(item.task.title),
                          );
                        }));
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
