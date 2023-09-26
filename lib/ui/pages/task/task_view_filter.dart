part of 'task_view.dart';

class TaskViewFilter extends StatefulWidget {
  const TaskViewFilter({
    required this.onChangeView,
    this.taskViewStateSwitch = true,
    super.key,
  });
  final Function(TaskViewState) onChangeView;
  final bool taskViewStateSwitch;

  @override
  State<TaskViewFilter> createState() => TaskViewFilterState();
}

class TaskViewFilterState extends State<TaskViewFilter> with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        final vm = context.read<TaskVM>();
        switch (tabController.index) {
          case 0:
            widget.onChangeView(TaskViewState.list);
            vm.onChangeViewState(TaskViewState.list);
            break;
          case 1:
            widget.onChangeView(TaskViewState.board);
            vm.onChangeViewState(TaskViewState.board);
            break;
          default:
            vm.onChangeViewState(TaskViewState.list);
        }

        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TaskVM>();
    final taskView = context.select((TaskVM vm) => vm.state);
    final filter = context.select((TaskVM vm) => vm.filter);

    if (taskView == TaskViewState.list && tabController.index == 1) {
      tabController.animateTo(0);
    }
    if (taskView == TaskViewState.board && tabController.index == 0) {
      tabController.animateTo(1);
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                  onChanged: (text) {
                    vm.onTaskFilterChange(filter.copyWith(text: text));
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      hintText: 'Search',
                      fillColor: Theme.of(context).cardColor)),
            ),
            if (widget.taskViewStateSwitch)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(radius),
                      color: Theme.of(context).cardColor),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TabBar(
                      isScrollable: true,
                      controller: tabController,
                      indicator: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        borderRadius: const BorderRadius.all(radius),
                      ),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                TaskViewState.list.icon,
                                size: 14,
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                              if (tabController.index == 0)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: AppText(
                                    TaskViewState.list.label,
                                    color: Theme.of(context).textTheme.bodyMedium!.color,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                TaskViewState.board.icon,
                                size: 14,
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                              if (tabController.index == 1)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: AppText(
                                    TaskViewState.board.label,
                                    color: Theme.of(context).textTheme.bodyMedium!.color,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
