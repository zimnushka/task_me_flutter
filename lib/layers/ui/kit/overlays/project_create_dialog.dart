import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class ProjectCreateDialog extends StatelessWidget {
  const ProjectCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
          width: 300,
          height: 300,
          child: Stepper(steps: [Step(title: Text('Color'), content: _ColorSelector())])),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  const _ColorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      enableAlpha: false,
      pickerAreaBorderRadius: const BorderRadius.all(radius),
      showLabel: false,
      portraitOnly: true,
      pickerColor: Theme.of(context).primaryColor,
      onColorChanged: (value) {},
    );
  }
}
