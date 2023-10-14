import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/overlay_event.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/bloc/main_state.dart';
import 'package:task_me_flutter/service/snackbar.dart';

class OverlayListener extends StatelessWidget {
  const OverlayListener({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listenWhen: (previousState, state) {
        if (!(state.overlayState == previousState.overlayState)) {
          return true;
        }
        return false;
      },
      listener: ((context, state) {
        if (state.overlayState.message != '') {
          OverlayManager.showOverlayMessage(
            overlayState: Overlay.of(context),
            messageText: state.overlayState.message,
            backgroundColor: Colors.white,
          );
          context.read<MainBloc>().add(OverlayEvent(message: '', type: OverlayType.none));
        }
      }),
      child: child,
    );
  }
}
