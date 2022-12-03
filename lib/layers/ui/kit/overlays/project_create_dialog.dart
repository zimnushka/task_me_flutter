import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/project.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class ProjectCreateDialog extends StatefulWidget {
  const ProjectCreateDialog({required this.onCreate, super.key});
  final VoidCallback onCreate;

  @override
  State<ProjectCreateDialog> createState() => _ProjectCreateDialogState();
}

class _ProjectCreateDialogState extends State<ProjectCreateDialog> {
  late Color projectColor = Theme.of(context).primaryColor;
  final ProjectApiRepository projectApiRepository = ProjectApiRepository();
  String projectName = '';

  int stepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> steps = [
      ColorSelector(
        initColor: projectColor,
        onSetColor: (value) {
          setState(() {
            projectColor = value;
            stepIndex++;
          });
        },
      ),
      _NameSelector(
          initName: projectName,
          onBack: () {
            setState(() {
              stepIndex--;
            });
          },
          onSetName: (value) async {
            final response = await projectApiRepository.add(
              Project(
                title: value,
                color: projectColor.value,
              ),
            );
            if (response.data) {
              widget.onCreate();
              Navigator.pop(context);
            }
          })
    ];
    return Center(
      child: Theme(
        data: setPrimaryColor(Theme.of(context), projectColor),
        child: Card(
          child: SizedBox(
              width: 320,
              height: 420,
              child: Padding(padding: const EdgeInsets.all(20), child: steps[stepIndex])),
        ),
      ),
    );
  }
}

class ColorSelector extends StatefulWidget {
  const ColorSelector({required this.initColor, required this.onSetColor, Key? key})
      : super(key: key);
  final Function(Color) onSetColor;
  final Color initColor;

  @override
  State<ColorSelector> createState() => ColorSelectorState();
}

class ColorSelectorState extends State<ColorSelector> {
  late Color selectedColor = widget.initColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Select project color', style: Theme.of(context).textTheme.titleLarge)),
        const SizedBox(height: 10),
        ColorPicker(
          enableAlpha: false,
          pickerAreaBorderRadius: const BorderRadius.all(radius),
          pickerAreaHeightPercent: 0.78,
          labelTypes: const [],
          portraitOnly: true,
          pickerColor: selectedColor,
          onColorChanged: (value) {
            setState(() {
              selectedColor = value;
            });
          },
        ),
        const Expanded(child: SizedBox()),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40), backgroundColor: selectedColor),
            onPressed: () => widget.onSetColor(selectedColor.withAlpha(255)),
            child: const Text('Next'))
      ],
    );
  }
}

class _NameSelector extends StatefulWidget {
  const _NameSelector(
      {required this.initName, required this.onSetName, required this.onBack, Key? key})
      : super(key: key);
  final Function(String) onSetName;
  final VoidCallback onBack;
  final String initName;

  @override
  State<_NameSelector> createState() => __NameSelectorState();
}

class __NameSelectorState extends State<_NameSelector> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            BackButton(onPressed: widget.onBack),
            Text('Select project name', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          onEditingComplete: () => widget.onSetName(controller.text),
        ),
        const Expanded(child: SizedBox()),
        ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
            onPressed: () => widget.onSetName(controller.text),
            child: Text('Add'))
      ],
    );
  }
}
