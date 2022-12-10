import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/color_selector.dart';
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

class _SideBarState extends State<SideBar> with TickerProviderStateMixin {
  late final themeController =
      TabController(initialIndex: appProvider.state.isLightTheme ? 0 : 1, length: 2, vsync: this);
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
      width: 250,
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(radius),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => HomePage.route(context),
            contentPadding: EdgeInsets.zero,
            leading: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => Center(
                          child: Card(
                            child: SizedBox(
                                width: 320,
                                height: 420,
                                child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: ColorSelector(
                                      initColor: Theme.of(context).primaryColor,
                                      onSetColor: (value) {
                                        appProvider.setTheme(
                                            isLightTheme: themeController.index == 0, color: value);
                                        Navigator.pop(context);
                                      },
                                    ))),
                          ),
                        ));
              },
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            minLeadingWidth: 10,
            title: TextBold(appProvider.state.user!.name),
            subtitle: Text(appProvider.state.user!.email),
          ),
          const SizedBox(height: 10),
          Container(
            height: 40,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.all(radius),
            ),
            child: TabBar(
                controller: themeController,
                onTap: (value) {
                  appProvider.setTheme(
                      isLightTheme: value == 0, color: Theme.of(context).primaryColor);
                },
                indicator: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(radius),
                ),
                tabs: [
                  Tab(
                    child: Text(
                      'light',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'dark',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ]),
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
                const TextBold('Projects'),
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
            child: Material(
              type: MaterialType.transparency,
              child: ListView.builder(
                itemCount: widget.projects.length,
                itemBuilder: (context, index) {
                  final item = widget.projects[index];
                  return ProjectButton(
                    item: item,
                    onTap: () => ProjectPage.route(context, item.id!),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).errorColor),
              onPressed: appProvider.deleteToken,
              child: const Text('logout')),
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
    return MouseRegion(
        child: ListTile(
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
    ));
  }
}
