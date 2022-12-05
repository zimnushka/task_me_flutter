import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/task.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class TaskDialog extends StatefulWidget {
  const TaskDialog({
    required this.projectId,
    required this.users,
    required this.onUpdate,
    this.task,
    super.key,
  });
  final Task? task;
  final int projectId;
  final List<User> users;
  final VoidCallback onUpdate;

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final repository = TaskApiRepository();

  final nameController = TextEditingController();
  final descController = TextEditingController();
  TaskStatus status = TaskStatus.open;

  Future<void> save() async {
    if (widget.task != null) {
      await repository.edit(
        Task(
          id: widget.task!.id,
          title: nameController.text,
          description: descController.text,
          projectId: widget.projectId,
          dueDate: widget.task!.dueDate,
          status: status,
        ),
      );
    } else {
      await repository.create(
        Task(
          title: nameController.text,
          description: descController.text,
          projectId: widget.projectId,
          dueDate: DateTime.now(),
          status: status,
        ),
      );
    }
    Navigator.pop(context);
    widget.onUpdate();
  }

  Future<void> delete() async {
    await repository.delete(widget.task!.id!);
    Navigator.pop(context);
    widget.onUpdate();
  }

  @override
  void initState() {
    nameController.text = widget.task?.title ?? '';
    descController.text = widget.task?.description ?? '';
    status = widget.task?.status ?? TaskStatus.open;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          width: 400,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  minLines: 10,
                  maxLines: 10,
                ),
                const SizedBox(height: 10),
                PopupMenuButton(
                  onSelected: (value) {
                    setState(() {
                      status = value;
                    });
                  },
                  itemBuilder: (context) {
                    return TaskStatus.values
                        .map((e) => PopupMenuItem(
                              value: e,
                              child: _TaskStatusButton(e),
                            ))
                        .toList();
                  },
                  child: _TaskStatusButton(status),
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                    onPressed: save,
                    child: Text(widget.task != null ? 'Save' : 'Add')),
                if (widget.task != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).errorColor,
                          ),
                          onPressed: delete,
                          child: const Text('Delete')),
                    ),
                  )
                else
                  const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskStatusButton extends StatelessWidget {
  const _TaskStatusButton(this.status);
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 25,
          height: 25,
          decoration:
              BoxDecoration(borderRadius: const BorderRadius.all(radius), color: status.color),
        ),
        const SizedBox(width: 20),
        Text(status.name),
      ],
    );
  }
}
