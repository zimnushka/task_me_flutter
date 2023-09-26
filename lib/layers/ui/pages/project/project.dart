import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/project_vm.dart';
import 'package:task_me_flutter/layers/bloc/task/task_bloc.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/sidebar.dart';
import 'package:task_me_flutter/layers/ui/pages/project/info_view.dart';
import 'package:task_me_flutter/layers/ui/pages/task/task_view.dart';
import 'package:task_me_flutter/layers/ui/pages/project/user_view.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

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
    return ChangeNotifierProvider(
      create: (context) => ProjectVM(projectId: id),
      child: Builder(builder: (context) {
        final tasks = context.select((ProjectVM vm) => vm.tasks);
        final vm = context.read<ProjectVM>();
        final taskView = context.read<AppProvider>().state.config.taskView;
        final taskBloc = TaskBloc(vm.onTaskTap, tasks, taskView);
        return BlocProvider.value(
          value: taskBloc,
          child: const _ProjectView(),
        );
      }),
    );
  }
}

class _ProjectView extends StatelessWidget {
  const _ProjectView();

  @override
  Widget build(BuildContext context) {
    final color = context.select((ProjectVM vm) => vm.project.color);
    return SideBar(
      child: Theme(
        data: setPrimaryColor(Theme.of(context), Color(color)),
        child: const _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ProjectVM>();
    final userMe = context.select((AppProvider vm) => vm.state.user!);
    final taskView = context.select((TaskBloc vm) => vm.state.state);
    final tasks = context.select((ProjectVM vm) => vm.tasks);
    final project = context.select((ProjectVM vm) => vm.project);
    final page = context.select((ProjectVM vm) => vm.pageState);

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return CustomScrollView(
          controller: controller,
          physics: page == ProjectPageState.tasks && taskView == TaskViewState.board
              ? const NeverScrollableScrollPhysics()
              : null,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                bottom: 10,
                right: defaultPadding,
              ),
              sliver: SliverAppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                title: AppMainTitleText(project.title),
                centerTitle: false,
                pinned: true,
                snap: false,
                forceElevated: true,
                expandedHeight: 250,
                backgroundColor: Theme.of(context).primaryColor,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
                flexibleSpace: FlexibleSpaceBar(
                  background: tasks.isNotEmpty
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
                                          tasks
                                              .where((element) => element.task.status == data)
                                              .length /
                                          tasks.length *
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
                                          tasks
                                              .where((element) =>
                                                  element.task.status == TaskStatus.closed)
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
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            _Tab(
                              onTap: () => vm.onTabTap(ProjectPageState.tasks),
                              label: 'Tasks',
                              isActive: page == ProjectPageState.tasks,
                            ),
                            _Tab(
                              onTap: () => vm.onTabTap(ProjectPageState.users),
                              label: 'Users',
                              isActive: page == ProjectPageState.users,
                            ),
                            if (userMe.id == project.ownerId)
                              _Tab(
                                onTap: () => vm.onTabTap(ProjectPageState.info),
                                label: 'Info',
                                isActive: page == ProjectPageState.info,
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: vm.onHeaderButtonTap,
                          child: Text(page.headerButtonLabel),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (page == ProjectPageState.info)
              const SliverPadding(
                padding: EdgeInsets.only(right: defaultPadding),
                sliver: InfoProjectView(),
              ),
            if (page == ProjectPageState.users)
              const SliverPadding(
                padding: EdgeInsets.only(right: defaultPadding),
                sliver: UserProjectView(),
              ),
            if (page == ProjectPageState.tasks)
              SliverPadding(
                padding: const EdgeInsets.only(right: defaultPadding),
                sliver: TaskViewFilter(
                  onChangeView: (view) async {
                    await Future.delayed(const Duration(milliseconds: 200));
                    if (view == TaskViewState.board) {
                      await controller.animateTo(controller.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200), curve: Curves.linear);
                    }
                  },
                ),
              ),
            if (page == ProjectPageState.tasks)
              const SliverPadding(
                  padding: EdgeInsets.only(right: defaultPadding), sliver: TaskView()),
          ],
        );
      },
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.isActive, required this.onTap});
  final bool isActive;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: isActive ? Theme.of(context).primaryColor : null,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AppText(label, color: isActive ? Colors.white : Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
