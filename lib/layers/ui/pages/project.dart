import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/ui/loader.dart';
import 'package:task_me_flutter/layers/bloc/project.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/task_dialog.dart';
import 'package:task_me_flutter/layers/ui/kit/slide_animation_container.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

ProjectCubit _bloc(BuildContext context) => BlocProvider.of(context);

class ProjectPage extends StatefulWidget {
  const ProjectPage(this.id, {super.key});
  final int id;

  static void route(BuildContext context, int projectId) =>
      context.goNamed('project', params: {'projectId': projectId.toString()});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  late final cubit = ProjectCubit(widget.id);
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: const _ProjectView(),
    );
  }
}

class _ProjectView extends StatefulWidget {
  const _ProjectView();

  @override
  State<_ProjectView> createState() => __ProjectViewState();
}

class __ProjectViewState extends State<_ProjectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProjectCubit, AppState>(builder: (context, state) {
        if (state is ProjectState && state.project != null) {
          return Theme(
            data: setPrimaryColor(Theme.of(context), Color(state.project!.color)),
            child: _Body(state),
          );
        }
        return const AppLoadingIndecator();
      }),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body(
    this.state,
  );
  final ProjectState state;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  late final TabController tabController = TabController(length: 2, vsync: this)
    ..addListener(() {
      _bloc(context)
          .setPageState(tabController.index == 0 ? ProjectPageState.tasks : ProjectPageState.users);
    });
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.state.project!.title),
          titleTextStyle: const TextStyle(fontSize: 25, color: Colors.white),
          centerTitle: false,
          pinned: true,
          snap: false,
          forceElevated: true,
          expandedHeight: 250,
          backgroundColor: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
          flexibleSpace: FlexibleSpaceBar(
            background: widget.state.tasks.isNotEmpty
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      width: 200,
                      height: 200,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 5,
                              centerSpaceRadius: 70,
                              sections: TaskStatus.values
                                  .map(
                                    (e) => PieChartSectionData(
                                        color: e.color,
                                        title: '',
                                        radius: 20,
                                        value: widget.state.tasks
                                                .where((element) => element.status == e)
                                                .length /
                                            widget.state.tasks.length *
                                            100),
                                  )
                                  .toList(),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('closed tasks',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: Theme.of(context).primaryColor)),
                                Text(
                                    widget.state.tasks
                                        .where((element) => element.status == TaskStatus.done)
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 40, color: Theme.of(context).primaryColor)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).primaryColor,
                    ),
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Tasks'),
                      Tab(text: 'Users'),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: _AddButton(),
                )
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (tabController.index == 0) _TasksView(widget.state) else _UsersView(widget.state)
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    final cubit = _bloc(context);
    return BlocBuilder<ProjectCubit, AppState>(builder: (context, state) {
      state as ProjectState;
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
        ),
        onPressed: () async {
          switch (state.pageState) {
            case ProjectPageState.tasks:
              await showDialog(
                context: context,
                builder: (context) {
                  return TaskDialog(
                    projectId: state.project!.id!,
                    users: state.users,
                    onUpdate: cubit.updateTasks,
                  );
                },
              );
              break;

            case ProjectPageState.users:
              break;
          }
        },
        child: Text(state.pageState == ProjectPageState.tasks ? 'Create task' : 'Invite user'),
      );
    });
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView(
    this.state,
  );
  final ProjectState state;

  @override
  Widget build(BuildContext context) {
    final cubit = _bloc(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: state.tasks.length,
        (context, index) {
          final item = state.tasks[index];
          TaskStatus? status;
          for (final statusElement in TaskStatus.values) {
            if (index == state.tasks.indexWhere((element) => element.status == statusElement)) {
              status = statusElement;
            }
          }
          final isShow = state.openedStatuses.contains(item.status);
          return _TaskStatusHeader(
            isShow: isShow,
            status: status,
            onTap: () {
              final newStats = [...state.openedStatuses];
              if (isShow) {
                newStats.remove(item.status);
                cubit.setOpenStatuses(newStats);
              } else {
                newStats.add(item.status);
                cubit.setOpenStatuses(newStats);
              }
            },
            child: isShow
                ? _TaskCard(item, () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return TaskDialog(
                          key: ValueKey(item.id),
                          projectId: state.project!.id!,
                          users: state.users,
                          task: item,
                          onUpdate: cubit.updateTasks,
                        );
                      },
                    );
                  })
                : const SizedBox(),
          );
        },
      ),
    );
  }
}

class _TaskStatusHeader extends StatelessWidget {
  const _TaskStatusHeader({
    required this.child,
    required this.isShow,
    this.status,
    this.onTap,
  });
  final TaskStatus? status;
  final bool isShow;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 20),
            child: Row(
              children: [
                Text(
                  status!.label,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: status!.color.withOpacity(0.2),
                      foregroundColor: status!.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(radius),
                        side: BorderSide(
                          width: 1,
                          color: status!.color,
                        ),
                      )),
                  onPressed: onTap,
                  child: Text(isShow ? 'Not show' : 'Show'),
                )
              ],
            ),
          )
        else
          const SizedBox(),
        child
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard(
    this.task,
    this.onTap,
  );
  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: Container(
          width: 7,
          height: 30,
          decoration:
              BoxDecoration(borderRadius: const BorderRadius.all(radius), color: task.status.color),
        ),
        minLeadingWidth: 10,
        title: Text(task.title),
        trailing:
            Text('${task.dueDate.day} ${monthLabel(task.dueDate.month)} ${task.dueDate.year}'),
      ),
    );
  }
}

class _UsersView extends StatelessWidget {
  const _UsersView(
    this.state,
  );
  final ProjectState state;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: state.users.length,
        (context, index) {
          final item = state.users[index];
          return SlideAnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOut,
              start: const Offset(1, 0),
              end: Offset.zero,
              child: _UserCard(item));
        },
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard(
    this.user,
  );
  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: CircleAvatar(backgroundColor: Color(user.color)),
        minLeadingWidth: 10,
        title: Text(user.name),
        subtitle: Text(user.email),
      ),
    );
  }
}
