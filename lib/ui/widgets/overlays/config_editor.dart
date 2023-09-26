import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/app_provider.dart';
import 'package:task_me_flutter/service/config.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';

class ConfigEditorDialog extends StatefulWidget {
  const ConfigEditorDialog({super.key});

  @override
  State<ConfigEditorDialog> createState() => _ConfigEditorDialogState();
}

class _ConfigEditorDialogState extends State<ConfigEditorDialog> {
  final urlBaseApiController = TextEditingController();
  late final provider = context.watch<AppProvider>();

  Future<void> save() async {
    await ConfigService()
        .setConfig(provider.state.config.copyWith(apiBaseUrl: urlBaseApiController.text));
    await provider.setToken('');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final config = provider.state.config;
    urlBaseApiController.text = config.apiBaseUrl;
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
