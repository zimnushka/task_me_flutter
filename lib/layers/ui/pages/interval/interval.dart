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

class IntervalView extends StatelessWidget {
  const IntervalView(
      {required this.users, required this.readOnly, required this.taskId, super.key});
  final bool readOnly;
  final List<User> users;
  final int taskId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_context) => IntervalBloc()
        ..add(Load(taskId, readOnly, users, _context.read<AppProvider>().state.user!)),
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
      final hasNotClosedInterval = state.notClosedInterval != null;
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
          onPressed: () {
            if (hasNotClosedInterval) {
              _bloc(context).add(OnTapStop());
            } else {
              _bloc(context).add(OnTapStart());
            }
          },
          child: Text(hasNotClosedInterval ? 'stop' : 'start'),
        ),
      );
    });
  }
}

class _IntervalsList extends StatelessWidget {
  const _IntervalsList(this.intervals);
  final List<TimeIntervalUi> intervals;

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
  final TimeIntervalUi item;
  final bool isLast;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: isFirst
            ? const BorderRadius.vertical(top: radius)
            : isLast
                ? const BorderRadius.vertical(bottom: radius)
                : null,
        color: Theme.of(context).cardColor,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        title: Text(item.user.name),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DateText(item.interval.timeStart),
            if (item.interval.timeEnd != null)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: _DateText(item.interval.timeEnd!),
              )
          ],
        ),
      ),
    );
  }
}

class _DateText extends StatelessWidget {
  const _DateText(this.date);
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text('${date.day} ${monthLabel(date.month)} ${DateFormat('HH:mm').format(date)}');
  }
}
