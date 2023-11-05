import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_me_flutter/bloc/events/login_event.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/repositories/api/api.dart';

enum AuthPageState { login, registration }

class AuthVM extends ChangeNotifier {
  final MainBloc mainBloc;
  AuthVM({required this.mainBloc});

  AuthPageState _pageState = AuthPageState.login;
  AuthPageState get pageState => _pageState;

  String? _authErrorMessage;
  String? get authErrorMessage => _authErrorMessage;

  void setNewState(AuthPageState newPageState) {
    if (_pageState != newPageState) {
      _pageState = newPageState;
      notifyListeners();
    }
  }

  Future<void> confirm(String email, String password, {String? name}) async {
    try {
      final data = name != null
          ? await mainBloc.state.repo.signUp(email, password, name)
          : await mainBloc.state.repo.signIn(email, password);

      if (data.message != null) {
        _authErrorMessage = data.message.toString();
        notifyListeners();

        Timer(const Duration(seconds: 3), () {
          _authErrorMessage = null;
          notifyListeners();
        });
      }
      if (data.data != null) {
        mainBloc.add(LoginEvent(token: data.data!));
      }
    } catch (e) {
      _authErrorMessage = e.toString();
      notifyListeners();

      Timer(const Duration(seconds: 3), () {
        _authErrorMessage = null;
        notifyListeners();
      });
    }
  }
}
