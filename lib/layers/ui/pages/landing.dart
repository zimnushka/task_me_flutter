import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/ui/pages/auth.dart';
import 'package:task_me_flutter/layers/ui/pages/menu.dart';

class AppProviderWidget extends StatefulWidget {
  final Widget child;
  final AppProvider cubit;
  const AppProviderWidget(this.child, this.cubit, {super.key});

  @override
  State<AppProviderWidget> createState() => _AppProviderWidgetState();
}

class _AppProviderWidgetState extends State<AppProviderWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: BlocBuilder<AppProvider, AppProviderState>(
          bloc: widget.cubit,
          builder: (context, state) {
            return Theme(
              data: state.theme,
              child: DecoratedBox(
                decoration: BoxDecoration(color: state.theme.backgroundColor),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: double.infinity, maxWidth: 1500),
                    child: state.user != null ? Menu(widget.child) : const AuthPage(),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
