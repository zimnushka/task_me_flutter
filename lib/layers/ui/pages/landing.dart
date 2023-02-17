import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/ui/kit/responsive_ui.dart';
import 'package:task_me_flutter/layers/ui/kit/sidebar.dart';
import 'package:task_me_flutter/layers/ui/pages/auth/auth.dart';

class Landing extends StatefulWidget {
  final Widget child;
  const Landing({required this.child, super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppProvider, AppProviderState>(
      builder: (context, state) {
        return Theme(
          data: state.theme,
          child: ColoredBox(
            color: state.theme.colorScheme.background,
            child: state.user != null
                ? ResponsiveUi(
                    widthExpand: 800,
                    sideBar: SideBar(
                      projects: state.projects,
                      onUpdate: () => context.read<AppProvider>().load(),
                    ),
                    child: widget.child,
                  )
                : const AuthPage(),
          ),
        );
      },
    );
  }
}
