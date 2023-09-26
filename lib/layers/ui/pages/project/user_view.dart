import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/project_vm.dart';
import 'package:task_me_flutter/layers/ui/kit/slide_animation_container.dart';
import 'package:task_me_flutter/layers/ui/pages/project/cards.dart';

class UserProjectView extends StatelessWidget {
  const UserProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ProjectVM>();
    final users = context.select((ProjectVM vm) => vm.users);
    final tasks = context.select((ProjectVM vm) => vm.tasks);
    final project = context.select((ProjectVM vm) => vm.project);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: users.length,
        (context, index) {
          final item = users[index];
          return SlideAnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeOut,
            start: const Offset(1, 0),
            end: Offset.zero,
            child: UserCard(
              item,
              () => vm.onDeleteUser(item.id),
              tasks,
              isOwner: project.ownerId == item.id,
            ),
          );
        },
      ),
    );
  }
}
