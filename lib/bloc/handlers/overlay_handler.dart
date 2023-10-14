import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/overlay_event.dart';
import 'package:task_me_flutter/domain/states/overlay_state.dart';

import '../main_bloc.dart';
import '../main_state.dart';

overlayHandler(
  OverlayEvent event,
  Emitter<MainState> emit,
  MainBloc mainBloc,
) async {
  MainState state = mainBloc.state.copyWith(
    overlayState: OverlayMessageState(
      message: event.message,
      type: event.type,
    ),
  );
  emit(state);
}
