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

class AppMainTitleText extends StatelessWidget {
  const AppMainTitleText(this.text, {this.color, this.weight, this.maxLines});
  final String text;
  final Color? color;
  final FontWeight? weight;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines, style: TextStyle(fontSize: 25, fontWeight: weight, color: color));
  }
}

class AppTitleText extends StatelessWidget {
  const AppTitleText(this.text, {this.color, this.weight, this.maxLines});
  final String text;
  final Color? color;
  final FontWeight? weight;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines, style: TextStyle(fontSize: 18, fontWeight: weight, color: color));
  }
}

class AppText extends StatelessWidget {
  const AppText(this.text, {this.color, this.weight, this.maxLines});
  final String text;
  final Color? color;
  final FontWeight? weight;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines, style: TextStyle(fontSize: 14, fontWeight: weight, color: color));
  }
}

class AppSmallText extends StatelessWidget {
  const AppSmallText(this.text, {this.color, this.weight, this.maxLines});
  final String text;
  final Color? color;
  final FontWeight? weight;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines, style: TextStyle(fontSize: 10, fontWeight: weight, color: color));
  }
}
