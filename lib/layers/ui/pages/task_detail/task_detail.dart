import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_bloc.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_event.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/task_detail/cards.dart';

TaskDetailBloc _bloc(BuildContext context) => BlocProvider.of(context);

class TaskRoute implements AppPage {
  final int projectId;
  final int? taskId;

  const TaskRoute(this.projectId, this.taskId);

  @override
  String get name => 'task';

  @override
  Map<String, String> get params => {'taskId': taskId.toString()};

  @override
  Map<String, String>? get queryParams => {'projectId': projectId.toString()};
}

class TaskPage extends StatelessWidget {
  const TaskPage({
    required this.projectId,
    this.taskId,
    super.key,
  });
  final int projectId;
  final int? taskId;

  static AppPage route(int projectId, {int? taskId}) => TaskRoute(projectId, taskId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskDetailBloc>(
      create: (_) => TaskDetailBloc()..add(Load(projectId: projectId, taskId: taskId)),
      child: const Padding(padding: EdgeInsets.all(20), child: _Body()),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<TaskDetailBloc>(builder: (state, context) {
      state as TaskDetailState;
      return _TaskEditedView(state);
    });
  }
}

class _TaskEditedView extends StatefulWidget {
  const _TaskEditedView(this.state);
  final TaskDetailState state;

  @override
  State<_TaskEditedView> createState() => __TaskEditedViewState();
}

class __TaskEditedViewState extends State<_TaskEditedView> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final List<PopupMenuItem<User?>> userWidgets = [];
  final List<PopupMenuItem<TaskStatus>> statusWidgets = [];

  @override
  void initState() {
    nameController.text = widget.state.editedTask.title;
    descController.text = widget.state.editedTask.description;
    userWidgets.add(PopupMenuItem(
      value: null,
      child: const TaskDetailUserButton(null),
      onTap: () => _bloc(context).add(OnUserSwap(null)),
    ));
    userWidgets.addAll(widget.state.users
        .map((e) => PopupMenuItem(value: e, child: TaskDetailUserButton(e)))
        .toList());

    statusWidgets.addAll(TaskStatus.values
        .map((e) => PopupMenuItem(value: e, child: TaskDetailTaskStatusCard(e)))
        .toList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasUpdate = widget.state.task != widget.state.editedTask;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.state.task?.id != null ? 'Task #${widget.state.task!.id!}' : 'Task creation',
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(height: 20),
        const Text('Title'),
        const SizedBox(height: 10),
        TextField(
          onChanged: (value) => _bloc(context).add(OnTitleUpdate(value)),
          readOnly: widget.state.task?.status == TaskStatus.done,
          controller: nameController,
        ),
        const SizedBox(height: 20),
        const Text('Description'),
        const SizedBox(height: 10),
        TextField(
          onChanged: (value) => _bloc(context).add(OnDescriptionUpdate(value)),
          readOnly: widget.state.task?.status == TaskStatus.done,
          controller: descController,
          minLines: 10,
          maxLines: 10,
        ),
        const SizedBox(height: 10),
        if (widget.state.task?.status != TaskStatus.done)
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
                    onSelected: (value) => _bloc(context).add(OnTaskStatusSwap(value)),
                    itemBuilder: (context) => statusWidgets,
                    child: TaskDetailTaskStatusCard(widget.state.editedTask.status),
                  ),
                ),
                const Divider(),
                const Text('Assigner'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: PopupMenuButton(
                    tooltip: '',
                    onSelected: (value) => _bloc(context).add(OnUserSwap(value)),
                    itemBuilder: (context) => userWidgets,
                    child: TaskDetailUserButton(widget.state.assigner),
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
                      onPressed: () =>
                          _bloc(context).add(OnSubmit(nameController.text, descController.text)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(widget.state.task?.id != null ? 'Save' : 'Add'),
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
                title: Text(widget.state.assigner?.name ?? 'Without assigner',
                    style: const TextStyle(fontSize: 18)),
                subtitle:
                    widget.state.assigner == null ? null : Text(widget.state.assigner?.email ?? ''),
              ),
              const Text('Status'),
              ListTile(
                contentPadding: const EdgeInsets.only(bottom: 20),
                title: Text(widget.state.task!.status.label, style: const TextStyle(fontSize: 18)),
              ),
              const Text('Total cost'),
              ListTile(
                contentPadding: const EdgeInsets.only(bottom: 20),
                title:
                    Text(widget.state.task!.cost.toString(), style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        if (widget.state.task?.id != null)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).errorColor,
                ),
                onPressed: () => _bloc(context).add(OnDeleteTask()),
                child: const Text('Delete task')),
          )
        else
          const SizedBox()
      ],
    );
  }
}
