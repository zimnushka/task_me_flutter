import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/repositories/api/api.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';

class InviteMemberDialog extends StatefulWidget {
  const InviteMemberDialog({required this.projectId, required this.onInvite, super.key});
  final int projectId;
  final VoidCallback onInvite;

  @override
  State<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends State<InviteMemberDialog> {
  String? errorMessage;
  final controller = TextEditingController();

  Future<void> save() async {
    if (controller.text.isNotEmpty) {
      setError('Can not be empty');
      return;
    }
    final repo = context.read<MainBloc>().state.repo;
    final success = (await repo.addMemberToProject(controller.text, widget.projectId)).data;
    if (!mounted) return;

    if (success ?? false) {
      Navigator.pop(context);
      widget.onInvite();
    } else {
      setError('User must be registr or this user was added');
    }
  }

  void setError(String mess) {
    setState(() {
      errorMessage = mess;
    });
    Timer(const Duration(seconds: 3), () {
      setState(() {
        errorMessage = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          width: 320,
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter email new member', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: defaultPadding),
                TextField(
                  controller: controller,
                  onEditingComplete: save,
                  decoration: InputDecoration(errorText: errorMessage),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                  onPressed: save,
                  child: const Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
