import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
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
  const TaskCard(
    this.task,
    this.onTap,
  );
  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: Container(
          width: 7,
          height: 30,
          decoration:
              BoxDecoration(borderRadius: const BorderRadius.all(radius), color: task.status.color),
        ),
        minLeadingWidth: 10,
        title: Text(task.title),
        trailing:
            Text('${task.dueDate.day} ${monthLabel(task.dueDate.month)} ${task.dueDate.year}'),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard(
    this.user,
    this.isOwner,
  );
  final User user;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: CircleAvatar(backgroundColor: Color(user.color)),
        minLeadingWidth: 10,
        title: Text('${user.name}${isOwner ? ' . owner' : ''}'),
        subtitle: Text(user.email),
      ),
    );
  }
}
