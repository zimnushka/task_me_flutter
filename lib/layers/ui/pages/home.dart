import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/ui/kit/responsive_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: ResponsiveUiController.openDrawer,
          child: Center(
            child: Text('TASKME'),
          )),
    );
  }
}
