import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/project.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/ui/kit/slide_animation_container.dart';
import 'package:task_me_flutter/layers/ui/pages/project/cards.dart';

ProjectCubit _bloc(BuildContext context) => BlocProvider.of(context);

class UserProjectView extends StatelessWidget {
  const UserProjectView(
    this.state,
  );
  final ProjectState state;

  @override
  Widget build(BuildContext context) {
    final repository = UserApiRepository();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: state.users.length,
        (context, index) {
          final item = state.users[index];
          return SlideAnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOut,
              start: const Offset(1, 0),
              end: Offset.zero,
              child: UserCard(item, () async {
                await repository.deleteMemberFromProject(item.id, state.project!.id!);
                await _bloc(context).updateUsers();
              }, state.tasks, isOwner: state.project!.ownerId == item.id));
        },
      ),
    );
  }
}
