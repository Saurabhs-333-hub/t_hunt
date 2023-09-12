import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t_hunt/core/auth.dart';
import 'package:t_hunt/screens/authentication/login.dart';
import 'package:t_hunt/screens/home/home.dart';

class AppRouter {
  GoRouter router = GoRouter(
      routes: [
        GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              return MaterialPage(child: Home());
            }),
        GoRoute(
            path: '/login',
            pageBuilder: (context, state) {
              return MaterialPage(child: LoginPage());
            }),
      ],
      redirect: (context, state) {
        bool auth = Auth.authenticated;
        if (!auth && state.subloc == '/') return '/login';
        return null;
      });
}
