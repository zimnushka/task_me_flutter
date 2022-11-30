import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppLoadingIndecator extends StatefulWidget {
  const AppLoadingIndecator({super.key});

  @override
  State<AppLoadingIndecator> createState() => _AppLoadingIndecatorState();
}

class _AppLoadingIndecatorState extends State<AppLoadingIndecator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
