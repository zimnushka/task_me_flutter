import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/service/snackbar.dart';
import 'package:task_me_flutter/layers/bloc/intervals/interval_event.dart';
import 'package:task_me_flutter/layers/bloc/intervals/interval_state.dart';
import 'package:task_me_flutter/layers/repositories/api/interval.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/interval_description_editor.dart';
import 'package:task_me_flutter/layers/ui/pages/task_detail/task_detail.dart';

class IntervalBloc extends Bloc<IntervalEvent, AppState> {
  final _intervalRepository = IntervalApiRepository();

  IntervalBloc() : super(IntervalLoadingState()) {
    on<Load>(_load);
    on<OnTapStart>(_start);
    on<OnTapStop>(_stop);
    on<OpenTask>(_openTask);
  }

  Future<void> _load(Load event, Emitter emit) async {
    final intervals = (await (event.taskId == null
                ? _intervalRepository.getMyIntervals()
                : _intervalRepository.getTaskIntervals(event.taskId!)))
            .data ??
        [];
    final notClosedIntervals =
        intervals.where((e) => e.user.id == event.me.id && e.timeEnd == null).toList();
    emit(IntervalLoadedState(
        me: event.me,
        notClosedInterval: notClosedIntervals,
        intervals: intervals,
        taskId: event.taskId,
        readOnly: event.readOnly));
  }

  Future<void> _stop(OnTapStop event, Emitter emit) async {
    final currentState = state as IntervalLoadedState;
    String? desc;
    await AppRouter.dialog((context) {
      return IntervalDescriptionEditorDialog(initValue: '', onEdit: (val) => desc = val);
    });
    final result = await _intervalRepository.stop(desc);
    if (result.data ?? false) {
      add(Load(currentState.taskId, currentState.readOnly, currentState.me));
    }
  }

  Future<void> _openTask(OpenTask event, Emitter emit) async {
    await AppRouter.goTo(TaskPage.route(event.projectId, taskId: event.taskId));
  }

  Future<void> _start(OnTapStart event, Emitter emit) async {
    final currentState = state as IntervalLoadedState;
    final result = await _intervalRepository.start(event.taskId);
    if (!result.isSuccess) {
      AppSnackBar.show(AppRouter.context, result.message!, AppSnackBarType.error);
    }
    if (result.data != null) {
      add(Load(currentState.taskId, currentState.readOnly, currentState.me));
    }
  }
}
