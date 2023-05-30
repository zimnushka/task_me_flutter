import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/ui/error_page.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/auth.dart';
import 'package:task_me_flutter/layers/ui/kit/slide_animation_container.dart';
import 'package:task_me_flutter/layers/ui/pages/auth/poster.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

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
              return Row(
                children: [
                  const AuthPoster(),
                  Container(
                      color: Theme.of(context).cardColor,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () => _bloc(context).setConfig(),
                            icon: const Icon(Icons.settings_outlined),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: state.pageState == AuthPageState.login
                                  ? const SlideAnimatedContainer(
                                      duration: Duration(milliseconds: 600),
                                      start: Offset(1, 0),
                                      end: Offset.zero,
                                      curve: Curves.easeOut,
                                      child: _AuthLoginPage(),
                                    )
                                  : const SlideAnimatedContainer(
                                      duration: Duration(milliseconds: 600),
                                      start: Offset(1, 0),
                                      end: Offset.zero,
                                      curve: Curves.easeOut,
                                      child: _AuthRegistrPage(),
                                    ),
                            ),
                          ),
                        ],
                      )),
                ],
              );
            } else if (state is AppErrorState) {
              return AppErrorPage(state.error);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _AuthLoginPage extends StatefulWidget {
  const _AuthLoginPage();

  @override
  State<_AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<_AuthLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> confirm() async {
    final token = await _bloc(context).confirm(emailController.text, passwordController.text);
    if (token != null) {
      await context.read<AppProvider>().setToken(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final errMess = (context.watch<AuthCubit>().state as AuthState).authErrorMessage;
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutofillGroup(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.username],
                  decoration: const InputDecoration(hintText: 'email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(hintText: 'password'),
                  autofillHints: const <String>[AutofillHints.password],
                  obscureText: true,
                  onEditingComplete: confirm,
                ),
              ],
            ),
          ),
          if (errMess != null)
            ListTile(
              leading: Icon(
                Icons.info,
                color: Theme.of(context).colorScheme.error,
              ),
              minLeadingWidth: 10,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              title: Text(errMess, maxLines: 2),
            )
          else
            const SizedBox(height: defaultPadding),
          ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
              onPressed: confirm,
              child: const Text('sign in')),
          TextButton(
              onPressed: () => _bloc(context).setNewState(AuthPageState.registration),
              child: const Text('create account?'))
        ],
      ),
    );
  }
}

class _AuthRegistrPage extends StatefulWidget {
  const _AuthRegistrPage();

  @override
  State<_AuthRegistrPage> createState() => _AuthRegistrPageState();
}

class _AuthRegistrPageState extends State<_AuthRegistrPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> confirm() async {
    final token = await _bloc(context)
        .confirm(emailController.text, passwordController.text, name: nameController.text);
    if (token != null) {
      await context.read<AppProvider>().setToken(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutofillGroup(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.username],
                  decoration: const InputDecoration(hintText: 'name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.email],
                  decoration: const InputDecoration(hintText: 'email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(hintText: 'password'),
                  autofillHints: const <String>[AutofillHints.password],
                  obscureText: true,
                  onEditingComplete: confirm,
                ),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
              onPressed: confirm,
              child: const Text('sign up')),
          TextButton(
              onPressed: () => _bloc(context).setNewState(AuthPageState.login),
              child: const Text('login?'))
        ],
      ),
    );
  }
}
