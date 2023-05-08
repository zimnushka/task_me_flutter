import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/intervals/interval_bloc.dart';
import 'package:task_me_flutter/layers/bloc/intervals/interval_event.dart';
import 'package:task_me_flutter/layers/bloc/intervals/interval_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

IntervalBloc _bloc(BuildContext context) => BlocProvider.of(context);

class HomeIntervalsView extends StatefulWidget {
  const HomeIntervalsView({super.key});

  @override
  State<HomeIntervalsView> createState() => _HomeIntervalsViewState();
}

class _HomeIntervalsViewState extends State<HomeIntervalsView> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocProvider(
        create: (_context) =>
            IntervalBloc()..add(Load(null, false, _context.read<AppProvider>().state.user!)),
        child: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<IntervalBloc>(builder: (state, context) {
      state as IntervalLoadedState;
      if (state.notClosedInterval.isEmpty) {
        return const SizedBox();
      }
      return SizedBox(
        height: 130,
        width: double.infinity,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: state.notClosedInterval.length,
          itemBuilder: (context, index) {
            final item = state.notClosedInterval[index];
            return _ItemCard(
              item,
              () => _bloc(context).add(OpenTask(item.task.id, item.task.projectId)),
              () => _bloc(context).add(OnTapStop(item.task.id)),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(
            width: 10,
          ),
        ),
      );
    });
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(radius),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          children: [
            AppText(item.task.title, maxLines: 2),
            const Expanded(child: SizedBox()),
            AppText('${time.inHours}h ${time.inMinutes - time.inHours * 60}m'),
            const SizedBox(height: 10),
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
      ),
    );
  }
}
