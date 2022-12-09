import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/ui/loader.dart';
import 'package:task_me_flutter/layers/bloc/project.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/project/info_view.dart';
import 'package:task_me_flutter/layers/ui/pages/project/task_view.dart';
import 'package:task_me_flutter/layers/ui/pages/project/user_view.dart';
import 'package:task_me_flutter/layers/ui/pages/task_page.dart';
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
  late final TabController tabController = TabController(length: 3, vsync: this)
    ..addListener(() {
      switch (tabController.index) {
        case 0:
          _bloc(context).setPageState(ProjectPageState.tasks);
          break;
        case 1:
          _bloc(context).setPageState(ProjectPageState.users);
          break;
        case 2:
          _bloc(context).setPageState(ProjectPageState.info);
          break;
        default:
          _bloc(context).setPageState(ProjectPageState.tasks);
      }
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
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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
                      Tab(text: 'Info'),
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
        if (widget.state.pageState == ProjectPageState.tasks)
          TasksProjectView(widget.state)
        else if (widget.state.pageState == ProjectPageState.users)
          UserProjectView(widget.state)
        else
          InfoProjectView(widget.state)
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
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
              TaskPage.route(context, state.project!.id!);
              break;
            case ProjectPageState.users:
              break;
            case ProjectPageState.info:
              break;
          }
        },
        child: Text(state.pageState == ProjectPageState.tasks
            ? 'Create task'
            : state.pageState == ProjectPageState.users
                ? 'Invite user'
                : 'Edit project'),
      );
    });
  }
}
