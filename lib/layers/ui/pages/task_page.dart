import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/app/service/snackbar.dart';
import 'package:task_me_flutter/app/ui/loader.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/task.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/hour_selector.dart';

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
  Task? task;

  Future<bool> load() async {
    if (task == null) {
      users.addAll((await userApiRepository.getUserFromProject(widget.projectId)).data ?? []);
      if (widget.taskId != null) {
        task = (await repository.getById(widget.taskId!)).data;
        if (task == null) {
          AppSnackBar.show(context, 'Not found task', AppSnackBarType.error);
        }
      } else {
        task = null;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _Body(
            projectId: widget.projectId,
            task: task,
            users: users,
            onUpdate: (value) {
              setState(() {
                task = value;
              });
            },
          );
        } else {
          return const AppLoadingIndecator();
        }
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.projectId,
    required this.users,
    required this.onUpdate,
    this.task,
  });
  final int projectId;
  final Task? task;
  final List<User> users;
  final Function(Task?) onUpdate;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final repository = TaskApiRepository();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  TaskStatus status = TaskStatus.open;
  User? selectedUser;

  final List<PopupMenuItem<User?>> userWidgets = [];
  final List<PopupMenuItem<TaskStatus>> statusWidgets = [];

  Future<void> save() async {
    int hourCount = -1;
    if (status == TaskStatus.done) {
      await showDialog(
        context: context,
        builder: (context) {
          return SelectHourCountDialog(onSetHourCount: (value) {
            hourCount = value;
          });
        },
      );
      if (hourCount == -1) {
        return;
      }
    } else {
      hourCount = 0;
    }
    final task = Task(
      id: widget.task?.id,
      title: nameController.text,
      description: descController.text,
      projectId: widget.projectId,
      dueDate: widget.task?.dueDate ?? DateTime.now(),
      status: status,
      cost: selectedUser != null ? hourCount * selectedUser!.cost : 0,
      assignerId: selectedUser?.id,
    );

    if (widget.task != null) {
      await repository.edit(task);
    } else {
      await repository.create(task);
    }
    AppSnackBar.show(context, 'Saved', AppSnackBarType.success);
    widget.onUpdate(task);
  }

  Future<void> delete() async {
    await repository.delete(widget.task!.id!);
    widget.onUpdate(null);
  }

  @override
  void initState() {
    nameController.text = widget.task?.title ?? '';
    descController.text = widget.task?.description ?? '';
    status = widget.task?.status ?? TaskStatus.open;
    selectedUser = widget.task?.assignerId != null
        ? widget.users.firstWhere((element) => element.id == widget.task!.assignerId)
        : null;

    userWidgets.add(PopupMenuItem(
      value: null,
      child: const _UserButton(null),
      onTap: () {
        setState(() {
          selectedUser = null;
        });
      },
    ));
    userWidgets
        .addAll(widget.users.map((e) => PopupMenuItem(value: e, child: _UserButton(e))).toList());

    statusWidgets.addAll(TaskStatus.values
        .map((e) => PopupMenuItem(value: e, child: _TaskStatusButton(e)))
        .toList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTaskState = Task(
      title: nameController.text,
      description: descController.text,
      projectId: widget.projectId,
      status: status,
      assignerId: selectedUser?.id,
      dueDate: widget.task?.dueDate ?? DateTime.now(),
      cost: widget.task?.cost ?? 0,
      id: widget.task?.id ?? -1,
    );
    final hasUpdate = widget.task != currentTaskState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.task != null ? 'Task #${widget.task!.id}' : 'Task creation',
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(height: 20),
        const Text('Title'),
        const SizedBox(height: 10),
        TextField(
          onChanged: (value) {
            setState(() {});
          },
          readOnly: widget.task?.status == TaskStatus.done,
          controller: nameController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        const Text('Description'),
        const SizedBox(height: 10),
        TextField(
          onChanged: (value) {
            setState(() {});
          },
          readOnly: widget.task?.status == TaskStatus.done,
          controller: descController,
          minLines: 10,
          maxLines: 10,
        ),
        const SizedBox(height: 10),
        if (widget.task?.status != TaskStatus.done)
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Text('Status'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: PopupMenuButton(
                    tooltip: '',
                    onSelected: (value) {
                      setState(() {
                        status = value;
                      });
                    },
                    itemBuilder: (context) => statusWidgets,
                    child: _TaskStatusButton(status),
                  ),
                ),
                const Divider(),
                const Text('Assigner'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: PopupMenuButton(
                    tooltip: '',
                    onSelected: (value) {
                      setState(() {
                        selectedUser = value;
                      });
                    },
                    itemBuilder: (context) => userWidgets,
                    child: _UserButton(selectedUser),
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        backgroundColor: hasUpdate
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor,
                      ),
                      onPressed: save,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(widget.task != null ? 'Save' : 'Add'),
                      )),
                ),
              ])
        else
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Assigner'),
              ListTile(
                contentPadding: const EdgeInsets.only(bottom: 20),
                title: Text(selectedUser?.name ?? 'Without assigner',
                    style: const TextStyle(fontSize: 18)),
                subtitle: selectedUser == null ? null : Text(selectedUser?.email ?? ''),
              ),
              const Text('Status'),
              ListTile(
                contentPadding: const EdgeInsets.only(bottom: 20),
                title: Text(status.label, style: const TextStyle(fontSize: 18)),
              ),
              const Text('Total cost'),
              ListTile(
                contentPadding: const EdgeInsets.only(bottom: 20),
                title: Text(widget.task!.cost.toString(), style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        if (widget.task != null)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).errorColor,
                ),
                onPressed: delete,
                child: const Text('Delete task')),
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: status.color),
      title: Text(status.label),
    );
  }
}

class _UserButton extends StatelessWidget {
  const _UserButton(this.user);
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
