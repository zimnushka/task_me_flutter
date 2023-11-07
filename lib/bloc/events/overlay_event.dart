import 'package:task_me_flutter/bloc/main_event.dart';
import 'package:task_me_flutter/service/snackbar.dart';

class OverlayEvent extends MainEvent {
  final String message;
  final OverlayType type;

  OverlayEvent({
    required this.message,
    required this.type,
  });
}
