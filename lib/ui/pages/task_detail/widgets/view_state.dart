part of '../task_detail.dart';

class _TaskView extends StatelessWidget {
  const _TaskView();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TaskDetailVM>();
    final task = context.select((TaskDetailVM vm) => vm.task);
    final editedTask = context.select((TaskDetailVM vm) => vm.editedTask);
    final assigners = context.select((TaskDetailVM vm) => vm.assigners);

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _TaskIDCard(task?.id),
                const Expanded(child: SizedBox()),
                _TaskStatusSelector(value: editedTask.status, onChanged: (_) {}, readOnly: true),
                const SizedBox(width: defaultPadding),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Card(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 320, maxHeight: 500),
                                child: Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Assigners',
                                          style: Theme.of(context).textTheme.titleLarge),
                                      const SizedBox(height: defaultPadding),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: assigners.length,
                                          itemBuilder: (context, index) {
                                            final item = assigners[index];
                                            return _UserCard(item);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: assigners.isEmpty
                      ? const Text('Without assigner', style: TextStyle(fontSize: 18))
                      : MultiUserShow(assigners, radius: 20),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            _TaskTitleEditor(
              initValue: editedTask.title,
              readOnly: task?.status == TaskStatus.closed,
              onChanged: vm.onTitleUpdate,
            ),
            const SizedBox(height: defaultPadding),
            _TaskDescriptionEditor(
              initValue: editedTask.description,
              onChanged: vm.onDescriptionUpdate,
              readOnly: task?.status == TaskStatus.closed,
            ),
            const SizedBox(height: defaultPadding),
            const AppText('Time intervals'),
            const SizedBox(height: 10),
            TaskIntervalsView(readOnly: true, taskId: editedTask.id!)
          ],
        ),
      ),
    );
  }
}
