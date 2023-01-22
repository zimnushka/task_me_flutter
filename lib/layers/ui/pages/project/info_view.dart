// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/project/project_bloc.dart';
import 'package:task_me_flutter/layers/bloc/project/project_event.dart';
import 'package:task_me_flutter/layers/bloc/project/project_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/kit/slide_animation_container.dart';

ProjectBloc _bloc(BuildContext context) => BlocProvider.of(context);

class InfoProjectView extends StatefulWidget {
  const InfoProjectView(this.state);
  final ProjectLoadedState state;

  @override
  State<InfoProjectView> createState() => _InfoProjectViewState();
}

class _InfoProjectViewState extends State<InfoProjectView> {
  User? bestUser;
  int maxCountGetedTasks = 0;
  int cost = 0;

  User? getBestUser() {
    for (final element in widget.state.users) {
      bestUser ??= element;
      final index = widget.state.tasks
          .where(
              (element) => element.assignerId == bestUser?.id && element.status == TaskStatus.done)
          .length;
      if (index > maxCountGetedTasks) {
        bestUser = element;
        maxCountGetedTasks = index;
      }
    }
    return bestUser;
  }

  @override
  void initState() {
    for (final task in widget.state.tasks) {
      cost = cost + task.cost;
    }

    getBestUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SlideAnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
            start: const Offset(1, 0),
            end: Offset.zero,
            child: Card(
              margin: const EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
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
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOut,
            start: const Offset(1, 0),
            end: Offset.zero,
            child: Card(
              margin: EdgeInsets.only(top: 20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Users count'),
                    const SizedBox(height: 10),
                    Text(widget.state.users.length.toString(), style: TextStyle(fontSize: 30)),
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
                            title: Text(bestUser!.name),
                            subtitle: Text(bestUser!.email),
                            leading: CircleAvatar(backgroundColor: Color(bestUser!.color)),
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
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
            start: const Offset(1, 0),
            end: Offset.zero,
            child: Card(
              margin: const EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Tasks count'),
                    const SizedBox(height: 10),
                    Text(widget.state.tasks.length.toString(),
                        style: const TextStyle(fontSize: 30)),
                    const SizedBox(height: 30),
                    GridView(
                      primary: true,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 1.5 / 1,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20),
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
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            widget.state.tasks
                                                .where((element) => element.status == e)
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
            padding: const EdgeInsets.all(20),
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Theme.of(context).errorColor),
                onPressed: () => _bloc(context).add(OnDeleteProject()),
                child: Text('Delete project'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
