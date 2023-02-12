import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/home/home_bloc.dart';
import 'package:task_me_flutter/layers/bloc/home/home_event.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/pages/task/task_view.dart';
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

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 10),
          sliver: SliverAppBar(
            automaticallyImplyLeading: false,
            title: Text(provider.state.user!.name),
            titleTextStyle: const TextStyle(fontSize: 25, color: Colors.white),
            centerTitle: false,
            pinned: true,
            snap: false,
            forceElevated: true,
            expandedHeight: 250,
            backgroundColor: Theme.of(context).primaryColor,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
            flexibleSpace: FlexibleSpaceBar(
                background: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: SizedBox()),
                      const Text('Email', style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text(provider.state.user!.email,
                          style: const TextStyle(color: Colors.white, fontSize: 18)),
                      const SizedBox(height: 20),
                      const Text('Hourly payment',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text(provider.state.user!.cost.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 18)),
                      const Expanded(child: SizedBox()),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).primaryColor),
                        onPressed: () => _bloc(context).add(OnHeaderButtonTap()),
                        child: const Text('Edit'),
                      )
                    ],
                  ),
                ),
                if (widget.state.tasks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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
                                        .where((element) => element.status == data)
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
                                        .where((element) => element.status == TaskStatus.closed)
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
                else
                  const SizedBox()
              ],
            )),
          ),
        ),
      ],
      body: widget.state.tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(height: 30),
                  Icon(
                    Icons.update,
                    size: 60,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Task list is empty or try update page',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : TasksProjectView(
              tasks: widget.state.tasks.map((e) => TaskUi(e, [])).toList(),
              onTaskTap: (id) => _bloc(context).add(OnTaskTap(id)),
            ),
    );
  }
}
