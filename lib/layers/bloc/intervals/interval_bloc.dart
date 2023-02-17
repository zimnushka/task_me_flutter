import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/bloc/intervals/interval_event.dart';
import 'package:task_me_flutter/layers/bloc/intervals/interval_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/interval.dart';

class IntervalBloc extends Bloc<IntervalEvent, AppState> {
  final _intervalRepository = IntervalApiRepository();
  final List<User> _users = [];

  IntervalBloc() : super(IntervalLoadingState()) {
    on<Load>(_load);
    on<OnTapStart>(_start);
    on<OnTapStop>(_stop);
  }

  Future<void> _load(Load event, Emitter emit) async {
    _users.clear();
    _users.addAll(event.users);
    final intervals = (await _intervalRepository.getTaskIntervals(event.taskId)).data ?? [];
    final intervalsUi = intervals
        .map((e) => TimeIntervalUi(e, _users.firstWhere((element) => element.id == e.userId)))
        .toList();
    final notClosedIntervals =
        intervals.where((e) => e.userId == event.me.id && e.timeEnd == null).toList();
    emit(IntervalLoadedState(
        me: event.me,
        notClosedInterval: notClosedIntervals.isEmpty ? null : notClosedIntervals.first,
        intervals: intervalsUi,
        taskId: event.taskId,
        readOnly: event.readOnly));
  }

  Future<void> _stop(OnTapStop event, Emitter emit) async {
    final currentState = state as IntervalLoadedState;
    final result = await _intervalRepository.stop(currentState.taskId);
    if (result.data ?? false) {
      add(Load(currentState.taskId, currentState.readOnly,
          currentState.intervals.map((e) => e.user).toList(), currentState.me));
    }
  }

  Future<void> _start(OnTapStart event, Emitter emit) async {
    final currentState = state as IntervalLoadedState;
    final result = await _intervalRepository.start(currentState.taskId);
    if (result.data != null) {
      add(Load(currentState.taskId, currentState.readOnly, List.of(_users), currentState.me));
    }
  }
}
