import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> _responsiveUiDrawerKey = GlobalKey<ScaffoldState>();

abstract class ResponsiveUiController {
  static bool _widthSize = false;
  // static set _newValueWidthSize(bool value) {
  //   if (_responsiveUiDrawerKey.currentState?.isDrawerOpen == true) {
  //     _responsiveUiDrawerKey.currentState?.closeDrawer();
  //   }
  //   bool _widthSize = value;
  // }

  static Future<void> openDrawer() async {
    if (!_widthSize) {
      _responsiveUiDrawerKey.currentState?.openDrawer();
    }
  }
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
      key: _responsiveUiDrawerKey,
      drawer: widget.sideBar,
      body: LayoutBuilder(builder: (context, constraint) {
        ResponsiveUiController._widthSize = true;
        if (constraint.maxWidth < widget.widthExpand) {
          ResponsiveUiController._widthSize = false;
          return widget.child;
        }
        return Row(
          children: [
            widget.sideBar,
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: widget.child,
            )),
          ],
        );
      }),
    );
  }
}
