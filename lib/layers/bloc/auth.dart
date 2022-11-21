import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/repositories/api/auth.dart';

enum AuthPageState { login, registration, preview }

class AuthState {
  final AuthPageState pageState;
  const AuthState(this.pageState);

  // AuthState copyWith({User? user, ThemeData? theme, bool nullUser = false, Color? color}) {
  //   return AuthState(
  //   );
  // }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState(AuthPageState.preview));
  final AuthApiRepository authApiRepository = AuthApiRepository();

  void setNewState(AuthPageState pageState) {
    emit(AuthState(pageState));
  }

  void confirm(String email, String password, String? name) {
    if (state.pageState == AuthPageState.registration) {
      if (name != null) {
        authApiRepository.registration(email, password, name);
      }
    } else if (state.pageState == AuthPageState.login) {
      authApiRepository.login(email, password);
    }
    return;
  }
}
