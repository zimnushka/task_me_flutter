import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/router/app_router.dart';
import 'package:task_me_flutter/ui/pages/home/home_vm.dart';
import 'package:task_me_flutter/ui/pages/task/task_view.dart';
import 'package:task_me_flutter/ui/pages/task/task_vm.dart';
import 'package:task_me_flutter/ui/styles/text.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';
import 'package:task_me_flutter/ui/widgets/load_container.dart';
import 'package:task_me_flutter/ui/widgets/sidebar.dart';

class HomeRoute implements AppPage {
  @override
  String get name => 'home';

  @override
  Map<String, String>? get params => null;

  @override
  Map<String, String>? get queryParams => null;

  @override
  Object? get extra => null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static AppPage route() => HomeRoute();

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return ChangeNotifierProvider(
      create: (_) => HomeVM(mainBloc: mainBloc),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();
  @override
  Widget build(BuildContext context) {
    final homeVM = context.read<HomeVM>();
    final mainBloc = context.read<MainBloc>();
    final user = context.select((MainBloc vm) => vm.state.authState.user!);
    final tasks = context.select((HomeVM vm) => vm.tasks);
    final isLoading = context.select((HomeVM vm) => vm.isLoading);

    final taskBloc = TaskVM(
      mainBloc: mainBloc,
      onTaskClick: homeVM.onTaskTap,
      tasks: tasks.map((e) => TaskUi(e, [])).toList(),
      state: TaskViewState.list,
    );

    return SideBar(
      child: Stack(
        children: [
          AnimatedOpacity(
              opacity: isLoading ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: const _LoadView()),
          AnimatedOpacity(
            opacity: isLoading ? 0 : 1,
            duration: const Duration(milliseconds: 500),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 10, right: defaultPadding),
                  sliver: SliverAppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: AppMainTitleText(user.name),
                    centerTitle: false,
                    pinned: true,
                    snap: false,
                    forceElevated: true,
                    expandedHeight: 250,
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
                    flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          const AppSmallText('Email', color: Colors.white),
                          AppTitleText(user.email, color: Colors.white),
                          const SizedBox(height: defaultPadding),
                          const AppSmallText('Hourly payment', color: Colors.white),
                          AppTitleText('${user.cost}', color: Colors.white),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
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
                              onPressed: homeVM.onHeaderButtonTap,
                              child: const Text('Settings'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ChangeNotifierProvider.value(
                  value: taskBloc,
                  child: SliverPadding(
                    padding: const EdgeInsets.only(right: defaultPadding, bottom: defaultPadding),
                    sliver: Builder(builder: (context) {
                      return const TaskView();
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
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
