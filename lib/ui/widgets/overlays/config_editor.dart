import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/set_config_event.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';

class ConfigEditorDialog extends StatefulWidget {
  const ConfigEditorDialog({super.key});

  @override
  State<ConfigEditorDialog> createState() => _ConfigEditorDialogState();
}

class _ConfigEditorDialogState extends State<ConfigEditorDialog> {
  final urlBaseApiController = TextEditingController();

  Future<void> save() async {
    final vm = context.read<MainBloc>();
    vm.add(SetConfigEvent(vm.state.config.copyWith(apiBaseUrl: urlBaseApiController.text)));
    Navigator.pop(context);
  }

  @override
  void initState() {
    final config = context.read<MainBloc>().state.config;
    urlBaseApiController.text = config.apiBaseUrl;
    super.initState();
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
                Text('Set url', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: defaultPadding),
                TextField(controller: urlBaseApiController),
                const SizedBox(height: 30),
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
