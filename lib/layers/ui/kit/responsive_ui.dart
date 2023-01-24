import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

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
      // drawerScrimColor: Colors.transparent,
      drawer: Padding(
        padding: const EdgeInsets.all(20),
        child: widget.sideBar,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: double.infinity, maxWidth: 1500),
          child: LayoutBuilder(builder: (context, constraint) {
            ResponsiveUiController._widthSize = constraint.maxWidth < widget.widthExpand;
            final scaffold = Scaffold.of(context);
            if (scaffold.isDrawerOpen) {
              scaffold.closeDrawer();
            }
            return Stack(
              children: [
                Row(
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
                      ),
                    ),
                  ],
                ),
                if (ResponsiveUiController._widthSize)
                  Positioned(
                      top: 270,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.horizontal(right: radius)),
                        child: GestureDetector(
                          onTap: scaffold.openDrawer,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 5, 8),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ))
                else
                  const SizedBox()
              ],
            );
          }),
        ),
      ),
    );
  }
}
