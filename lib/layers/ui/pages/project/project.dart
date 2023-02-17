import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/project/project_bloc.dart';
import 'package:task_me_flutter/layers/bloc/project/project_event.dart';
import 'package:task_me_flutter/layers/bloc/project/project_state.dart';
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

class ProjectPage extends StatefulWidget {
  const ProjectPage(this.id, {super.key});
  final int id;

  static AppPage route(int projectId) => ProjectRoute(projectId);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ProjectBloc()..add(Load(widget.id)),
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
  late final User user = context.read<AppProvider>().state.user!;
  late final TabController tabController;
  final tabs = [const Tab(text: 'Tasks'), const Tab(text: 'Users')];

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(radius),
                color: Color(widget.state.project.color),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AppMainTitleText(
                          widget.state.project.title,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
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
                ],
              )),
        ),
        body: widget.state.pageState == ProjectPageState.info
            ? InfoProjectView(widget.state)
            : widget.state.pageState == ProjectPageState.users
                ? UserProjectView(widget.state)
                : TasksProjectView(
                    tasks: widget.state.tasks,
                    onTaskTap: (id) => _bloc(context).add(OnTaskTap(id)),
                  ),
      ),
    );
  }
}
