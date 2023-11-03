import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/router/app_router.dart';
import 'package:task_me_flutter/ui/pages/project/project_vm.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/ui/pages/project/widgets/info_view.dart';
import 'package:task_me_flutter/ui/pages/project/widgets/user_view.dart';
import 'package:task_me_flutter/ui/pages/task/task_view.dart';
import 'package:task_me_flutter/ui/pages/task/task_vm.dart';
import 'package:task_me_flutter/ui/pages/task_detail/task_detail.dart';
import 'package:task_me_flutter/ui/styles/text.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';
import 'package:task_me_flutter/ui/widgets/load_container.dart';
import 'package:task_me_flutter/ui/widgets/overlays/invite_member.dart';
import 'package:task_me_flutter/ui/widgets/overlays/project_dialog.dart';
import 'package:task_me_flutter/ui/widgets/sidebar.dart';

class ProjectRoute implements AppPage {
  final int projectId;

  const ProjectRoute(this.projectId);

  @override
  String get name => 'project';

  @override
  Map<String, String> get params => {'projectId': projectId.toString()};

  @override
  Map<String, String>? get queryParams => null;

  @override
  Object? get extra => null;
}

class ProjectPage extends StatelessWidget {
  const ProjectPage(this.id, {super.key});
  final int id;

  static AppPage route(int projectId) => ProjectRoute(projectId);

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return ChangeNotifierProvider(
      create: (context) => ProjectVM(
        projectId: id,
        mainBloc: mainBloc,
      ),
      child: Builder(builder: (context) {
        final mainBloc = context.read<MainBloc>();
        final vm = context.read<ProjectVM>();

        final tasks = context.select((ProjectVM vm) => vm.tasks);
        final color = context.select((ProjectVM vm) => vm.project.color);

        final taskView = mainBloc.state.config.taskView;
        final taskBloc = TaskVM(
          onTaskClick: vm.onTaskTap,
          tasks: tasks,
          state: taskView,
          mainBloc: mainBloc,
        );
        return ChangeNotifierProvider.value(
          value: taskBloc,
          child: SideBar(
            child: Theme(
              data: setPrimaryColor(Theme.of(context), Color(color)),
              child: const _ProjectView(),
            ),
          ),
        );
      }),
    );
  }
}

class _ProjectView extends StatefulWidget {
  const _ProjectView();

  @override
  State<_ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<_ProjectView> with TickerProviderStateMixin {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ProjectVM>();
    final mainBloc = context.read<MainBloc>();
    final userMe = context.select((MainBloc vm) => vm.state.authState.user!);
    final taskView = context.select((TaskVM vm) => vm.state);
    final tasks = context.select((ProjectVM vm) => vm.tasks);
    final project = context.select((ProjectVM vm) => vm.project);
    final isLoading = context.select((ProjectVM vm) => vm.isLoading);
    final page = context.select((ProjectVM vm) => vm.pageState);

    return Stack(
      children: [
        AnimatedOpacity(
            opacity: isLoading ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: const _LoadView()),
        AnimatedOpacity(
          opacity: isLoading ? 0 : 1,
          duration: const Duration(milliseconds: 500),
          child: CustomScrollView(
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
                            onPressed: () async {
                              switch (page) {
                                case ProjectPageState.tasks:
                                  await mainBloc.router.goTo(
                                    TaskPage.route(
                                      vm.projectId,
                                      onTaskUpdate: () => vm.refresh(tasks: true),
                                    ),
                                  );
                                  break;
                                case ProjectPageState.users:
                                  if (mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => InviteMemberDialog(
                                        projectId: vm.projectId,
                                        onInvite: () => vm.refresh(user: true),
                                      ),
                                    );
                                  }

                                  break;
                                case ProjectPageState.info:
                                  if (mounted) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => ProjectDialog(project: project),
                                    );
                                  }

                                  break;
                              }
                            },
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
                  padding: EdgeInsets.only(
                    right: defaultPadding,
                    bottom: defaultPadding,
                  ),
                  sliver: InfoProjectView(),
                ),
              if (page == ProjectPageState.users)
                const SliverPadding(
                  padding: EdgeInsets.only(
                    right: defaultPadding,
                    bottom: defaultPadding,
                  ),
                  sliver: UserProjectView(),
                ),
              if (page == ProjectPageState.tasks)
                SliverPadding(
                  padding: const EdgeInsets.only(
                    right: defaultPadding,
                    bottom: defaultPadding,
                  ),
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
                    padding: EdgeInsets.only(
                      right: defaultPadding,
                      bottom: defaultPadding,
                    ),
                    sliver: TaskView()),
            ],
          ),
        ),
      ],
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

class _LoadView extends StatelessWidget {
  const _LoadView();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            LoadContainer(
              lineColor: Theme.of(context).cardColor,
              backGroundColor: Theme.of(context).cardColor.withOpacity(0.5),
              width: double.infinity,
              height: 250,
            ),
            const SizedBox(height: 10),
            LoadContainer(
              lineColor: Theme.of(context).cardColor,
              backGroundColor: Theme.of(context).cardColor.withOpacity(0.5),
              width: double.infinity,
              height: 40,
            ),
            const SizedBox(height: defaultPadding),
            ...List.generate(
              8,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LoadContainer(
                  lineColor: Theme.of(context).cardColor,
                  backGroundColor: Theme.of(context).cardColor.withOpacity(0.5),
                  width: double.infinity,
                  height: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
