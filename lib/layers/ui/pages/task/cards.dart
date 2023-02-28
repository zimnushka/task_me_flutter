import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/multi_user_show.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class TaskListStatusHeader extends StatelessWidget {
  const TaskListStatusHeader({
    required this.child,
    required this.isShow,
    this.status,
    this.onTap,
  });
  final TaskStatus? status;
  final bool isShow;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTitleText(status!.label),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: status!.color.withOpacity(0.2),
                      foregroundColor: status!.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(radius),
                        side: BorderSide(
                          width: 1,
                          color: status!.color,
                        ),
                      )),
                  onPressed: onTap,
                  child: Icon(isShow ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                )
              ],
            ),
          ),
        child
      ],
    );
  }
}

class TaskBoardStatusHeader extends StatelessWidget {
  const TaskBoardStatusHeader({required this.status, required this.tasksCount});
  final TaskStatus status;
  final int tasksCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTitleText(status.label),
        DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: AppText(tasksCount.toString()),
            )),
      ],
    );
  }
}

class TaskListCard extends StatelessWidget {
  const TaskListCard({required this.item, required this.onTap, required this.onStatusCnange});
  final TaskUi item;
  final VoidCallback onTap;
  final Function(TaskStatus) onStatusCnange;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(7, 7, 10, 7),
        child: Row(
          children: [
            _TaskStatusSelector(
              value: item.task.status,
              onChanged: onStatusCnange,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                  onTap: onTap,
                  child: Row(children: [
                    Expanded(child: AppText(item.task.title)),
                    const SizedBox(width: defaultPadding),
                    MultiUserShow(item.users),
                    const SizedBox(width: defaultPadding),
                    SizedBox(
                        width: 80,
                        child: AppText(
                            '${item.task.startDate.day} ${monthLabel(item.task.startDate.month)} ${item.task.startDate.year}'))
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskBoardCard extends StatelessWidget {
  const TaskBoardCard({required this.item, required this.onTap, this.color, super.key});
  final TaskUi item;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        margin: const EdgeInsets.only(bottom: 5),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                item.task.title,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 5),
              AppSmallText(
                  '${item.task.startDate.day} ${monthLabel(item.task.startDate.month)} ${item.task.startDate.year}'),
              if (item.users.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: MultiUserShow(item.users),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopUpStatusCard extends StatelessWidget {
  const _PopUpStatusCard(this.status);
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration:
              BoxDecoration(borderRadius: const BorderRadius.all(radius), color: status.color),
        ),
        const SizedBox(width: 10),
        Text(status.label),
      ],
    );
  }
}

class _TaskStatusSelector extends StatefulWidget {
  const _TaskStatusSelector({
    required this.value,
    required this.onChanged,
  });
  final Function(TaskStatus) onChanged;
  final TaskStatus value;

  @override
  State<_TaskStatusSelector> createState() => __TaskStatusSelectorState();
}

class __TaskStatusSelectorState extends State<_TaskStatusSelector> {
  final List<PopupMenuItem<TaskStatus>> statusWidgets = [];
  @override
  void initState() {
    statusWidgets.addAll(
        TaskStatus.values.map((e) => PopupMenuItem(value: e, child: _PopUpStatusCard(e))).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
      tooltip: '',
      onSelected: widget.onChanged,
      itemBuilder: (context) => statusWidgets,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)), color: widget.value.color),
      ),
    );
  }
}
