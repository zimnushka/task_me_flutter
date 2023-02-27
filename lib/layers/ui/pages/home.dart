import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/home/home_bloc.dart';
import 'package:task_me_flutter/layers/bloc/home/home_event.dart';
import 'package:task_me_flutter/layers/bloc/task/task_bloc.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/task/task_view.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

import '../../bloc/home/home_state.dart';

HomeBloc _bloc(BuildContext context) => BlocProvider.of(context);

class HomeRoute implements AppPage {
  @override
  String get name => 'home';

  @override
  Map<String, String>? get params => null;

  @override
  Map<String, String>? get queryParams => null;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static AppPage route() => HomeRoute();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(Load()),
      child: const _ProjectView(),
    );
  }
}

class _ProjectView extends StatelessWidget {
  const _ProjectView();
  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<HomeBloc>(builder: (state, context) {
      state as HomeLoadedState;
      return _Body(state);
    });
  }
}

class _Body extends StatefulWidget {
  const _Body(
    this.state,
  );
  final HomeLoadedState state;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final provider = context.watch<AppProvider>();
  late final _taskBloc = TaskBloc((id) => _bloc(context).add(OnTaskTap(id)),
      widget.state.tasks.map((e) => TaskUi(e, [])).toList(), provider.state.config.taskView);

  final controller = ScrollController();

  bool isBoardOpen() {
    return _taskBloc.state is TaskState &&
        (_taskBloc.state as TaskState).state == TaskViewState.board;
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
                  title: AppMainTitleText(provider.state.user!.name),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 14),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => _bloc(context).add(OnHeaderButtonTap()),
                        child: const Text('Settings'),
                      ),
                    ),
                  ],
                  centerTitle: false,
                  pinned: true,
                  snap: false,
                  forceElevated: true,
                  expandedHeight: 250,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
                  flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      defaultPadding,
                      45,
                      defaultPadding,
                      defaultPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(provider.state.user!.email),
                        SingleChildScrollView(
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: HeatMap(
                            datasets: {
                              DateTime(2023, 2, 8): 1,
                              DateTime(2023, 2, 9): 2,
                              DateTime(2023, 2, 10): 3,
                              DateTime(2023, 2, 11): 4,
                            },
                            colorMode: ColorMode.color,
                            textColor: Colors.white,
                            size: 15,
                            fontSize: 10,
                            borderRadius: 2.5,
                            showText: false,
                            scrollable: false,
                            showColorTip: false,
                            defaultColor: Colors.white,
                            colorTipCount: 4,
                            colorsets: {
                              1: Theme.of(context).primaryColor.withOpacity(0.2),
                              2: Theme.of(context).primaryColor.withOpacity(0.4),
                              3: Theme.of(context).primaryColor.withOpacity(0.6),
                              4: Theme.of(context).primaryColor.withOpacity(0.8),
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
              TaskViewFilter(onChangeView: (view) async {
                await Future.delayed(const Duration(milliseconds: 200));
                if (view == TaskViewState.board) {
                  await controller.animateTo(controller.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200), curve: Curves.linear);
                }
              }),
              const TaskView(),
            ],
          );
        }),
      ),
    );
  }
}
