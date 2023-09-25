part of 'task_view.dart';

enum _ScrollDerection { none, left, right }

class _TaskBoardView extends StatefulWidget {
  const _TaskBoardView();

  @override
  State<_TaskBoardView> createState() => _TaskBoardViewState();
}

class _TaskBoardViewState extends State<_TaskBoardView> {
  final controller = ScrollController();
  static const double _widthColumn = 350;
  _ScrollDerection derection = _ScrollDerection.none;

  final Stream stream = Stream.periodic(const Duration(milliseconds: 30));
  late StreamSubscription subStream;
  late double width = MediaQuery.of(context).size.width;

  @override
  void initState() {
    subStream = stream.listen((event) {
      switch (derection) {
        case _ScrollDerection.none:
          break;
        case _ScrollDerection.left:
          if (controller.offset > 0) {
            controller.animateTo(controller.offset - width * 0.01,
                duration: const Duration(milliseconds: 20), curve: Curves.linear);
          }
          break;
        case _ScrollDerection.right:
          if (controller.offset < controller.position.maxScrollExtent) {
            controller.animateTo(controller.offset + width * 0.01,
                duration: const Duration(milliseconds: 20), curve: Curves.linear);
          }
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    subStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = context.select((TaskBloc bloc) => bloc.state.filteredTasks);
    return SliverPadding(
      padding: const EdgeInsets.only(top: defaultPadding, bottom: defaultPadding),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 205,
          width: double.infinity,
          child: Stack(
            children: [
              Scrollbar(
                controller: controller,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 15),
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: TaskStatus.values.map((e) {
                      final List<TaskUi> tasks =
                          filteredTasks.where((element) => element.task.status == e).toList();
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: DragTarget<TaskUi>(onAccept: (data) {
                          if (data.task.status != e) {
                            _bloc(context).add(OnChangeTaskStatus(data, e));
                          }
                        }, builder: (context, items, _) {
                          return Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(radius),
                                color: e.color.withOpacity(0.1),
                              ),
                              width: _widthColumn,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child:
                                        TaskBoardStatusHeader(status: e, tasksCount: tasks.length),
                                  ),
                                  if (items.isNotEmpty && items.first?.task.status != e)
                                    SizedBox(
                                      width: _widthColumn,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: TaskBoardCard(
                                            color: Theme.of(context).cardColor.withOpacity(0.8),
                                            item: items.first!,
                                            onTap: () {}),
                                      ),
                                    ),
                                  Expanded(
                                    child: ListView.builder(
                                        padding: const EdgeInsets.all(10),
                                        itemCount: tasks.length,
                                        itemBuilder: (context, index) {
                                          final item = tasks[index];
                                          return Draggable<TaskUi>(
                                            data: item,
                                            feedback: Theme(
                                              data: Theme.of(context),
                                              child: SizedBox(
                                                  width: _widthColumn,
                                                  child: TaskBoardCard(item: item, onTap: () {})),
                                            ),
                                            childWhenDragging: TaskBoardCard(
                                                color: Theme.of(context).cardColor.withOpacity(0.8),
                                                item: item,
                                                onTap: () {}),
                                            child: TaskBoardCard(
                                              item: item,
                                              onTap: () => _bloc(context).add(
                                                OnTaskTap(item.task.id!),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ));
                        }),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MouseRegion(
                    onEnter: (_) {
                      derection = _ScrollDerection.left;
                    },
                    onExit: (_) {
                      derection = _ScrollDerection.none;
                    },
                    child: const SizedBox(
                      width: 100,
                      height: double.infinity,
                    ),
                  ),
                  MouseRegion(
                    onEnter: (_) {
                      derection = _ScrollDerection.right;
                    },
                    onExit: (_) {
                      derection = _ScrollDerection.none;
                    },
                    child: const SizedBox(
                      width: 100,
                      height: double.infinity,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
