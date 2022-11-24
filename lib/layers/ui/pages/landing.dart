import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/ui/pages/auth.dart';

class AppProviderWidget extends StatelessWidget {
  final Widget child;
  const AppProviderWidget(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppProvider cubit = AppProvider();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: double.infinity, maxWidth: 1500),
        child: BlocProvider.value(
          value: cubit,
          child: BlocBuilder<AppProvider, AppProviderState>(
              bloc: cubit,
              builder: (context, state) {
                return Theme(
                  data: state.theme,
                  child: state.user != null ? child : const AuthPage(),
                );
              }),
        ),
      ),
    );
  }
}
