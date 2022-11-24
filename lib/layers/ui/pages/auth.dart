import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/auth.dart';

AuthCubit _bloc(BuildContext context) => BlocProvider.of(context);

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit();
    return Scaffold(
      body: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<AuthCubit, AppState>(
          bloc: cubit,
          builder: (context, state) {
            if (state is AuthState) {
              switch (state.pageState) {
                case AuthPageState.login:
                  return const _AuthLoginPage();
                case AuthPageState.registration:
                  return const _AuthPreviewPage();
                case AuthPageState.preview:
                  return const _AuthPreviewPage();
              }
            }
            return Center(
              child: Text('Errrror'),
            );
          },
        ),
      ),
    );
  }
}

class _AuthPreviewPage extends StatelessWidget {
  const _AuthPreviewPage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('preview'),
          ElevatedButton(
              onPressed: () => _bloc(context).setNewState(AuthPageState.login),
              child: const Text('login'))
        ],
      ),
    );
  }
}

class _AuthLoginPage extends StatelessWidget {
  const _AuthLoginPage();

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Column(
      children: [
        TextField(
          controller: emailController,
        ),
        TextField(
          controller: passwordController,
        ),
        ElevatedButton(
            onPressed: () async {
              final token =
                  await _bloc(context).confirm(emailController.text, passwordController.text, '');
              await context.read<AppProvider>().setToken(token);
            },
            child: const Text('confirm'))
      ],
    );
  }
}
