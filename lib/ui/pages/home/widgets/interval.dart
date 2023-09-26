import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_me_flutter/bloc/app_provider.dart';
import 'package:task_me_flutter/bloc/interval_vm.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/ui/pages/home/widgets/circle_animation.dart';
import 'package:task_me_flutter/ui/styles/text.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';

class HomeIntervalsView extends StatefulWidget {
  const HomeIntervalsView({super.key});

  @override
  State<HomeIntervalsView> createState() => _HomeIntervalsViewState();
}

class _HomeIntervalsViewState extends State<HomeIntervalsView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IntervalVM(
        taskId: null,
        readOnly: false,
        me: context.read<AppProvider>().state.user!,
      ),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final notClosedInterval = context.select((IntervalVM vm) => vm.notClosedIntervals);
    final vm = context.read<IntervalVM>();
    if (notClosedInterval.isEmpty) {
      return const SizedBox();
    }
    if (notClosedInterval.isNotEmpty) {
      final item = notClosedInterval.first;
      return _ItemCard(
        item,
        () => vm.openTask(item.task.id, item.task.projectId),
        () => vm.stopInterval(),
      );
    }
    return const SizedBox();
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard(this.item, this.onTap, this.onStop);
  final TimeInterval item;
  final VoidCallback onTap;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now().difference(item.timeStart);
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(radius),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSmallText('Current time interval'),
                    AppTitleText(item.task.title, maxLines: 2),
                    const Expanded(child: SizedBox()),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      onPressed: onStop,
                      child: const AppText('stop'),
                    ),
                  ],
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    children: [
                      const CircleAnimation(),
                      Center(
                        child: AppText('${time.inHours}h ${time.inMinutes - time.inHours * 60}m'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
