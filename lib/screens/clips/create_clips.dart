import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/core/export.dart';
import 'package:t_hunt/screens/home/home.dart';

class CreateClips extends ConsumerStatefulWidget {
  const CreateClips({super.key});

  @override
  ConsumerState<CreateClips> createState() => _CreateClipsState();
}

class _CreateClipsState extends ConsumerState<CreateClips> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider);
    return currentUser.when(
      data: (data) {
        if (data == null) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          body: Center(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Container(color: Colors.black, width: 200, height: 600),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Container(color: Colors.black, width: 200, height: 600),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Container(color: Colors.black, width: 200, height: 600),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Container(color: Colors.black, width: 200, height: 600),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Container(color: Colors.black, width: 200, height: 600),
                )
              ],
            ),
          )),
        );
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
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
