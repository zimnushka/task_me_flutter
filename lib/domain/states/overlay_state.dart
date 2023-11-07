import 'package:equatable/equatable.dart';
import 'package:task_me_flutter/service/snackbar.dart';

class OverlayMessageState extends Equatable {
  final String message;
  final OverlayType type;

  const OverlayMessageState({
    required this.message,
    required this.type,
  });

  @override
  List<Object?> get props => [message, type];
}
