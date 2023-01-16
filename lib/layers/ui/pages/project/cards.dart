import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/models/task_percent.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class TaskStatusHeader extends StatelessWidget {
  const TaskStatusHeader({
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
            padding: const EdgeInsets.only(bottom: 10, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status!.label,
                  style: const TextStyle(fontSize: 20),
                ),
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
          )
        else
          const SizedBox(),
        child
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard(this.task, this.onTap, {this.user});
  final Task task;
  final User? user;
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
                    borderRadius: const BorderRadius.all(radius), color: task.status.color),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(task.title, maxLines: 2, style: const TextStyle(fontSize: 16))),
              const SizedBox(width: 20),
              if (user != null)
                Tooltip(
                  showDuration: const Duration(milliseconds: 0),
                  message: user!.name,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(user!.color),
                    child: Text(
                      user!.initials,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              else
                const SizedBox(),
              const SizedBox(width: 20),
              SizedBox(
                  width: 80,
                  child: Text(
                      '${task.dueDate.day} ${monthLabel(task.dueDate.month)} ${task.dueDate.year}'))
            ],
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  const UserCard(this.user, this.onRemove, this.tasks, {this.isOwner = false});
  final List<Task> tasks;
  final User user;
  final bool isOwner;
  final VoidCallback onRemove;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  List<TaskPercent> percents = [];
  @override
  void initState() {
    for (final status in TaskStatus.values) {
      final count = widget.tasks
          .where((element) => element.status == status && element.assignerId == widget.user.id)
          .length;
      if (count > 0) {
        final percent = count / widget.tasks.length * 100;
        percents.add(TaskPercent(percent: percent.toDouble(), status: status, taskCount: count));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            leading: CircleAvatar(backgroundColor: Color(widget.user.color)),
            minLeadingWidth: 10,
            title: SelectableText(widget.user.name),
            subtitle: SelectableText(widget.user.email),
            trailing: widget.isOwner
                ? Card(
                    color: Theme.of(context).backgroundColor,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Owner'),
                    ),
                  )
                : IconButton(onPressed: widget.onRemove, icon: const Icon(Icons.close)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(radius),
              child: SizedBox(
                height: 10,
                width: double.infinity,
                child: percents.isEmpty
                    ? Container(color: Theme.of(context).disabledColor)
                    : Row(
                        children: percents
                            .map((e) => Flexible(
                                flex: e.percent.round(),
                                child: Tooltip(
                                    message: e.taskCount.toString(),
                                    child: Container(color: e.status.color))))
                            .toList(),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
