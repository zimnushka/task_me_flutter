import 'package:flutter/material.dart';

class AppLoadingIndecator extends StatefulWidget {
  const AppLoadingIndecator({super.key});

  @override
  State<AppLoadingIndecator> createState() => _AppLoadingIndecatorState();
}

class _AppLoadingIndecatorState extends State<AppLoadingIndecator> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
