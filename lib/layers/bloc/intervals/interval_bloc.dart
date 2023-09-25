import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/service/snackbar.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/interval.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/interval_description_editor.dart';
import 'package:task_me_flutter/layers/ui/pages/task_detail/task_detail.dart';

class IntervalVM extends ChangeNotifier {
  final _intervalRepository = IntervalApiRepository();

  IntervalVM({
    required this.taskId,
    required this.readOnly,
    required this.me,
  }) {
    _init();
  }

  final int? taskId;
  final bool readOnly;
  final User me;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<TimeInterval> _intervals = [];
  List<TimeInterval> get intervals => _intervals;

  List<TimeInterval> _notClosedIntervals = [];
  List<TimeInterval> get notClosedIntervals => _notClosedIntervals;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    if (taskId == null) {
      _intervals = (await _intervalRepository.getMyIntervals()).data ?? [];
    } else {
      _intervals = (await _intervalRepository.getTaskIntervals(taskId!)).data ?? [];
    }

    _notClosedIntervals = _intervals.where((e) => e.user.id == me.id && e.timeEnd == null).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _update() async {
    _isLoading = true;
    notifyListeners();
    if (taskId == null) {
      _intervals = (await _intervalRepository.getMyIntervals()).data ?? [];
    } else {
      _intervals = (await _intervalRepository.getTaskIntervals(taskId!)).data ?? [];
    }

    _notClosedIntervals = _intervals.where((e) => e.user.id == me.id && e.timeEnd == null).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> stopInterval() async {
    String? desc;
    await AppRouter.dialog((context) {
      return IntervalDescriptionEditorDialog(initValue: '', onEdit: (val) => desc = val);
    });
    final result = await _intervalRepository.stop(desc);
    if (result.data ?? false) {
      _update();
    }
  }

  Future<void> openTask(int taskId, int projectId) async {
    await AppRouter.goTo(TaskPage.route(projectId, taskId: taskId));
  }

  Future<void> startInterval(int taskId) async {
    final result = await _intervalRepository.start(taskId);
    if (!result.isSuccess) {
      AppSnackBar.show(AppRouter.context, result.message!, AppSnackBarType.error);
    }
    if (result.data != null) {
      _update();
    }
  }
}
