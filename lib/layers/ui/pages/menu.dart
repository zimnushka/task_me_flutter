import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/ui/kit/sidebar.dart';

class Menu extends StatefulWidget {
  const Menu(this.child, {super.key});
  final Widget child;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
            child: widget.child,
          )),
        ],
      ),
    );
  }
}
