import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/core/export.dart';

class CreateClips extends ConsumerWidget {
  const CreateClips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider);
    print(currentUser);
    return currentUser.when(
      data: (data) {
        if (data == null) {
          return Scaffold(
            body: Center(child: Text("No Data")),
          );
        }
        return Scaffold(
          body: Center(child: Text(data.toString())),
        );
      },
      error: (e, st) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(e.toString()),
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
    );
  }
}
