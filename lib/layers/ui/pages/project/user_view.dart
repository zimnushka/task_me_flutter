import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/project/project_bloc.dart';
import 'package:task_me_flutter/layers/bloc/project/project_event.dart';
import 'package:task_me_flutter/layers/bloc/project/project_state.dart';
import 'package:task_me_flutter/layers/ui/kit/slide_animation_container.dart';
import 'package:task_me_flutter/layers/ui/pages/project/cards.dart';

ProjectBloc _bloc(BuildContext context) => BlocProvider.of(context);

class UserProjectView extends StatelessWidget {
  const UserProjectView(
    this.state,
  );
  final ProjectLoadedState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.users.length,
      itemBuilder: (context, index) {
        final item = state.users[index];
        return SlideAnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeOut,
            start: const Offset(1, 0),
            end: Offset.zero,
            child: UserCard(item, () => _bloc(context).add(OnDeleteUser(item.id)),
                state.tasks.map((e) => e.task).toList(),
                isOwner: state.project.ownerId == item.id));
      },
    );
  }
}
