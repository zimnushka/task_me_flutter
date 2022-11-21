import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit();
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<AuthCubit, AuthState>(
        bloc: cubit,
        builder: (context, state) {
          switch (state.pageState) {
            case AuthPageState.login:
              return const _AuthPreviewPage();
            case AuthPageState.registration:
              return const _AuthPreviewPage();
            case AuthPageState.preview:
              return const _AuthPreviewPage();
          }
        },
      ),
    );
  }
}

class _AuthPreviewPage extends StatelessWidget {
  const _AuthPreviewPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('preview'),
      ),
    );
  }
}
