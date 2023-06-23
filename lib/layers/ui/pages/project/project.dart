import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/project/project_bloc.dart';
import 'package:task_me_flutter/layers/bloc/project/project_event.dart';
import 'package:task_me_flutter/layers/bloc/project/project_state.dart';
import 'package:task_me_flutter/layers/bloc/task/task_bloc.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/project/info_view.dart';
import 'package:task_me_flutter/layers/ui/pages/task/task_view.dart';
import 'package:task_me_flutter/layers/ui/pages/project/user_view.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

ProjectBloc _bloc(BuildContext context) => BlocProvider.of(context);

class ProjectRoute implements AppPage {
  final int projectId;

  const ProjectRoute(this.projectId);

  @override
  String get name => 'project';

  @override
  Map<String, String> get params => {'projectId': projectId.toString()};

  @override
  Map<String, String>? get queryParams => null;
}

class ProjectPage extends StatelessWidget {
  const ProjectPage(this.id, {super.key});
  final int id;

  static AppPage route(int projectId) => ProjectRoute(projectId);

  @override
  Widget build(BuildContext context) {
    final bloc = ProjectBloc()..add(Load(id));
    return BlocProvider.value(
      value: bloc,
      child: const _ProjectView(),
    );
  }
}

class _ProjectView extends StatelessWidget {
  const _ProjectView();

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<ProjectBloc>(
      builder: (state, context) {
        state as ProjectLoadedState;
        return Theme(
          data: setPrimaryColor(Theme.of(context), Color(state.project.color)),
          child: _Body(state),
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body(
    this.state,
  );
  final ProjectLoadedState state;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  late final appProvider = context.read<AppProvider>();
  late final User user = appProvider.state.user!;
  late final TabController tabController;
  late final TaskBloc _taskBloc = TaskBloc((id) => _bloc(context).add(OnTaskTap(id)),
      widget.state.tasks, appProvider.state.config.taskView);
  final tabs = [const Tab(text: 'Tasks'), const Tab(text: 'Users')];
  final controller = ScrollController();

  @override
  void initState() {
    if (user.id == widget.state.project.ownerId) {
      tabs.add(const Tab(text: 'Info'));
    }
    tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(() {
        switch (tabController.index) {
          case 0:
            _bloc(context).add(OnTabTap(ProjectPageState.tasks));
            break;
          case 1:
            _bloc(context).add(OnTabTap(ProjectPageState.users));
            break;
          case 2:
            _bloc(context).add(OnTabTap(ProjectPageState.info));
            break;
          default:
            _bloc(context).add(OnTabTap(ProjectPageState.tasks));
        }
      });

    super.initState();
  }

  bool isBoardOpen() {
    return widget.state.pageState == ProjectPageState.tasks &&
        _taskBloc.state is TaskState &&
        (_taskBloc.state as TaskState).state == TaskViewState.board;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: TasksViewProvider(
        bloc: _taskBloc,
        child: BlocBuilder<TaskBloc, AppState>(builder: (context, state) {
          return CustomScrollView(
            controller: controller,
            physics: isBoardOpen() ? const NeverScrollableScrollPhysics() : null,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 10),
                sliver: SliverAppBar(
                  automaticallyImplyLeading: false,
                  title: AppMainTitleText(widget.state.project.title),
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
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              width: 200,
                              height: 200,
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
                                            widget.state.tasks
                                                .where((element) => element.task.status == data)
                                                .length /
                                            widget.state.tasks.length *
                                            100,
                                      )
                                    ],
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
                                                .where((element) =>
                                                    element.task.status == TaskStatus.closed)
                                                .length
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 40,
                                                color: Theme.of(context).primaryColor)),
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
                            tabs: tabs,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => _bloc(context).add(OnHeaderButtonTap()),
                            child: Text(widget.state.pageState.headerButtonLabel),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.state.pageState == ProjectPageState.info) InfoProjectView(widget.state),
              if (widget.state.pageState == ProjectPageState.users) UserProjectView(widget.state),
              if (widget.state.pageState == ProjectPageState.tasks)
                TaskViewFilter(onChangeView: (view) async {
                  await Future.delayed(const Duration(milliseconds: 200));
                  if (view == TaskViewState.board) {
                    await controller.animateTo(controller.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200), curve: Curves.linear);
                  }
                }),
              if (widget.state.pageState == ProjectPageState.tasks) const TaskView(),
            ],
          );
        }),
      ),
    );
  }
}
