import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/project_create_dialog.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class SideBar extends StatefulWidget {
  const SideBar({required this.projects, super.key});
  final List<Project> projects;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with TickerProviderStateMixin {
  late final themeController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = context.watch<AppProvider>();
    return Container(
      width: 250,
      height: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(radius),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(bottom: 20),
            leading: const CircleAvatar(child: Icon(Icons.person)),
            minLeadingWidth: 10,
            title: TextBold(appProvider.state.user!.name),
            subtitle: Text(appProvider.state.user!.email),
          ),
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
                  context
                      .read<AppProvider>()
                      .setTheme(isLightTheme: value == 0, color: Theme.of(context).primaryColor);
                },
                indicator: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(radius),
                ),
                tabs: const [
                  Tab(text: 'light'),
                  Tab(text: 'dark'),
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
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ProjectCreateDialog();
                        },
                      );

                      // context.go("/auth");
                    },
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
                  return ProjectButton(item);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProjectButton extends StatefulWidget {
  const ProjectButton(this.item, {super.key});
  final Project item;

  @override
  State<ProjectButton> createState() => _ProjectButtonState();
}

class _ProjectButtonState extends State<ProjectButton> {
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
        child: ListTile(
          onTap: () {},
          selected: isHover,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          leading: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(widget.item.color),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: const SizedBox(
              height: 20,
              width: 20,
            ),
          ),
          minLeadingWidth: 10,
          title: Text(widget.item.title),
          trailing: isHover
              ? GestureDetector(
                  child: const Icon(
                  Icons.auto_awesome,
                  size: 16,
                ))
              : const SizedBox(),
        ));
  }
}
