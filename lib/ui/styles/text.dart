import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String monthLabel(DateTime date) {
  return DateFormat('MMM').format(date);
}

class AppLabelTitleText extends StatelessWidget {
  const AppLabelTitleText(this.text, {super.key, this.color, this.weight, this.maxLines});
  final String text;
  final Color? color;
  final FontWeight? weight;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines, style: TextStyle(fontSize: 30, fontWeight: weight, color: color));
  }
}

class AppMainTitleText extends StatelessWidget {
  const AppMainTitleText(this.text, {super.key, this.color, this.weight, this.maxLines});
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
  const AppTitleText(this.text, {super.key, this.color, this.weight, this.maxLines});
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
  const AppText(this.text, {super.key, this.color, this.weight, this.maxLines});
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
  const AppSmallText(this.text, {super.key, this.color, this.weight, this.maxLines});
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
