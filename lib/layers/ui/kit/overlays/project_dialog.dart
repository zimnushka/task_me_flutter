import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/project.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/color_selector.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class ProjectDialog extends StatefulWidget {
  const ProjectDialog({required this.onUpdate, this.project, super.key});
  final VoidCallback onUpdate;
  final Project? project;

  @override
  State<ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  final ProjectApiRepository projectApiRepository = ProjectApiRepository();
  late String projectName = '';
  late Color projectColor = Theme.of(context).primaryColor;
  int stepIndex = 0;

  @override
  void initState() {
    if (widget.project != null) {
      projectColor = Color(widget.project!.color);
      projectName = widget.project!.title;
    }

    super.initState();
  }

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
            if (value.isNotEmpty) {
              final project =
                  Project(title: value, color: projectColor.value, id: widget.project?.id);
              if (widget.project != null) {
                await projectApiRepository.edit(project);
              } else {
                await projectApiRepository.add(project);
              }

              widget.onUpdate();
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
  void initState() {
    controller.text = widget.initName;
    super.initState();
  }

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
            child: const Text('Save'))
      ],
    );
  }
}
