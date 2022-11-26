import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/repositories/api/auth.dart';

enum AuthPageState { login, registration }

class AuthState extends AppState {
  final AuthPageState pageState;
  final String? authErrorMessage;

  const AuthState(
    this.pageState, {
    this.authErrorMessage,
  });
}

class AuthCubit extends Cubit<AppState> {
  AuthCubit() : super(const AuthState(AuthPageState.login));
  final AuthApiRepository _authApiRepository = AuthApiRepository();

  void setNewState(AuthPageState pageState) {
    emit(AuthState(pageState));
  }

  Future<String?> confirm(String email, String password, {String? name}) async {
    try {
      if (name != null) {
        return _errorIncriptor(await _authApiRepository.registration(email, password, name));
      } else {
        return _errorIncriptor(await _authApiRepository.login(email, password));
      }
    } catch (e) {
      final AuthPageState pageState = (state as AuthState).pageState;
      emit(AuthState(pageState, authErrorMessage: e.toString()));
      Timer(const Duration(seconds: 3), () {
        emit(AuthState(pageState, authErrorMessage: null));
      });
    }
    return null;
  }

  _errorIncriptor(ApiResponse data) {
    if (data.isSuccess) {
      return data.data;
    }
    throw Exception(data.message);
  }
}
