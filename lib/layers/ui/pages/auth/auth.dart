import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/auth.dart';
import 'package:task_me_flutter/layers/ui/pages/auth/poster.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

AuthCubit _bloc(BuildContext context) => BlocProvider.of(context);

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final cubit = AuthCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<AuthCubit, AuthState>(
          bloc: cubit,
          builder: (context, state) {
            return state.pageState == AuthPageState.none
                ? const AuthPoster()
                : Center(
                    child: Container(
                      margin: const EdgeInsets.all(defaultPadding),
                      padding: const EdgeInsets.all(defaultPadding),
                      width: 300,
                      height: 400,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.all(radius)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => _bloc(context).setConfig(),
                                icon: const Icon(Icons.settings_outlined),
                              ),
                              IconButton(
                                onPressed: () => _bloc(context).setNewState(AuthPageState.none),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: defaultPadding),
                          Expanded(
                            child: Center(
                              child: cubit.state.pageState == AuthPageState.login
                                  ? const _AuthLoginPage()
                                  : const _AuthRegistrPage(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
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
    final provider = context.read<AppProvider>();
    final token = await _bloc(context).confirm(emailController.text, passwordController.text);
    if (token != null) {
      await provider.setToken(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final errMess = context.select((AuthCubit cubit) => cubit.state.authErrorMessage);
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
    final provider = context.read<AppProvider>();
    final token = await _bloc(context)
        .confirm(emailController.text, passwordController.text, name: nameController.text);
    if (token != null) {
      await provider.setToken(token);
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
