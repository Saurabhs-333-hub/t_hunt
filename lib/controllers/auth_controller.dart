import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_hunt/apis/auth_api.dart';

import '../core/export.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  // final authAPI = ref.watch(authAPIProvider);
  return AuthController(authAPI: ref.watch(authAPIProvider));
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({
    required AuthAPI authAPI,
  })  : _authAPI = authAPI,
        super(false);

  // void signIn() {}

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    try {
      final res = await _authAPI.signUp(email: email, password: password);
      print('objects');
      // state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) => print(r.email));
    } catch (e) {
      print(e);
    }
  }

  // void signOut() {}
}
