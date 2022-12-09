// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_me_flutter/layers/bloc/project.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

ProjectCubit _bloc(BuildContext context) => BlocProvider.of(context);

class InfoProjectView extends StatelessWidget {
  const InfoProjectView(
    this.state,
  );
  final ProjectState state;

  @override
  Widget build(BuildContext context) {
    int cost = 0;
    state.tasks.forEach(
      (element) {
        cost = cost + element.cost;
      },
    );
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.only(top: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total project cost'),
                  const SizedBox(height: 10),
                  Text(cost.toString(), style: const TextStyle(fontSize: 25)),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.only(top: 20),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Users count'),
                  const SizedBox(height: 10),
                  Text(state.users.length.toString(), style: TextStyle(fontSize: 25)),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(top: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Tasks count'),
                  const SizedBox(height: 10),
                  Text(state.tasks.length.toString(), style: const TextStyle(fontSize: 25)),
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
                                          state.tasks
                                              .where((element) => element.status == e)
                                              .length
                                              .toString(),
                                          style: const TextStyle(fontSize: 20, color: Colors.white),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Theme.of(context).errorColor),
                onPressed: () async {
                  await _bloc(context).deleteProject();
                  GoRouter.of(context).pushNamed('home');
                },
                child: Text('Delete project'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
