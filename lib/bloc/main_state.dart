// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/domain/states/auth_state.dart';
import 'package:task_me_flutter/domain/states/overlay_state.dart';
import 'package:task_me_flutter/domain/states/sidebar_state.dart';
import 'package:task_me_flutter/repositories/api/api.dart';

class MainState extends Equatable {
  final AuthState authState;
  final OverlayMessageState overlayState;
  final ApiRepository repo;
  final Config config;
  final SideBarState sideBarState;
  final TimeInterval? currentTimeInterval;

  const MainState({
    required this.authState,
    required this.overlayState,
    required this.repo,
    required this.config,
    required this.sideBarState,
    this.currentTimeInterval,
  });

  @override
  List<Object?> get props => [
        authState,
        overlayState,
        repo,
        config,
        sideBarState,
        currentTimeInterval,
      ];

  MainState get withOutTimeInterval => MainState(
        authState: authState,
        overlayState: overlayState,
        repo: repo,
        config: config,
        sideBarState: sideBarState,
        currentTimeInterval: null,
      );

  MainState copyWith({
    AuthState? authState,
    OverlayMessageState? overlayState,
    ApiRepository? repo,
    Config? config,
    SideBarState? sideBarState,
    TimeInterval? currentTimeInterval,
  }) {
    return MainState(
      authState: authState ?? this.authState,
      overlayState: overlayState ?? this.overlayState,
      repo: repo ?? this.repo,
      config: config ?? this.config,
      sideBarState: sideBarState ?? this.sideBarState,
      currentTimeInterval: currentTimeInterval ?? this.currentTimeInterval,
    );
  }
}
