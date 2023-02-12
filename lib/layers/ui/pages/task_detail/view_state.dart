part of 'task_detail.dart';

class _TaskView extends StatefulWidget {
  const _TaskView(this.state);
  final TaskDetailState state;

  @override
  State<_TaskView> createState() => __TaskViewState();
}

class __TaskViewState extends State<_TaskView> {
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
    descController.addListener(focusNode.unfocus);
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
            Row(
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(radius),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Task ${widget.state.task!.id!}', style: const TextStyle(fontSize: 20)),
                      Container(
                        height: 40,
                        width: 2,
                        color: Theme.of(context).backgroundColor,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      GestureDetector(
                        onTap: () => _bloc(context).add(OnDeleteTask()),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                _StatusCard(widget.state.editedTask.status),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_context) {
                          return Center(
                            child: Card(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 320, maxHeight: 500),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Assigners',
                                          style: Theme.of(context).textTheme.titleLarge),
                                      const SizedBox(height: 20),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: widget.state.assigners.length,
                                          itemBuilder: (context, index) {
                                            final item = widget.state.assigners[index];
                                            return _UserCard(item);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: widget.state.assigners.isEmpty
                      ? const Text('Without assigner', style: TextStyle(fontSize: 18))
                      : MultiUserShow(widget.state.assigners, radius: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Title'),
            const SizedBox(height: 10),
            TextField(
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
          ],
        ),
      ),
    );
  }
}
