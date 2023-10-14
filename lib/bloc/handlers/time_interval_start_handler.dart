import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/time_interval_start_event.dart';
import 'package:task_me_flutter/domain/states/overlay_state.dart';
import 'package:task_me_flutter/repositories/api/api.dart';
import 'package:task_me_flutter/service/snackbar.dart';

import '../main_bloc.dart';
import '../main_state.dart';

timeIntervalStartHandler(
  TimeIntervalStartEvent event,
  Emitter<MainState> emit,
  MainBloc mainBloc,
) async {
  final result = await mainBloc.state.repo.startInterval(event.taskId);
  if (!result.isSuccess) {
    emit(
      mainBloc.state.withOutTimeInterval.copyWith(
        overlayState: OverlayMessageState(message: result.message!, type: OverlayType.error),
      ),
    );

    return;
  }

  emit(mainBloc.state.copyWith(currentTimeInterval: result.data));
}
