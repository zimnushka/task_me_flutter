import 'package:flutter/material.dart';

String monthLabel(int indexMonth) => _month[indexMonth - 1];

const _month = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Now',
  'Dec',
];

class TextBold extends StatelessWidget {
  const TextBold(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
