// import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:restart_app/restart_app.dart';
import 'package:t_hunt/apis/auth_api.dart';
import 'package:t_hunt/apis/user_api.dart';
import 'package:t_hunt/core/auth.dart';
import 'package:t_hunt/models/usermodel.dart';
import 'package:t_hunt/screens/authentication/login.dart';
import 'package:t_hunt/screens/clips/create_clips.dart';
import 'package:t_hunt/screens/home/home.dart';
// import 'package:t_hunt/screens/home/home.dart';

import '../core/export.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  // final authAPI = ref.watch(authAPIProvider);
  return AuthController(
      authAPI: ref.watch(authAPIProvider), userAPI: ref.watch(userAPIProvider));
});

final currentUserDetailsProvider = FutureProvider((ref) async {
  final currrentUserId = ref.watch(currentUserProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currrentUserId));
  print("User Details $userDetails");
  return userDetails.value;
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
      // Auth.authenticated = true;
      res.fold((l) {
        print(l.message);
        errorSnackBar(context, "Error! 😢", l.message);
      }, (r) {
        // Restart.restartApp();
        print(r);
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
      res.fold((l) => errorSnackBar(context, "Error! 😢", l.message),
          (r) async {
        Usermodel usermodel =
            Usermodel(email: email, id: r.$id, name: "", password: password);
        final res2 = await _userAPI.saveUserData(usermodel);
        res2.fold((l) {
          print(l.message);
          errorSnackBar(context, "Error! 😢", l.message);
        }, (r) => successSnackBar(context, "Account Created!", "Congrats! 🥳"));
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

  void signOut(BuildContext context) async {
    await _authAPI.signOut(context);
    // Navigator.of(context).pushReplacement(CupertinoPageRoute(
    //   builder: (context) => LoginPage(),
    // ));
  }
}
