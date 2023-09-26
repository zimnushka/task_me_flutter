import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_me_flutter/domain/service/router.dart';
import 'package:task_me_flutter/repositories/api/auth.dart';
import 'package:task_me_flutter/ui/widgets/overlays/config_editor.dart';

enum AuthPageState { login, registration, none }

class AuthVM extends ChangeNotifier {
  final AuthApiRepository _authApiRepository = AuthApiRepository();

  AuthPageState _pageState = AuthPageState.none;
  AuthPageState get pageState => _pageState;

  String? _authErrorMessage;
  String? get authErrorMessage => _authErrorMessage;

  AuthVM();

  void setNewState(AuthPageState newPageState) {
    if (_pageState != newPageState) {
      _pageState = newPageState;
      notifyListeners();
    }
  }

  Future<String?> confirm(String email, String password, {String? name}) async {
    try {
      if (name != null) {
        final data = await _authApiRepository.registration(email, password, name);
        if (data.message != null) {
          _authErrorMessage = data.message.toString();
          notifyListeners();

          Timer(const Duration(seconds: 3), () {
            _authErrorMessage = null;
            notifyListeners();
          });
        }
        return data.data;
      } else {
        final data = await _authApiRepository.login(email, password);
        if (data.message != null) {
          _authErrorMessage = data.message.toString();
          notifyListeners();

          Timer(const Duration(seconds: 3), () {
            _authErrorMessage = null;
            notifyListeners();
          });
        }
        return data.data;
      }
    } catch (e) {
      _authErrorMessage = e.toString();
      notifyListeners();

      Timer(const Duration(seconds: 3), () {
        _authErrorMessage = null;
        notifyListeners();
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
