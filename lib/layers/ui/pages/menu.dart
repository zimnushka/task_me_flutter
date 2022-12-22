import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/ui/error_page.dart';
import 'package:task_me_flutter/layers/bloc/menu.dart';
import 'package:task_me_flutter/layers/ui/kit/responsive_ui.dart';
import 'package:task_me_flutter/layers/ui/kit/sidebar.dart';

class Menu extends StatefulWidget {
  const Menu(this.child, {super.key});

  final Widget child;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final MenuCubit cubit = MenuCubit();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, AppState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is MenuState) {
            return ResponsiveUi(
              widthExpand: 800,
              sideBar: SideBar(
                projects: state.projects,
                onUpdate: cubit.load,
              ),
              child: widget.child,
            );
          } else if (state is AppErrorState) {
            return AppErrorPage(state.error);
          }
          return const SizedBox();
        });
  }
}
