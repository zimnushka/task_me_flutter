import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/domain/service/router.dart';
import 'package:task_me_flutter/bloc/app_provider.dart';
import 'package:task_me_flutter/ui/pages/home/home_vm.dart';
// import 'package:task_me_flutter/ui/pages/task/task_vm.dart';
import 'package:task_me_flutter/ui/pages/home/widgets/interval.dart';
import 'package:task_me_flutter/ui/pages/task/task_view.dart';
import 'package:task_me_flutter/ui/pages/task/task_vm.dart';
import 'package:task_me_flutter/ui/styles/text.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';
import 'package:task_me_flutter/ui/widgets/sidebar.dart';

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
    return ChangeNotifierProvider(
      create: (_) => HomeVM(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();
  @override
  Widget build(BuildContext context) {
    final user = context.select((AppProvider vm) => vm.state.user!);
    final homeVM = context.read<HomeVM>();
    final tasks = context.select((HomeVM vm) => vm.tasks);
    final taskBloc = TaskVM(
      onTaskClick: homeVM.onTaskTap,
      tasks: tasks.map((e) => TaskUi(e, [])).toList(),
      state: TaskViewState.list,
    );
    return SideBar(
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
                          AppTitleText(user.email, color: Colors.white),
                          const SizedBox(height: defaultPadding),
                          const AppSmallText('Hourly payment', color: Colors.white),
                          AppTitleText('${user.cost}', color: Colors.white),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(flex: 3, child: HomeIntervalsView()),
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
    );
  }
}
