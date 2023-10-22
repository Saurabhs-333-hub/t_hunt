import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_hunt/controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void onSignup() {
    ref.read(authControllerProvider.notifier).signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        context: context,
        name: _usernameController.text.trim());
    print('object');
  }

  void onSignIn() {
    ref.read(authControllerProvider.notifier).signIn(
        email: _emailController.text,
        password: _passwordController.text,
        context: context);
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final maxWidth = 400.0;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final containerWidth = constraints.maxWidth < maxWidth
                  ? constraints.maxWidth
                  : maxWidth;
              return Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: screenHeight * 0.3,
                      width: containerWidth,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Text("Login Page")),
                  Container(
                      height: screenHeight * 0.7,
                      width: containerWidth,
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                            ),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                          ),
                          isLoading
                              ? Text("Logging In")
                              : TextButton(
                                  onPressed: onSignIn, child: Text("Login")),
                          isLoading
                              ? Text("Signing Up")
                              : TextButton(
                                  onPressed: onSignup, child: Text("Sign Up"))
                        ],
                      )),
                ],
              ));
            },
          ),
        ),
      ),
    );
  }
}
