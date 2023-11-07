import 'package:equatable/equatable.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';

class AuthState extends Equatable {
  final AuthStep _step;

  const AuthState(this._step);
  factory AuthState.empty() => const AuthState(AuthStepUnauthenticated());

  User? get user {
    if (_step is AuthStepAuthenticated) {
      return (_step as AuthStepAuthenticated).user;
    }
    return null;
  }

  String? get token {
    if (_step is AuthStepAuthenticated) {
      return (_step as AuthStepAuthenticated).token;
    }
    return null;
  }

  @override
  List<Object?> get props => [_step];
}

sealed class AuthStep extends Equatable {
  const AuthStep();
}

class AuthStepAuthenticated extends AuthStep {
  final String token;
  final User user;

  const AuthStepAuthenticated({
    required this.token,
    required this.user,
  });

  @override
  List<Object?> get props => [token, user];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'token': token, 'user': user.toJson()};
  }

  factory AuthStepAuthenticated.fromJson(Map<String, dynamic> map) {
    return AuthStepAuthenticated(
      token: map['token'] as String,
      user: User.fromJson(map['user']),
    );
  }
}

class AuthStepUnauthenticated extends AuthStep {
  const AuthStepUnauthenticated();

  @override
  List<Object?> get props => [];
}
