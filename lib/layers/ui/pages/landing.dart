import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/ui/pages/auth/auth.dart';
import 'package:task_me_flutter/layers/ui/pages/menu.dart';

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
          child: DecoratedBox(
            decoration: BoxDecoration(color: state.theme.backgroundColor),
            child: state.user != null ? Menu(widget.child) : const AuthPage(),
          ),
        );
      },
    );
  }
}
