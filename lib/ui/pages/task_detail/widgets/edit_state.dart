part of '../task_detail.dart';

class _TaskEditView extends StatefulWidget {
  const _TaskEditView();

  @override
  State<_TaskEditView> createState() => __TaskEditViewState();
}

class __TaskEditViewState extends State<_TaskEditView> {
  final List<PopupMenuItem<User?>> userWidgets = [];

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TaskDetailVM>();
    final task = context.select((TaskDetailVM vm) => vm.task);
    final editedTask = context.select((TaskDetailVM vm) => vm.editedTask);
    final assigners = context.select((TaskDetailVM vm) => vm.assigners);
    final users = context.select((TaskDetailVM vm) => vm.users);

    final hasUpdate = task != editedTask;

    return Scaffold(
      body: Align(
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
                  const SizedBox(width: defaultPadding),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return MultiSelector<User>(
                                title: 'Select assigners',
                                onChange: (newList) {
                                  final activeUsers =
                                      newList.where((e) => e.isActive).map((e) => e.value).toList();
                                  vm.onUserSwap(activeUsers);
                                  Navigator.pop(context);
                                },
                                items: users.map((e) {
                                  return MultiSelectItem(
                                      isActive: assigners.contains(e),
                                      value: e,
                                      child: _UserCard(e));
                                }).toList());
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
                readOnly: false,
                onChanged: vm.onTitleUpdate,
              ),
              const SizedBox(height: defaultPadding),
              _TaskDescriptionEditor(
                initValue: editedTask.description,
                onChanged: vm.onDescriptionUpdate,
                readOnly: false,
              ),
              const SizedBox(height: defaultPadding),
              if (!hasUpdate) const AppText('Time intervals'),
              const SizedBox(height: 10),
              if (!hasUpdate) TaskIntervalsView(taskId: editedTask.id!)
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
                                vm.save();
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
