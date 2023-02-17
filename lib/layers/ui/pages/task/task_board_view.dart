part of 'task_view.dart';

class _TaskBoardView extends StatelessWidget {
  _TaskBoardView(this.state);
  final TaskState state;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: defaultPadding, bottom: defaultPadding),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 205,
          width: double.infinity,
          child: Scrollbar(
            controller: controller,
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 15),
              controller: controller,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: TaskStatus.values.map((e) {
                  final List<TaskUi> tasks =
                      state.tasks.where((element) => element.task.status == e).toList();
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(radius),
                          color: e.color.withOpacity(0.1),
                        ),
                        width: 350,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TaskBoardStatusHeader(status: e, tasksCount: tasks.length),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  padding: const EdgeInsets.all(10),
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) {
                                    final item = tasks[index];
                                    return TaskBoardCard(
                                      item: item,
                                      onTap: () => _bloc(context).add(
                                        OnTaskTap(item.task.id!),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        )),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
