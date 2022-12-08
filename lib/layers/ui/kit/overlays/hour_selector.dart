import 'dart:async';

import 'package:flutter/material.dart';

class SelectHourCountDialog extends StatefulWidget {
  const SelectHourCountDialog({required this.onSetHourCount, super.key});
  final Function(int) onSetHourCount;

  @override
  State<SelectHourCountDialog> createState() => _SelectHourCountDialogState();
}

class _SelectHourCountDialogState extends State<SelectHourCountDialog> {
  String? errorMessage;
  final TextEditingController controller = TextEditingController();

  void setHour() {
    final count = int.tryParse(controller.text);
    if (count != null) {
      Navigator.pop(context);
      widget.onSetHourCount(count);
    } else {
      setState(() {
        errorMessage = 'Can not be a number';
      });
      Timer(const Duration(seconds: 1), () {
        setState(() {
          errorMessage = null;
        });
      });
    }
  }

  @override
  void initState() {
    controller.text = '0';
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
                Text('Select hours count', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  onEditingComplete: setHour,
                  decoration: InputDecoration(errorText: errorMessage),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                    onPressed: setHour,
                    child: const Text('Save'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
