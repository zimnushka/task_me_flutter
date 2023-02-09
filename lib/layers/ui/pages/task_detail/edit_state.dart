part of 'task_detail.dart';

class _TaskEditView extends StatefulWidget {
  const _TaskEditView(this.state);
  final TaskDetailState state;

  @override
  State<_TaskEditView> createState() => __TaskEditViewState();
}

class __TaskEditViewState extends State<_TaskEditView> {
  final nameController = TextEditingController();
  late final quil.QuillController descController;
  final scrollController = ScrollController();
  final focusNode = FocusNode();
  final List<PopupMenuItem<User?>> userWidgets = [];
  final List<PopupMenuItem<TaskStatus>> statusWidgets = [];

  @override
  void initState() {
    nameController.text = widget.state.editedTask.title;

    try {
      descController = quil.QuillController(
        document: widget.state.editedTask.description != ''
            ? quil.Document.fromJson(jsonDecode(widget.state.editedTask.description))
            : quil.Document(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      descController = quil.QuillController.basic();
    }
    descController.addListener(() {
      final text = jsonEncode(descController.document.toDelta().toJson());
      _bloc(context).add(OnDescriptionUpdate(text.replaceAll(r'\n', r'\\n')));
    });

    statusWidgets.addAll(TaskStatus.values
        .map((e) => PopupMenuItem(value: e, child: TaskDetailTaskStatusCard(e)))
        .toList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasUpdate = widget.state.task != widget.state.editedTask;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task #${widget.state.task!.id!}', style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            const Text('Title'),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) => _bloc(context).add(OnTitleUpdate(value)),
              readOnly: widget.state.task?.status == TaskStatus.done,
              decoration: InputDecoration(fillColor: Theme.of(context).cardColor),
              controller: nameController,
            ),
            const SizedBox(height: 20),
            const Text('Description'),
            const SizedBox(height: 10),
            quil.QuillToolbar.basic(
              iconTheme: quil.QuillIconTheme(iconSelectedFillColor: Theme.of(context).primaryColor),
              controller: descController,
              showSearchButton: false,
              showFontFamily: false,
              showFontSize: false,
              showHeaderStyle: false,
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
                readOnly: widget.state.task?.status == TaskStatus.done, // true for view only mode
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: PopupMenuButton(
                        tooltip: '',
                        onSelected: (value) => _bloc(context).add(OnTaskStatusSwap(value)),
                        itemBuilder: (context) => statusWidgets,
                        child: TaskDetailTaskStatusCard(widget.state.editedTask.status),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Assigner'),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_context) {
                              return MultiSelector<User>(
                                  onChange: (newList) {
                                    final activeUsers = newList
                                        .where((e) => e.isActive)
                                        .map((e) => e.value)
                                        .toList();
                                    _bloc(context).add(OnUserListChange(activeUsers));
                                    Navigator.pop(_context);
                                  },
                                  items: widget.state.users.map((e) {
                                    return MultiSelectItem(
                                      isActive: widget.state.assigners.contains(e),
                                      value: e,
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.only(bottom: 20),
                                        title: Text(e.name, style: const TextStyle(fontSize: 18)),
                                        subtitle: Text(e.email),
                                      ),
                                    );
                                  }).toList());
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: widget.state.assigners.isEmpty
                            ? const Text('Without assigner', style: TextStyle(fontSize: 18))
                            : MultiUserShow(
                                widget.state.assigners,
                                radius: 20,
                                width: 120,
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
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
                  onPressed: () => _bloc(context).add(OnSubmit()),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Save'),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).errorColor,
                  ),
                  onPressed: () => _bloc(context).add(OnDeleteTask()),
                  child: const Text('Delete task')),
            )
          ],
        ),
      ),
    );
  }
}
