import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:t_hunt/apis/auth_api.dart';
import 'package:t_hunt/apis/user_api.dart';
import 'package:t_hunt/models/usermodel.dart';
import 'package:t_hunt/screens/clips/median_screen.dart';
import 'package:t_hunt/screens/home/home.dart';

import '../core/export.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  // final authAPI = ref.watch(authAPIProvider);
  return AuthController(
      authAPI: ref.watch(authAPIProvider), userAPI: ref.watch(userAPIProvider));
});

final currentUserDetailsProvider = FutureProvider((ref) async {
  return ref.watch(currentUserProvider).when(
        data: (data) {
          final currrentUserId = data!.$id;
          print(currrentUserId);
          final userDetails = ref.watch(userDetailsProvider(currrentUserId));
          print("User Details $userDetails");
          return userDetails.value;
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => CircularProgressIndicator(),
      );
});
final userDetailsProvider = FutureProvider.family((ref, String uid) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getuserData(uid);
});
final currentUserProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();
  void signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    state = true;
    _authAPI.signIn(email: email, password: password).then((res) {
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => Home(),
        ));
      });
    });
  }

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    try {
      final res = await _authAPI.signUp(email: email, password: password);
      print('objects');

      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) async {
        Usermodel usermodel =
            Usermodel(email: email, id: r.$id, name: "", password: password);
        final res2 = await _userAPI.saveUserData(usermodel);
        res2.fold((l) => showSnackBar(context, l.message),
            (r) => showSnackBar(context, "Account Created!"));
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Usermodel> getuserData(String uid) async {
    final document = await _userAPI.getuserData(uid);
    final updatedUser = Usermodel.fromMap(document.data);
    return updatedUser;
  }

  // void signOut() {}
}
