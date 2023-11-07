import 'package:task_me_flutter/domain/models/schemes.dart';

class TaskPercent {
  final TaskStatus status;
  final double percent;
  final int taskCount;

  const TaskPercent({
    required this.percent,
    required this.status,
    required this.taskCount,
  });
}
