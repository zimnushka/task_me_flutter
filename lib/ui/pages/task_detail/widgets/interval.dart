import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/bloc/main_state.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/ui/pages/task_detail/task_vm.dart';
import 'package:task_me_flutter/ui/styles/text.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';
import 'package:task_me_flutter/ui/widgets/overlays/interval_description_editor.dart';

class TaskIntervalsView extends StatelessWidget {
  const TaskIntervalsView({required this.taskId, super.key});
  final int taskId;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TaskDetailVM>();
    final state = context.select((TaskDetailVM vm) => vm.state);
    final intervals = context.select((TaskDetailVM vm) => vm.intervals);
    final readOnly = state == TaskDetailPageState.view;

    return BlocListener<MainBloc, MainState>(
      listenWhen: (prev, cur) {
        return prev.currentTimeInterval != cur.currentTimeInterval;
      },
      listener: (context, state) {
        vm.updateIntervals();
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: defaultPadding),
              child: AppTitleText('Time intervals'),
            ),
            if (!readOnly)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 10),
                child: _Button(),
              ),
            Expanded(
              child: _IntervalsList(intervals),
            ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TaskDetailVM>();
    final hasNotClosedInterval =
        context.select((MainBloc vm) => vm.state.currentTimeInterval != null);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
        onPressed: () {
          if (hasNotClosedInterval) {
            showDialog(
              context: context,
              builder: (context) => IntervalDescriptionEditorDialog(
                initValue: '',
                onEdit: (val) {
                  vm.stopInterval(val);
                },
              ),
            );
          } else {
            vm.startInterval();
          }
        },
        child: Text(hasNotClosedInterval ? 'stop' : 'start'),
      ),
    );
  }
}

class _IntervalsList extends StatelessWidget {
  const _IntervalsList(this.intervals);
  final List<TimeInterval> intervals;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, defaultPadding),
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
          );
        });
  }
}

class _IntervalCard extends StatelessWidget {
  const _IntervalCard(this.item);
  final TimeInterval item;

  String _dateToText(DateTime date) {
    return '${date.day} ${monthLabel(date)} ${DateFormat('HH:mm').format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
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
