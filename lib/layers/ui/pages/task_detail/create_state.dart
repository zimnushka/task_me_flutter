part of 'task_detail.dart';

class _TaskCreateView extends StatefulWidget {
  const _TaskCreateView(this.state);
  final TaskDetailState state;

  @override
  State<_TaskCreateView> createState() => __TaskCreateViewState();
}

class __TaskCreateViewState extends State<_TaskCreateView> {
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
                _TaskIDCard(widget.state.task?.id),
                const Expanded(child: SizedBox()),
                _TaskStatusSelector(
                  value: widget.state.editedTask.status,
                  readOnly: false,
                  onChanged: (value) => _bloc(context).add(OnTaskStatusSwap(value)),
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
                //               items: widget.state.users.map((e) {
                //                 return MultiSelectItem(
                //                     isActive: widget.state.assigners.contains(e),
                //                     value: e,
                //                     child: _UserCard(e));
                //               }).toList());
                //         });
                //   },
                //   child: widget.state.assigners.isEmpty
                //       ? const Text('Without assigner', style: TextStyle(fontSize: 18))
                //       : MultiUserShow(widget.state.assigners, radius: 20),
                // ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            _TaskTitleEditor(
              initValue: widget.state.editedTask.title,
              readOnly: widget.state.task?.status == TaskStatus.closed,
              onChanged: (value) => _bloc(context).add(
                OnTitleUpdate(value),
              ),
            ),
            const SizedBox(height: defaultPadding),
            _TaskDescriptionEditor(
              initValue: widget.state.editedTask.description,
              onChanged: (value) => _bloc(context).add(OnDescriptionUpdate(value)),
              readOnly: widget.state.task?.status == TaskStatus.closed,
            ),
            const SizedBox(height: defaultPadding),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () => _bloc(context).add(OnSubmit()),
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
