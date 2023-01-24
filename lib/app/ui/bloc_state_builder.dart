import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/ui/error_page.dart';
import 'package:task_me_flutter/app/ui/loader.dart';

class BlocStateBuilder<B extends StateStreamable<AppState>> extends StatelessWidget {
  const BlocStateBuilder({
    required this.builder,
    this.errorBuilder,
    this.loadingBuilder,
    super.key,
  });
  final Widget Function(AppLoadingState, BuildContext)? loadingBuilder;
  final Widget Function(AppErrorState, BuildContext)? errorBuilder;
  final Widget Function(AppLoadedState, BuildContext) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, AppState>(builder: (context, state) {
      if (state is AppLoadedState) {
        return builder(state, context);
      }
      if (state is AppLoadingState) {
        if (loadingBuilder != null) {
          return loadingBuilder!(state, context);
        } else {
          return const AppLoadingIndecator();
        }
      }
      if (state is AppErrorState) {
        if (errorBuilder != null) {
          return errorBuilder!(state, context);
        } else {
          return AppErrorPage(state.error);
        }
      }
      return const SizedBox();
    });
  }
}
