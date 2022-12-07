import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/app/service/snackbar.dart';
import 'package:task_me_flutter/app/ui/loader.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/task.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({
    required this.projectId,
    this.taskId,
    super.key,
  });
  final int projectId;
  final int? taskId;

  static void route(BuildContext context, int projectId, {int? taskId}) => context.goNamed('task',
      params: {'taskId': taskId.toString()}, queryParams: {'projectId': projectId.toString()});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskApiRepository repository = TaskApiRepository();
  final UserApiRepository userApiRepository = UserApiRepository();
  final List<User> users = [];

  Future<Task?> load() async {
    users.addAll((await userApiRepository.getUserFromProject(widget.projectId)).data ?? []);
    if (widget.taskId != null) {
      return (await repository.getById(widget.taskId!)).data;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _Body(
            projectId: widget.projectId,
            task: snapshot.data,
            users: users,
          );
        } else {
          return AppLoadingIndecator();
        }
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.projectId,
    required this.users,
    this.task,
  });
  final int projectId;
  final Task? task;
  final List<User> users;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
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
          cost: widget.task!.cost,
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
          cost: 0,
        ),
      );
    }
    AppSnackBar.show(context, 'Saved', AppSnackBarType.success);
  }

  Future<void> delete() async {
    await repository.delete(widget.task!.id!);
    Navigator.pop(context);
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
    return Column(
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
        Wrap(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: PopupMenuButton(
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
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: PopupMenuButton(
                  itemBuilder: (context) {
                    return widget.users
                        .map((e) => PopupMenuItem(
                              value: e,
                              child: _UserButton(e),
                            ))
                        .toList();
                  },
                  child: _TaskStatusButton(status),
                ),
              ),
            ),
          ],
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(maximumSize: const Size(300, 40)),
            onPressed: save,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(widget.task != null ? 'Save' : 'Add'),
            )),
        const SizedBox(height: 10),
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

class _UserButton extends StatelessWidget {
  const _UserButton(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 25,
          height: 25,
          decoration:
              BoxDecoration(borderRadius: const BorderRadius.all(radius), color: Color(user.color)),
        ),
        const SizedBox(width: 20),
        Text(user.name),
      ],
    );
  }
}
