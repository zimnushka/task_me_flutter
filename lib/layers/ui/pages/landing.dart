import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/appProvider.dart';
import 'package:task_me_flutter/layers/ui/pages/auth.dart';

class AppProvider extends StatelessWidget {
  final Widget child;
  const AppProvider(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    final AppCubit cubit = AppCubit();
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<AppCubit, AppState>(
          bloc: cubit,
          builder: (context, state) {
            return Theme(
              data: state.theme,
              child: state.user != null ? child : const AuthPage(),
            );
          }),
    );
  }
}
