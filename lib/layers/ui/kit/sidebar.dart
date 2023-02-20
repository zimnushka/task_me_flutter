import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/project_dialog.dart';
import 'package:task_me_flutter/layers/ui/pages/home.dart';
import 'package:task_me_flutter/layers/ui/pages/project/project.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class SideBar extends StatefulWidget {
  const SideBar({required this.onUpdate, required this.projects, super.key});
  final List<Project> projects;
  final VoidCallback onUpdate;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late final AppProvider appProvider = context.watch<AppProvider>();

  Future<void> showProjectEditor({Project? project}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ProjectDialog(project: project, onUpdate: widget.onUpdate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kSideBarWidth,
      height: double.infinity,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(radius),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => AppRouter.goTo(HomePage.route()),
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColor),
            minLeadingWidth: 10,
            title: AppText(appProvider.state.user!.name, weight: FontWeight.bold),
            subtitle: Text(appProvider.state.user!.email),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
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
            child: widget.projects.isNotEmpty
                ? Material(
                    type: MaterialType.transparency,
                    child: ListView.builder(
                      itemCount: widget.projects.length,
                      itemBuilder: (context, index) {
                        final item = widget.projects[index];
                        return ProjectButton(
                          item: item,
                          onTap: () => AppRouter.goTo(ProjectPage.route(item.id!)),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(item.color),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: const SizedBox(
          height: 20,
          width: 20,
        ),
      ),
      minLeadingWidth: 10,
      title: Text(item.title),
    );
  }
}
