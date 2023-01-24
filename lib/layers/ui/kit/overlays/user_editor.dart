import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class UserEditDialog extends StatefulWidget {
  const UserEditDialog({super.key});

  @override
  State<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<UserEditDialog> {
  String? errorCostMessage;
  String? errorNameMessage;
  String? errorEmailMessage;
  late final User initialUser;
  late final provider = context.read<AppProvider>();
  final costController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> save() async {
    final count = int.tryParse(costController.text);
    if (count != null) {
      if (nameController.text.isEmpty || emailController.text.isEmpty) {
        setState(() {
          errorNameMessage = 'Name is empty';
          errorEmailMessage = 'Email is empty';
        });
        Timer(const Duration(seconds: 1), () {
          setState(() {
            errorNameMessage = null;
            errorEmailMessage = null;
          });
        });
        return;
      } else {
        final user = initialUser.copyWith(
          name: nameController.text,
          email: emailController.text,
          cost: count,
        );

        Navigator.pop(context);
        await provider.updateUser(user);
      }
    } else {
      setState(() {
        errorCostMessage = 'Can not be a number';
      });
      Timer(const Duration(seconds: 1), () {
        setState(() {
          errorCostMessage = null;
        });
      });
    }
  }

  @override
  void initState() {
    initialUser = provider.state.user!;
    nameController.text = initialUser.name;
    emailController.text = initialUser.email;
    costController.text = initialUser.cost.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          width: 320,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit user', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                const Text('Name'),
                const SizedBox(height: 5),
                TextField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(errorText: errorNameMessage),
                ),
                const SizedBox(height: 10),
                const Text('Email'),
                const SizedBox(height: 5),
                TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(errorText: errorEmailMessage),
                ),
                const SizedBox(height: 10),
                const Text('Hourly payment'),
                const SizedBox(height: 5),
                TextField(
                  controller: costController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(errorText: errorCostMessage),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                    onPressed: save,
                    child: const Text('Save'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
