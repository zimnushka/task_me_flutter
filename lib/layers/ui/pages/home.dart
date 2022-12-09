import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/ui/loader.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/home.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/user_editor.dart';
import 'package:task_me_flutter/layers/ui/pages/project/cards.dart';
import 'package:task_me_flutter/layers/ui/pages/task_page.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

HomeCubit _bloc(BuildContext context) => BlocProvider.of(context);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static void route(BuildContext context) => context.goNamed('home');

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final cubit = HomeCubit(context.watch<AppProvider>().state.user!.id);
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
      body: BlocBuilder<HomeCubit, AppState>(builder: (context, state) {
        if (state is HomeState) {
          return _Body(state);
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
  final HomeState state;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
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
            background: widget.state.tasks.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: SizedBox()),
                            const Text('Email',
                                style: TextStyle(color: Colors.white, fontSize: 12)),
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
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UserEditDialog(
                                          onUpdate: (value) async {
                                            Navigator.pop(context);
                                            await provider.updateUser(value);
                                          },
                                          initialUser: provider.state.user!);
                                    });
                              },
                              child: const Text('Edit'),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        _TasksView(widget.state)
      ],
    );
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView(
    this.state,
  );
  final HomeState state;

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
          return TaskStatusHeader(
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
                ? TaskCard(item, () => TaskPage.route(context, item.projectId, taskId: item.id))
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
