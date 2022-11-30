import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/ui/loader.dart';
import 'package:task_me_flutter/layers/bloc/project.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage(this.id, {super.key});
  final int id;

  static void route(BuildContext context, int projectId) =>
      context.goNamed('project', params: {'projectId': projectId.toString()});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  late final cubit = ProjectCubit(widget.id);
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: const _ProjectView(),
    );
  }
}

class _ProjectView extends StatefulWidget {
  const _ProjectView({super.key});

  @override
  State<_ProjectView> createState() => __ProjectViewState();
}

class __ProjectViewState extends State<_ProjectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProjectCubit, AppState>(builder: (context, state) {
        if (state is ProjectState && state.project != null) {
          return _Body(state);
        }
        return AppLoadingIndecator();
      }),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body(this.state, {super.key});
  final ProjectState state;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  late final TabController tabController = TabController(length: 2, vsync: this);
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Text(widget.state.project!.title),
              titleTextStyle: const TextStyle(fontSize: 25, color: Colors.white),
              centerTitle: false,
              pinned: true,
              snap: false,
              forceElevated: true,
              expandedHeight: 250,
              backgroundColor: Color(widget.state.project!.color),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
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
                        color: Color(widget.state.project!.color),
                      ),
                      isScrollable: true,
                      tabs: const [
                        Tab(text: 'Tasks'),
                        Tab(text: 'Users'),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [_TasksView(widget.state), _UsersView(widget.state)],
        ));
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView(this.state, {super.key});
  final ProjectState state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _UsersView extends StatelessWidget {
  const _UsersView(this.state, {super.key});
  final ProjectState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.users.length,
      itemBuilder: (context, index) {
        final item = state.users[index];
        return _UserCard(item);
      },
    );
  }
}

class _UserCard extends StatefulWidget {
  const _UserCard(this.user, {super.key});
  final User user;

  @override
  State<_UserCard> createState() => __UserCardState();
}

class __UserCardState extends State<_UserCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHover = false;
          });
        },
        child: Card(
          child: ListTile(
            selected: isHover,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColor),
            minLeadingWidth: 10,
            title: Text(widget.user.name),
            subtitle: Text(widget.user.email),
          ),
        ));
  }
}
