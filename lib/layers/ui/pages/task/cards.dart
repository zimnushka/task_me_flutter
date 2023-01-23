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
  const TaskCard(this.item, this.onTap);
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
              const SizedBox(width: 20),
              if (item.user != null)
                Tooltip(
                  showDuration: const Duration(milliseconds: 0),
                  message: item.user!.name,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(item.user!.color),
                    child: Text(
                      item.user!.initials,
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
                      '${item.task.dueDate.day} ${monthLabel(item.task.dueDate.month)} ${item.task.dueDate.year}'))
            ],
          ),
        ),
      ),
    );
  }
}