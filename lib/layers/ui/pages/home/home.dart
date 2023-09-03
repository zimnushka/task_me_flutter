import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

import '../../../bloc/home/home_state.dart';

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
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();
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
  late final _taskBloc = TaskBloc(
    (id) => _bloc(context).add(OnTaskTap(id)),
    widget.state.tasks.map((e) => TaskUi(e, [])).toList(),
    TaskViewState.list,
  );

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final projects = context.read<AppProvider>().state.projects;
    return TasksViewProvider(
      bloc: _taskBloc,
      child: BlocBuilder<TaskBloc, AppState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: defaultPadding),
          child: CustomScrollView(
            controller: controller,
            slivers: [
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, defaultPadding),
                sliver: SliverAppBar(
                  automaticallyImplyLeading: false,
                  title: AppMainTitleText(provider.state.user!.name),
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
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),
                              const AppSmallText('Email', color: Colors.white),
                              AppTitleText(provider.state.user!.email, color: Colors.white),
                              const SizedBox(height: defaultPadding),
                              const AppSmallText('Hourly payment', color: Colors.white),
                              AppTitleText('${provider.state.user!.cost}', color: Colors.white),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(flex: 3, child: SizedBox()),
                    ],
                  )),
                  bottom: PreferredSize(
                    preferredSize: const Size(double.infinity, 40),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Theme.of(context).primaryColor),
                            onPressed: () => _bloc(context).add(OnHeaderButtonTap()),
                            child: const Text('Settings'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, defaultPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: defaultPadding,
                    mainAxisSpacing: defaultPadding,
                    childAspectRatio: 2 / 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    childCount: projects.length,
                    (context, index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(projects[index].color),
                          borderRadius: const BorderRadius.all(radius),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: AppTitleText(projects[index].title),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
