import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/ui/pages/home/home.dart';
import 'package:task_me_flutter/ui/pages/project/project.dart';
import 'package:task_me_flutter/ui/styles/text.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';
import 'package:task_me_flutter/ui/widgets/overlays/project_dialog.dart';
import 'package:task_me_flutter/ui/widgets/responsive_ui.dart';

class SideBar extends StatefulWidget {
  const SideBar({required this.child, super.key});
  final Widget child;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Future<void> showProjectEditor() async {
    await showDialog(
      context: context,
      builder: (context) => const ProjectDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MainBloc>();
    final projects = context.select((MainBloc vm) => vm.state.sideBarState.projects);
    final interval = context.select((MainBloc vm) => vm.state.currentTimeInterval);
    final user = context.select((MainBloc vm) => vm.state.authState.user) ?? User.empty();

    return ResponsiveUi(
      widthExpand: 800,
      sideBar: SizedBox(
        width: kSideBarWidth,
        height: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(radius),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(defaultPadding, defaultPadding, defaultPadding, 0),
                child: GestureDetector(
                  onTap: () => vm.router.goTo(HomePage.route()),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Theme.of(context).primaryColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(user.name, weight: FontWeight.bold),
                            const SizedBox(height: 5),
                            AppSmallText(user.email),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: defaultPadding),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText('Projects', weight: FontWeight.bold),
                    GestureDetector(
                        onTap: showProjectEditor,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        ))
                  ],
                ),
              ),
              Expanded(
                child: projects.isNotEmpty
                    ? Material(
                        type: MaterialType.transparency,
                        child: ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final item = projects[index];
                            return ProjectButton(
                              item: item,
                              onTap: () => vm.router.goTo(ProjectPage.route(item.id!)),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.live_help_outlined,
                              size: 40,
                            ),
                            Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Text(
                                'Click + to add new project, or ask your project member of invite you',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              interval != null ? _IntervalCard(item: interval) : const SizedBox(),
            ],
          ),
        ),
      ),
      child: widget.child,
    );
  }
}

class ProjectButton extends StatelessWidget {
  const ProjectButton({
    required this.item,
    required this.onTap,
    super.key,
  });
  final Project item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      leading: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: Color(item.color),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
      ),
      minLeadingWidth: 10,
      title: AppText(item.title),
    );
  }
}

class _IntervalCard extends StatefulWidget {
  const _IntervalCard({required this.item});
  final TimeInterval item;

  @override
  State<_IntervalCard> createState() => _IntervalCardState();
}

class _IntervalCardState extends State<_IntervalCard> {
  Duration diff = const Duration();
  final stream = Stream.periodic(
    const Duration(seconds: 1),
    (tic) => tic,
  );

  @override
  void initState() {
    diff = DateTime.now().difference(widget.item.timeStart.toLocal());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 10),
            StreamBuilder<int>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    diff += Duration(seconds: snapshot.data!);
                  }
                  return Text('${diff.inHours}h ${diff.inMinutes}m ${diff.inSeconds}s');
                }),
          ],
        ),
      ),
    );
  }
}
