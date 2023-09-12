import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_hunt/controllers/auth_controller.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: currentUser.when(
            data: (data) {
              return Text("${data}", style: TextStyle(color: Colors.white));
            },
            error: (e, st) {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.toString()),
                  ),
                ),
              );
            },
            loading: () =>
                Scaffold(body: Center(child: CircularProgressIndicator()))),
      ),
    );
  }
}
