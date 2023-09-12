import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
    Future<SelectedImagesDetails?> file;
    return currentUser.when(
      data: (data) {
        if (data == null) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: TextField()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Future<SelectedImagesDetails?> files =
                              ImagePickerPlus(
                            context,
                          ).pickBoth(
                                  source: ImageSource.both,
                                  multiSelection: true,
                                  galleryDisplaySettings:
                                      GalleryDisplaySettings(
                                    cropImage: true,
                                    showImagePreview: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                    ),
                                  ));
                          setState(() {
                            file = files;
                          });
                        },
                        splashColor: Colors.white,
                        child: Icon(Icons.add_a_photo, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                TextButton(onPressed: () {}, child: Text("Post"))
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
