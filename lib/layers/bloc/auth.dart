import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/repositories/api/auth.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/config_editor.dart';

enum AuthPageState { login, registration, none }

class AuthState {
  final AuthPageState pageState;
  final String? authErrorMessage;

  const AuthState(
    this.pageState, {
    this.authErrorMessage,
  });
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState(AuthPageState.none));
  final AuthApiRepository _authApiRepository = AuthApiRepository();

  void setNewState(AuthPageState pageState) {
    emit(AuthState(pageState));
  }

  Future<String?> confirm(String email, String password, {String? name}) async {
    try {
      if (name != null) {
        final data = await _authApiRepository.registration(email, password, name);
        if (data.message != null) {
          final AuthPageState pageState = (state).pageState;
          emit(AuthState(pageState, authErrorMessage: data.message.toString()));
          Timer(const Duration(seconds: 3), () {
            emit(AuthState(pageState, authErrorMessage: null));
          });
        }
        return data.data;
      } else {
        final data = await _authApiRepository.login(email, password);
        if (data.message != null) {
          final AuthPageState pageState = state.pageState;
          emit(AuthState(pageState, authErrorMessage: data.message.toString()));
          Timer(const Duration(seconds: 3), () {
            emit(AuthState(pageState, authErrorMessage: null));
          });
        }
        return data.data;
      }
    } catch (e) {
      final AuthPageState pageState = state.pageState;
      emit(AuthState(pageState, authErrorMessage: e.toString()));
      Timer(const Duration(seconds: 3), () {
        emit(AuthState(pageState, authErrorMessage: null));
      });
    }
    return null;
  }

  Future<void> setConfig() async {
    await showDialog(
      context: AppRouter.context,
      builder: (context) => const ConfigEditorDialog(),
    );
  }
}
