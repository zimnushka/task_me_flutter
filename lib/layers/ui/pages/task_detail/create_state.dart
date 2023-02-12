part of 'task_detail.dart';

class _TaskCreateView extends StatefulWidget {
  const _TaskCreateView(this.state);
  final TaskDetailState state;

  @override
  State<_TaskCreateView> createState() => __TaskCreateViewState();
}

class __TaskCreateViewState extends State<_TaskCreateView> {
  final nameController = TextEditingController();
  late final quil.QuillController descController;
  final scrollController = ScrollController();
  final focusNode = FocusNode();
  final List<PopupMenuItem<TaskStatus>> statusWidgets = [];

  @override
  void initState() {
    descController = quil.QuillController.basic()
      ..addListener(() {
        final text = jsonEncode(descController.document.toDelta().toJson());
        _bloc(context).add(OnDescriptionUpdate(text));
      });

    statusWidgets.addAll(
        TaskStatus.values.map((e) => PopupMenuItem(value: e, child: _StatusCard(e))).toList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
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
              readOnly: widget.state.task?.status == TaskStatus.closed,
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
              showRedo: false,
              showUndo: false,
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
                readOnly: widget.state.task?.status == TaskStatus.closed, // true for view only mode
              ),
            ),
            const SizedBox(height: 10),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: PopupMenuButton(
                      tooltip: '',
                      onSelected: (value) => _bloc(context).add(OnTaskStatusSwap(value)),
                      itemBuilder: (context) => statusWidgets,
                      child: _StatusCard(widget.state.editedTask.status),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () => _bloc(context).add(OnSubmit()),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Create'),
                        )),
                  ),
                ])
          ],
        ),
      ),
    );
  }
}
