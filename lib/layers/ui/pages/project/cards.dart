import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/models/task_percent.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class UserCard extends StatefulWidget {
  const UserCard(this.user, this.onRemove, this.tasks, {this.isOwner = false});
  final List<TaskUi> tasks;
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
      final tasksWithStatus = widget.tasks.where((element) =>
          element.task.status == status &&
          element.users.where((element) => element.id == widget.user.id).isNotEmpty);
      final count = tasksWithStatus.length;

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
            leading: CircleAvatar(backgroundColor: widget.user.color),
            minLeadingWidth: 10,
            title: SelectableText(widget.user.name),
            subtitle: SelectableText(widget.user.email),
            trailing: widget.isOwner
                ? Card(
                    color: Theme.of(context).colorScheme.background,
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
