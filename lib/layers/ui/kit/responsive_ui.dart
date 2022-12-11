import 'package:flutter/material.dart';

abstract class ResponsiveUiController {
  static bool _widthSize = false;
}

class ResponsiveUi extends StatefulWidget {
  const ResponsiveUi({
    required this.child,
    required this.sideBar,
    required this.widthExpand,
    this.onUIChange,
    super.key,
  });
  final Widget sideBar;
  final Widget child;
  final int widthExpand;
  final Function(bool)? onUIChange;

  @override
  State<ResponsiveUi> createState() => _ResponsiveUiState();
}

class _ResponsiveUiState extends State<ResponsiveUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.sideBar,
      body: LayoutBuilder(builder: (context, constraint) {
        ResponsiveUiController._widthSize = constraint.maxWidth < widget.widthExpand;
        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: ResponsiveUiController._widthSize ? 0 : 290,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: widget.sideBar,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: widget.child,
            )),
          ],
        );
      }),
    );
  }
}
