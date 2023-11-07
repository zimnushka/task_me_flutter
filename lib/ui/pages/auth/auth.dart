import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/ui/pages/auth/auth_vm.dart';
import 'package:task_me_flutter/ui/pages/auth/poster.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';
import 'package:task_me_flutter/ui/widgets/overlays/config_editor.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return ChangeNotifierProvider(
      create: (context) => AuthVM(mainBloc: mainBloc),
      child: const _AuthPageView(),
    );
  }
}

class _AuthPageView extends StatelessWidget {
  const _AuthPageView();

  @override
  Widget build(BuildContext context) {
    final pageState = context.select((AuthVM vm) => vm.pageState);

    return Scaffold(
      drawer: Container(
        margin: const EdgeInsets.all(defaultPadding),
        padding: const EdgeInsets.all(defaultPadding),
        constraints: const BoxConstraints(maxWidth: 350),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(radius),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ConfigEditorDialog(),
                    );
                  },
                  icon: const Icon(Icons.settings_outlined),
                ),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: pageState == AuthPageState.login
                    ? const _AuthLoginPage()
                    : const _AuthRegistrPage(),
              ),
            ),
          ],
        ),
      ),
      body: const AuthPoster(),
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
    final vm = context.read<AuthVM>();
    await vm.confirm(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final errMess = context.select((AuthVM vm) => vm.authErrorMessage);
    final vm = context.read<AuthVM>();
    return Column(
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
        const SizedBox(height: 10),
        TextButton(
            onPressed: () => vm.setNewState(AuthPageState.registration),
            child: const Text('create account?'))
      ],
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
    final vm = context.read<AuthVM>();
    await vm.confirm(emailController.text, passwordController.text, name: nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<AuthVM>();
    return Column(
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
        const SizedBox(height: 10),
        TextButton(
            onPressed: () => vm.setNewState(AuthPageState.login), child: const Text('login?'))
      ],
    );
  }
}
