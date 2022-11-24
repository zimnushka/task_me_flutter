import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/models/error.dart';
import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/repositories/api/auth.dart';

enum AuthPageState { login, registration, preview }

class AuthState extends AppState {
  final AuthPageState pageState;
  const AuthState(this.pageState);

  // AuthState copyWith({User? user, ThemeData? theme, bool nullUser = false, Color? color}) {
  //   return AuthState(
  //   );
  // }
}

class AuthCubit extends Cubit<AppState> {
  AuthCubit() : super(const AuthState(AuthPageState.preview));
  final AuthApiRepository _authApiRepository = AuthApiRepository();

  void setNewState(AuthPageState pageState) {
    emit(AuthState(pageState));
  }

  Future<String> confirm(String email, String password, String? name) async {
    final currentState = state as AuthState;
    try {
      if (currentState.pageState == AuthPageState.registration) {
        if (name != null) {
          return _errorIncriptor(await _authApiRepository.registration(email, password, name));
        }
      } else if (currentState.pageState == AuthPageState.login) {
        return _errorIncriptor(await _authApiRepository.login(email, password));
      }
    } catch (e, stackTrace) {
      emit(AppErrorState(AppError(e.toString(), stackTrace)));
    }
    return '';
  }

  _errorIncriptor(ApiResponse data) {
    if (data.isSuccess) {
      return data.data;
    }
    throw Exception(data.message);
  }
}
