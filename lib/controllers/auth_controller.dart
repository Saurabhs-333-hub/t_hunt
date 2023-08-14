import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_hunt/apis/auth_api.dart';

import '../core/export.dart';

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({
    required AuthAPI authAPI,
  })  : _authAPI = authAPI,
        super(false);

  void signIn() {}

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, r.email));
  }

  void signOut() {}
}
