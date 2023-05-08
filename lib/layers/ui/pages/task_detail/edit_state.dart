part of 'task_detail.dart';

class _TaskEditView extends StatefulWidget {
  const _TaskEditView(this.state);
  final TaskDetailState state;

  @override
  State<_TaskEditView> createState() => __TaskEditViewState();
}

class __TaskEditViewState extends State<_TaskEditView> {
  final List<PopupMenuItem<User?>> userWidgets = [];

  @override
  Widget build(BuildContext context) {
    final hasUpdate = widget.state.task != widget.state.editedTask;

    return Scaffold(
      body: Align(
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
                  const SizedBox(width: defaultPadding),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_context) {
                            return MultiSelector<User>(
                                title: 'Select assigners',
                                onChange: (newList) {
                                  final activeUsers =
                                      newList.where((e) => e.isActive).map((e) => e.value).toList();
                                  _bloc(context).add(OnUserListChange(activeUsers));
                                  Navigator.pop(_context);
                                },
                                items: widget.state.users.map((e) {
                                  return MultiSelectItem(
                                      isActive: widget.state.assigners.contains(e),
                                      value: e,
                                      child: _UserCard(e));
                                }).toList());
                          });
                    },
                    child: widget.state.assigners.isEmpty
                        ? const Text('Without assigner', style: TextStyle(fontSize: 18))
                        : MultiUserShow(widget.state.assigners, radius: 20),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              _TaskTitleEditor(
                initValue: widget.state.editedTask.title,
                readOnly: false,
                onChanged: (value) => _bloc(context).add(
                  OnTitleUpdate(value),
                ),
              ),
              const SizedBox(height: defaultPadding),
              _TaskDescriptionEditor(
                initValue: widget.state.editedTask.description,
                onChanged: (value) => _bloc(context).add(OnDescriptionUpdate(value)),
                readOnly: false,
              ),
              const SizedBox(height: defaultPadding),
              const AppText('Time intervals'),
              const SizedBox(height: 10),
              TaskIntervalsView(readOnly: false, taskId: widget.state.editedTask.id!)
            ],
          ),
        ),
      ),
      bottomNavigationBar: hasUpdate
          ? PreferredSize(
              preferredSize: const Size(double.infinity, 70),
              child: SlideAnimatedContainer(
                replayInBuild: false,
                start: const Offset(0, 1),
                end: Offset.zero,
                duration: const Duration(seconds: 1),
                curve: Curves.elasticOut,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(radius),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(child: Text('Task have change, please save')),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                              backgroundColor: hasUpdate
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ),
                            onPressed: () {
                              if (hasUpdate) {
                                _bloc(context).add(OnSubmit());
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Save'),
                            )),
                      )
                    ],
                  ),
                ),
              ))
          : null,
    );
  }
}
