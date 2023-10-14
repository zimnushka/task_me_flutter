import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_me_flutter/bloc/events/update_project_list_event.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/repositories/api/api.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';
import 'package:task_me_flutter/ui/widgets/overlays/color_selector.dart';

class ProjectDialog extends StatefulWidget {
  const ProjectDialog({this.project, super.key});
  final Project? project;

  @override
  State<ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  String projectName = '';
  Color projectColor = defaultPrimaryColor;
  int stepIndex = 0;

  Future<void> save(String name) async {
    if (name.isNotEmpty) return;
    final project = Project(
      title: name,
      color: projectColor.value,
      id: widget.project?.id,
    );

    final vm = context.read<MainBloc>();
    if (widget.project != null) {
      await vm.state.repo.editProject(project);
    } else {
      await vm.state.repo.addProject(project);
    }
    if (mounted) {
      Navigator.pop(context);
      context.read<MainBloc>().add(UpdateProjectListEvent());
    }
  }

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
          setState(() => stepIndex--);
        },
        onSetName: save,
      )
    ];
    return Center(
      child: Theme(
        data: setPrimaryColor(Theme.of(context), projectColor),
        child: Card(
          child: SizedBox(
              width: 320,
              height: 420,
              child:
                  Padding(padding: const EdgeInsets.all(defaultPadding), child: steps[stepIndex])),
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
