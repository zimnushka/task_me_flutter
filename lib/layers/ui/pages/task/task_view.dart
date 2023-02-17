import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/task/task_bloc.dart';
import 'package:task_me_flutter/layers/bloc/task/task_event.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/task/cards.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

part 'task_list_view.dart';
part 'task_board_view.dart';

TaskBloc _bloc(BuildContext context) => BlocProvider.of(context);

class TasksProjectView extends StatefulWidget {
  final List<TaskUi> tasks;
  final Function(int) onTaskTap;

  const TasksProjectView({required this.tasks, required this.onTaskTap});

  @override
  State<TasksProjectView> createState() => _TasksProjectViewState();
}

class _TasksProjectViewState extends State<TasksProjectView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskBloc(widget.onTaskTap, widget.tasks),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        switch (tabController.index) {
          case 0:
            _bloc(context).add(OnChangeViewState(TaskViewState.list));
            break;
          case 1:
            _bloc(context).add(OnChangeViewState(TaskViewState.board));
            break;
          default:
            _bloc(context).add(OnChangeViewState(TaskViewState.list));
        }
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<TaskBloc>(builder: (s, context) {
      final state = s as TaskState;
      return CustomScrollView(
        slivers: [
          if (state.tasks.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                height: 100,
                margin: const EdgeInsets.only(top: defaultPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(radius),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        children: [
                          SfCircularChart(
                            borderWidth: 0,
                            series: <CircularSeries>[
                              DoughnutSeries<TaskStatus, String>(
                                radius: '100%',
                                innerRadius: '80%',
                                dataSource: TaskStatus.values,
                                pointColorMapper: (data, index) => data.color,
                                xValueMapper: (data, _) => data.label,
                                yValueMapper: (data, _) =>
                                    state.tasks
                                        .where((element) => element.task.status == data)
                                        .length /
                                    state.tasks.length *
                                    100,
                              )
                            ],
                          ),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppTitleText(
                                  (state.tasks
                                              .where((element) =>
                                                  element.task.status == TaskStatus.closed)
                                              .length /
                                          state.tasks.length *
                                          100)
                                      .ceil()
                                      .toString(),
                                ),
                                const AppSmallText('%')
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextField(decoration: InputDecoration(hintText: 'Search')),
                          SizedBox(
                            height: 25,
                            child: TabBar(
                              isScrollable: true,
                              controller: tabController,
                              indicatorColor: Theme.of(context).primaryColor,
                              indicatorWeight: 3,
                              tabs: [
                                Tab(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.sort,
                                        size: 14,
                                        color: Theme.of(context).textTheme.bodyMedium!.color,
                                      ),
                                      const SizedBox(width: 10),
                                      AppText(
                                        'List',
                                        color: Theme.of(context).textTheme.bodyMedium!.color,
                                      ),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.auto_awesome_mosaic_outlined,
                                        size: 14,
                                        color: Theme.of(context).textTheme.bodyMedium!.color,
                                      ),
                                      const SizedBox(width: 10),
                                      AppText(
                                        'Board',
                                        color: Theme.of(context).textTheme.bodyMedium!.color,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          if (state.state == TaskViewState.list) _TaskListView(state) else _TaskBoardView(state)
        ],
      );
    });
  }
}
