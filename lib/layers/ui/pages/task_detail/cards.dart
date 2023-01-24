import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class TaskDetailTaskStatusCard extends StatelessWidget {
  const TaskDetailTaskStatusCard(this.status);
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: status.color),
      title: Text(status.label),
    );
  }
}

class TaskDetailUserButton extends StatelessWidget {
  const TaskDetailUserButton(this.user);
  final User? user;

  @override
  Widget build(BuildContext context) {
    return user != null
        ? ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundColor: Color(user!.color)),
            title: Text(user!.name),
            subtitle: Text(user!.email),
          )
        : const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Without assigner'),
          );
  }
}