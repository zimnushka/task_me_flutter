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
      _bloc(context).add(OnDescriptionUpdate(text));
    });

    statusWidgets.addAll(
        TaskStatus.values.map((e) => PopupMenuItem(value: e, child: _PopUpStatusCard(e))).toList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasUpdate = widget.state.task != widget.state.editedTask;

    return Scaffold(
      body: Align(
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
                        Text('Task ${widget.state.task!.id!}',
                            style: const TextStyle(fontSize: 20)),
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
                  PopupMenuButton(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
                    tooltip: '',
                    onSelected: (value) => _bloc(context).add(OnTaskStatusSwap(value)),
                    itemBuilder: (context) => statusWidgets,
                    child: _StatusCard(widget.state.editedTask.status),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_context) {
                            return MultiSelector<User>(
                                title: 'Select assigners',
                                onChange: (newList) {
                                  final activeUsers =
                                      newList.where((e) => e.isActive).map((e) => e.value).toList();
                                  _bloc(context).add(OnUserListChange(activeUsers));
                                  Navigator.pop(_context);
                                },
                                items: widget.state.users.map((e) {
                                  return MultiSelectItem(
                                      isActive: widget.state.assigners.contains(e),
                                      value: e,
                                      child: _UserCard(e));
                                }).toList());
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
                onChanged: (value) => _bloc(context).add(OnTitleUpdate(value)),
                readOnly: widget.state.task?.status == TaskStatus.closed,
                decoration: InputDecoration(fillColor: Theme.of(context).cardColor),
                controller: nameController,
              ),
              const SizedBox(height: 20),
              const Text('Description'),
              const SizedBox(height: 10),
              quil.QuillToolbar.basic(
                iconTheme:
                    quil.QuillIconTheme(iconSelectedFillColor: Theme.of(context).primaryColor),
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
                    borderRadius: const BorderRadius.all(radius),
                    color: Theme.of(context).cardColor),
                child: quil.QuillEditor(
                  focusNode: focusNode,
                  scrollController: scrollController,
                  scrollable: true,
                  padding: const EdgeInsets.all(15),
                  autoFocus: false,
                  expands: true,
                  controller: descController,
                  readOnly:
                      widget.state.task?.status == TaskStatus.closed, // true for view only mode
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: hasUpdate
          ? PreferredSize(
              preferredSize: const Size(double.infinity, 70),
              child: SlideAnimatedContainer(
                replayInBuild: false,
                start: const Offset(0, 1),
                end: Offset.zero,
                duration: const Duration(seconds: 1),
                curve: Curves.elasticOut,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 10),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(radius),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(child: Text('Task have change, please save')),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                              backgroundColor: hasUpdate
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ),
                            onPressed: () {
                              if (hasUpdate) {
                                _bloc(context).add(OnSubmit());
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Save'),
                            )),
                      )
                    ],
                  ),
                ),
              ))
          : null,
    );
  }
}
