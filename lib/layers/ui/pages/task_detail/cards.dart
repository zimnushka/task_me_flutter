part of 'task_detail.dart';

class _StatusCard extends StatelessWidget {
  const _StatusCard(this.status);
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: const BorderRadius.all(radius),
      ),
      height: 40,
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: Center(
        child: Text(
          status.label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _PopUpStatusCard extends StatelessWidget {
  const _PopUpStatusCard(this.status);
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration:
              BoxDecoration(borderRadius: const BorderRadius.all(radius), color: status.color),
        ),
        const SizedBox(width: 10),
        Text(status.label),
      ],
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: user.color),
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  }
}

class _TaskIDCard extends StatelessWidget {
  const _TaskIDCard(this.taskId);
  final int? taskId;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(radius),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: AppRouter.pop,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border(
                      right:
                          BorderSide(width: 2, color: Theme.of(context).colorScheme.background))),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(taskId == null ? 'Task creation' : 'Task $taskId',
                style: const TextStyle(fontSize: 20)),
          ),
          if (taskId != null)
            GestureDetector(
              onTap: () => _bloc(context).add(OnDeleteTask()),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border(
                        left:
                            BorderSide(width: 2, color: Theme.of(context).colorScheme.background))),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TaskTitleEditor extends StatefulWidget {
  const _TaskTitleEditor({
    required this.initValue,
    required this.readOnly,
    required this.onChanged,
  });

  final Function(String) onChanged;
  final String initValue;
  final bool readOnly;

  @override
  State<_TaskTitleEditor> createState() => _TaskTitleEditorState();
}

class _TaskTitleEditorState extends State<_TaskTitleEditor> {
  final nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppText('Title'),
        const SizedBox(height: 10),
        TextField(
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          decoration: InputDecoration(fillColor: Theme.of(context).cardColor),
          controller: nameController,
        ),
      ],
    );
  }
}

class _TaskDescriptionEditor extends StatefulWidget {
  const _TaskDescriptionEditor({
    required this.initValue,
    required this.onChanged,
    required this.readOnly,
  });
  final Function(String) onChanged;
  final String initValue;
  final bool readOnly;

  @override
  State<_TaskDescriptionEditor> createState() => __TaskDescriptionEditorState();
}

class __TaskDescriptionEditorState extends State<_TaskDescriptionEditor> {
  late final quil.QuillController descController;
  final scrollController = ScrollController();
  final focusNode = FocusNode();

  @override
  void initState() {
    try {
      descController = quil.QuillController(
        document: widget.initValue != ''
            ? quil.Document.fromJson(jsonDecode(widget.initValue))
            : quil.Document(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      descController = quil.QuillController.basic();
    }
    if (widget.readOnly) {
      descController.addListener(focusNode.unfocus);
    } else {
      descController.addListener(() {
        final text = jsonEncode(descController.document.toDelta().toJson());
        widget.onChanged(text);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppText('Description'),
        if (!widget.readOnly)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: quil.QuillToolbar.basic(
              iconTheme: quil.QuillIconTheme(iconSelectedFillColor: Theme.of(context).primaryColor),
              controller: descController,
              showSearchButton: false,
              showFontFamily: false,
              showFontSize: false,
              showHeaderStyle: false,
              showRedo: false,
              showUndo: false,
            ),
          ),
        const SizedBox(height: 10),
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(radius), color: Theme.of(context).cardColor),
          child: quil.QuillEditor(
            focusNode: focusNode,
            scrollController: scrollController,
            scrollable: true,
            padding: const EdgeInsets.all(15),
            autoFocus: false,
            expands: true,
            controller: descController,
            readOnly: widget.readOnly,
          ),
        ),
      ],
    );
  }
}

class _TaskStatusSelector extends StatefulWidget {
  const _TaskStatusSelector({
    required this.value,
    required this.onChanged,
    required this.readOnly,
  });
  final Function(TaskStatus) onChanged;
  final TaskStatus value;
  final bool readOnly;

  @override
  State<_TaskStatusSelector> createState() => __TaskStatusSelectorState();
}

class __TaskStatusSelectorState extends State<_TaskStatusSelector> {
  final List<PopupMenuItem<TaskStatus>> statusWidgets = [];
  @override
  void initState() {
    statusWidgets.addAll(
        TaskStatus.values.map((e) => PopupMenuItem(value: e, child: _PopUpStatusCard(e))).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.readOnly) {
      return _StatusCard(widget.value);
    }
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
      tooltip: '',
      onSelected: widget.onChanged,
      itemBuilder: (context) => statusWidgets,
      child: _StatusCard(widget.value),
    );
  }
}
