import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with TickerProviderStateMixin {
  bool isExpanded = false;
  late final themeController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isExpanded ? 250 : 80,
        height: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(radius),
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: const BorderRadius.all(radius),
              ),
              child: TabBar(
                  controller: themeController,
                  onTap: (value) {
                    context
                        .read<AppProvider>()
                        .setTheme(isLightTheme: value == 0, color: Colors.red);
                  },
                  indicator: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(radius),
                  ),
                  tabs: const [
                    Tab(text: 'light'),
                    Tab(text: 'dark'),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
