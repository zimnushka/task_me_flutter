import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/project_dialog.dart';
import 'package:task_me_flutter/layers/ui/kit/responsive_ui.dart';
import 'package:task_me_flutter/layers/ui/pages/home/home.dart';
import 'package:task_me_flutter/layers/ui/pages/project/project.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class SideBar extends StatefulWidget {
  const SideBar({required this.child, super.key});
  final Widget child;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late final AppProvider appProvider = context.watch<AppProvider>();

  Future<void> showProjectEditor({Project? project}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ProjectDialog(
          project: project,
          onUpdate: () => context.read<AppProvider>().load(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.read<AppProvider>().state.projects;
    return ResponsiveUi(
      widthExpand: 800,
      sideBar: Container(
        width: kSideBarWidth,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(radius),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(defaultPadding, defaultPadding, defaultPadding, 0),
              child: GestureDetector(
                onTap: () => AppRouter.goTo(HomePage.route()),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Theme.of(context).primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(appProvider.state.user!.name, weight: FontWeight.bold),
                          const SizedBox(height: 5),
                          AppSmallText(appProvider.state.user!.email),
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
                            onTap: () => AppRouter.goTo(ProjectPage.route(item.id!)),
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
          ],
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
