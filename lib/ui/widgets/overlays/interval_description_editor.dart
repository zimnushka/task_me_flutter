import 'package:flutter/material.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';

class IntervalDescriptionEditorDialog extends StatefulWidget {
  const IntervalDescriptionEditorDialog({required this.initValue, required this.onEdit, super.key});
  final String initValue;
  final Function(String? value) onEdit;

  @override
  State<IntervalDescriptionEditorDialog> createState() => _IntervalDescriptionEditorDialogState();
}

class _IntervalDescriptionEditorDialogState extends State<IntervalDescriptionEditorDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add description', style: Theme.of(context).textTheme.titleLarge),
                    const CloseButton(),
                  ],
                ),
                const SizedBox(height: defaultPadding),
                TextField(
                  autofocus: true,
                  controller: controller,
                  maxLines: 3,
                  minLines: 3,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                  onPressed: () {
                    widget.onEdit(controller.text);
                    Navigator.of(context).pop();
                  },
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
