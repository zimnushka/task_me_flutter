import 'package:equatable/equatable.dart';

import 'package:task_me_flutter/domain/models/schemes.dart';

class SideBarState extends Equatable {
  final List<Project> projects;

  const SideBarState({required this.projects});

  @override
  List<Object?> get props => [projects];
}
