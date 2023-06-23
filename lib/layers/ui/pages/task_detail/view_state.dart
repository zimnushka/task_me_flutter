part of 'task_detail.dart';

class _TaskView extends StatelessWidget {
  const _TaskView(this.state);
  final TaskDetailState state;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _TaskIDCard(state.task?.id),
                const Expanded(child: SizedBox()),
                _TaskStatusSelector(
                    value: state.editedTask.status, onChanged: (_) {}, readOnly: true),
                const SizedBox(width: defaultPadding),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_context) {
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
                                          itemCount: state.assigners.length,
                                          itemBuilder: (context, index) {
                                            final item = state.assigners[index];
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
                  child: state.assigners.isEmpty
                      ? const Text('Without assigner', style: TextStyle(fontSize: 18))
                      : MultiUserShow(state.assigners, radius: 20),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            _TaskTitleEditor(
              initValue: state.editedTask.title,
              readOnly: state.task?.status == TaskStatus.closed,
              onChanged: (value) => _bloc(context).add(
                OnTitleUpdate(value),
              ),
            ),
            const SizedBox(height: defaultPadding),
            _TaskDescriptionEditor(
              initValue: state.editedTask.description,
              onChanged: (value) => _bloc(context).add(OnDescriptionUpdate(value)),
              readOnly: state.task?.status == TaskStatus.closed,
            ),
            const SizedBox(height: defaultPadding),
            const AppText('Time intervals'),
            const SizedBox(height: 10),
            TaskIntervalsView(readOnly: true, taskId: state.editedTask.id!)
          ],
        ),
      ),
    );
  }
}
