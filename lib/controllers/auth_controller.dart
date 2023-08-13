import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_hunt/apis/auth_api.dart';

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({
    required AuthAPI authAPI,
  })  : _authAPI = authAPI,
        super(false);

  void signIn() {}

  void signUp() {
    
  }

  void signOut() {}
}
