import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/ui/bloc_state_builder.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/intervals/interval_bloc.dart';
import 'package:task_me_flutter/layers/bloc/intervals/interval_event.dart';
import 'package:task_me_flutter/layers/bloc/intervals/interval_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

IntervalBloc _bloc(BuildContext context) => BlocProvider.of(context);

class TaskIntervalsView extends StatelessWidget {
  const TaskIntervalsView({required this.readOnly, required this.taskId, super.key});
  final bool readOnly;
  final int taskId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_context) =>
          IntervalBloc()..add(Load(taskId, readOnly, _context.read<AppProvider>().state.user!)),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<IntervalBloc>(builder: (state, context) {
      state as IntervalLoadedState;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!state.readOnly)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _Button(),
            ),
          _IntervalsList(state.intervals),
        ],
      );
    });
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntervalBloc, AppState>(builder: (context, state) {
      state as IntervalLoadedState;
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
          onPressed: () {
            if (state.notClosedInterval.isNotEmpty) {
              _bloc(context).add(OnTapStop());
            } else {
              _bloc(context).add(OnTapStart(state.taskId!));
            }
          },
          child: Text(state.notClosedInterval.isNotEmpty ? 'stop' : 'start'),
        ),
      );
    });
  }
}

class _IntervalsList extends StatelessWidget {
  const _IntervalsList(this.intervals);
  final List<TimeInterval> intervals;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => Container(
              color: Colors.black,
              height: 0.5,
              width: double.infinity,
            ),
        shrinkWrap: true,
        primary: true,
        itemCount: intervals.length,
        itemBuilder: (context, index) {
          return _IntervalCard(
            intervals[index],
            isFirst: index == 0,
            isLast: index == intervals.length - 1,
          );
        });
  }
}

class _IntervalCard extends StatelessWidget {
  const _IntervalCard(this.item, {this.isFirst = false, this.isLast = false});
  final TimeInterval item;
  final bool isLast;
  final bool isFirst;

  String _dateToText(DateTime date) {
    return '${date.day} ${monthLabel(date.month)} ${DateFormat('HH:mm').format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
            top: isFirst ? radius : Radius.zero, bottom: isLast ? radius : Radius.zero),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: item.user.color),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(item.user.name, weight: FontWeight.w600),
                  const SizedBox(height: 5),
                  AppText(
                      '${_dateToText(item.timeStart)}${item.timeEnd != null ? '  -  ${_dateToText(item.timeEnd!)}' : ''}')
                ],
              ),
              const Expanded(child: SizedBox()),
              if (item.timeEnd != null) _DurationInterval(item),
            ],
          ),
          const SizedBox(height: 10),
          AppText(item.description)
        ],
      ),
    );
  }
}

class _DurationInterval extends StatelessWidget {
  const _DurationInterval(this.item);

  final TimeInterval item;

  @override
  Widget build(BuildContext context) {
    final duration = item.timeStart.difference(item.timeEnd!).abs();
    return AppText(
        '${duration.inHours > 0 ? '${duration.inHours}h ' : ''}${duration.inMinutes - duration.inHours * 60}min');
  }
}
