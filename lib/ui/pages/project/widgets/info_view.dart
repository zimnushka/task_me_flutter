import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/ui/pages/project/project_vm.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';
import 'package:task_me_flutter/ui/widgets/slide_animation_container.dart';

class InfoProjectView extends StatefulWidget {
  const InfoProjectView({super.key});

  @override
  State<InfoProjectView> createState() => _InfoProjectViewState();
}

class _InfoProjectViewState extends State<InfoProjectView> {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<ProjectVM>();
    final tasks = context.select((ProjectVM vm) => vm.tasks);
    final users = context.select((ProjectVM vm) => vm.users);

    int maxCountGetedTasks = 0;

    int cost = 0;
    for (final element in tasks) {
      cost = cost + element.task.cost;
    }

    User? bestUser;

    for (final element in users) {
      bestUser ??= element;
      final index = tasks
          .where((element) =>
              element.users.where((element) => element.id == bestUser?.id).isNotEmpty &&
              element.task.status == TaskStatus.closed)
          .length;
      if (index > maxCountGetedTasks) {
        bestUser = element;
        maxCountGetedTasks = index;
      }
    }

    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SlideAnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            start: const Offset(1, 0),
            end: Offset.zero,
            child: Card(
              margin: const EdgeInsets.only(top: defaultPadding),
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total project cost'),
                    const SizedBox(height: 10),
                    Text(cost.toString(), style: const TextStyle(fontSize: 30)),
                  ],
                ),
              ),
            ),
          ),
          SlideAnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            start: const Offset(1, 0),
            end: Offset.zero,
            child: Card(
              margin: const EdgeInsets.only(top: defaultPadding),
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Users count'),
                    const SizedBox(height: 10),
                    Text(users.length.toString(), style: const TextStyle(fontSize: 30)),
                    if (bestUser != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 30),
                          Text('Task master • close $maxCountGetedTasks tasks'),
                          ListTile(
                            minLeadingWidth: 10,
                            contentPadding: EdgeInsets.zero,
                            title: Text(bestUser.name),
                            subtitle: Text(bestUser.email),
                            leading: CircleAvatar(backgroundColor: bestUser.color),
                          ),
                        ],
                      )
                    else
                      const SizedBox()
                  ],
                ),
              ),
            ),
          ),
          SlideAnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            start: const Offset(1, 0),
            end: Offset.zero,
            child: Card(
              margin: const EdgeInsets.only(top: defaultPadding),
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Tasks count'),
                    const SizedBox(height: 10),
                    Text(tasks.length.toString(), style: const TextStyle(fontSize: 30)),
                    const SizedBox(height: 30),
                    GridView(
                      primary: true,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 1.5 / 1,
                          mainAxisSpacing: defaultPadding,
                          crossAxisSpacing: defaultPadding),
                      semanticChildCount: TaskStatus.values.length,
                      children: TaskStatus.values
                          .map((e) => Card(
                                color: e.color.withOpacity(0.5),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.label,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            tasks
                                                .where((element) => element.task.status == e)
                                                .length
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 20, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                onPressed: vm.onDeleteProject,
                child: const Text('Delete project'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
