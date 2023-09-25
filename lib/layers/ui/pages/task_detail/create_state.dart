part of 'task_detail.dart';

class _TaskCreateView extends StatelessWidget {
  const _TaskCreateView();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TaskDetailVM>();
    final task = context.select((TaskDetailVM vm) => vm.task);
    final editedTask = context.select((TaskDetailVM vm) => vm.editedTask);

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
                _TaskStatusSelector(
                  value: editedTask.status,
                  readOnly: false,
                  onChanged: vm.onTaskStatusSwap,
                ),
                // const SizedBox(width: defaultPadding),
                // GestureDetector(
                //   onTap: () {
                //     showDialog(
                //         context: context,
                //         builder: (_context) {
                //           return MultiSelector<User>(
                //               title: 'Select assigners',
                //               onChange: (newList) {
                //                 final activeUsers =
                //                     newList.where((e) => e.isActive).map((e) => e.value).toList();
                //                 _bloc(context).add(OnUserListChange(activeUsers));
                //                 Navigator.pop(_context);
                //               },
                //               items: users.map((e) {
                //                 return MultiSelectItem(
                //                     isActive: assigners.contains(e),
                //                     value: e,
                //                     child: _UserCard(e));
                //               }).toList());
                //         });
                //   },
                //   child: assigners.isEmpty
                //       ? const Text('Without assigner', style: TextStyle(fontSize: 18))
                //       : MultiUserShow(assigners, radius: 20),
                // ),
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
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: vm.save,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Create'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
