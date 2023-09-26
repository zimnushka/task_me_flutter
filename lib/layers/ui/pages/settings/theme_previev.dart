import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class ThemePreview extends StatelessWidget {
  const ThemePreview({
    super.key,
    required this.onTap,
    required this.theme,
    required this.height,
    required this.width,
  });
  final ThemeData theme;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Theme(
        data: theme,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            borderRadius: const BorderRadius.all(radius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: const BorderRadius.all(radius),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        _ProjectHeader(theme.primaryColor),
                        const SizedBox(height: 10),
                        _TaskCard(theme.cardColor),
                        const SizedBox(height: 10),
                        _TaskCard(theme.cardColor),
                        const SizedBox(height: 10),
                        _TaskCard(theme.cardColor),
                        const SizedBox(height: 10),
                        _TaskCard(theme.cardColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  const _ProjectHeader(this.color);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(radius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(radius),
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox())
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard(this.color);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(radius),
        ),
        child: Row(
          children: [
            Expanded(child: Container(color: TaskStatus.closed.color)),
            const SizedBox(width: 10),
            Expanded(
              flex: 50,
              child: Container(color: Theme.of(context).disabledColor.withOpacity(0.2)),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
