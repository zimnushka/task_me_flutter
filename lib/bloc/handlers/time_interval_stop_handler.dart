import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/time_interval_stop_event.dart';
import 'package:task_me_flutter/repositories/api/api.dart';

import '../main_bloc.dart';
import '../main_state.dart';

timeIntervalStopHandler(
  TimeIntervalStopEvent event,
  Emitter<MainState> emit,
  MainBloc mainBloc,
) async {
  final result = await mainBloc.state.repo.stopInterval(event.desc);
  if (result.data ?? false) {
    emit(mainBloc.state.withOutTimeInterval);
  }
}
