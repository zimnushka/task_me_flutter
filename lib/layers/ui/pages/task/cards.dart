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
  const TaskListCard(this.item, this.onTap);
  final TaskUi item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7, 7, 10, 7),
          child: Row(
            children: [
              Container(
                width: 7,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(radius), color: item.task.status.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(item.task.title, maxLines: 2, style: const TextStyle(fontSize: 16))),
              const SizedBox(width: defaultPadding),
              MultiUserShow(item.users),
              const SizedBox(width: defaultPadding),
              SizedBox(
                  width: 80,
                  child: Text(
                      '${item.task.startDate.day} ${monthLabel(item.task.startDate.month)} ${item.task.startDate.year}'))
            ],
          ),
        ),
      ),
    );
  }
}

class TaskBoardCard extends StatelessWidget {
  const TaskBoardCard({required this.item, required this.onTap, super.key});
  final TaskUi item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
