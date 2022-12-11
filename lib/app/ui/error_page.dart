import 'package:flutter/material.dart';
import 'package:task_me_flutter/app/models/error.dart';

class AppErrorPage extends StatelessWidget {
  const AppErrorPage(this.error, {super.key});
  final AppError error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error.message),
    );
  }
}
