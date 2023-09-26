import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';

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
            child: Text('Select color', style: Theme.of(context).textTheme.titleLarge)),
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
            child: const Text('Select'))
      ],
    );
  }
}
