part of 'task_detail.dart';

class _TaskDoneView extends StatefulWidget {
  const _TaskDoneView(this.state);
  final TaskDetailState state;

  @override
  State<_TaskDoneView> createState() => __TaskDoneViewState();
}

class __TaskDoneViewState extends State<_TaskDoneView> {
  final nameController = TextEditingController();
  late final quil.QuillController descController;
  final scrollController = ScrollController();
  final focusNode = FocusNode();

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
            Text('Task #${widget.state.task!.id!}', style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            const Text('Title'),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) => _bloc(context).add(OnTitleUpdate(value)),
              readOnly: true,
              decoration: InputDecoration(fillColor: Theme.of(context).cardColor),
              controller: nameController,
            ),
            const SizedBox(height: 20),
            const Text('Description'),
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
                readOnly: true, // true for view only mode
              ),
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Assigners'),
                if (widget.state.assigners.isEmpty)
                  const Text('Without assigner', style: TextStyle(fontSize: 18))
                else
                  Column(
                    children: widget.state.assigners
                        .map(
                          (e) => ListTile(
                            contentPadding: const EdgeInsets.only(bottom: 20),
                            title: Text(e.name, style: const TextStyle(fontSize: 18)),
                            subtitle: Text(e.email),
                          ),
                        )
                        .toList(),
                  ),
                const Text('Status'),
                ListTile(
                  contentPadding: const EdgeInsets.only(bottom: 20),
                  title:
                      Text(widget.state.task!.status.label, style: const TextStyle(fontSize: 18)),
                ),
                const Text('Total cost'),
                ListTile(
                  contentPadding: const EdgeInsets.only(bottom: 20),
                  title: Text(widget.state.task!.cost.toString(),
                      style: const TextStyle(fontSize: 18)),
                ),
              ],
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
