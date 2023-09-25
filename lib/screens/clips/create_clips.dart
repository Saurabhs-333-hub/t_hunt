import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grock/grock.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/controllers/post_controller.dart';
import 'package:t_hunt/core/export.dart';
import 'package:t_hunt/screens/clips/ads_page.dart';
import 'package:t_hunt/screens/home/home.dart';

class CreateClips extends ConsumerStatefulWidget {
  const CreateClips({super.key});

  @override
  ConsumerState<CreateClips> createState() => _CreateClipsState();
}

class _CreateClipsState extends ConsumerState<CreateClips> {
  List<File> file = [];
  final captionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captionController.dispose();
  }

  void sharePost() {
    ref.read(postControllerProvider.notifier).sharePost(
        images: file, caption: captionController.text.trim(), context: context);
  }

  void onPickFiles() async {
    file = await pickFiles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController editableTextController = TextEditingController();
    final currentUser = ref.watch(currentUserDetailsProvider);
    bool isLoading = ref.watch(postControllerProvider);
    return currentUser.when(
      data: (data) {
        if (isLoading || data == null) {
          return Scaffold(
            body: Center(child: Grock.loadingPopup()),
          );
        }
        return Scaffold(
          // backgroundColor: Colors.black,
          body: Center(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: captionController,
                      autocorrect: true,
                      enableSuggestions: true,
                      enableIMEPersonalizedLearning: true,
                      maxLines: 6,
                      restorationId: captionController.text,
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // Future<SelectedImagesDetails?> files =
                          //     ImagePickerPlus(
                          //   context,
                          // ).pickBoth(
                          //         source: ImageSource.both,
                          //         multiSelection: true,
                          //         galleryDisplaySettings:
                          //             GalleryDisplaySettings(
                          //           cropImage: true,
                          //           showImagePreview: true,
                          //           gridDelegate:
                          //               SliverGridDelegateWithFixedCrossAxisCount(
                          //             crossAxisCount: 3,
                          //             crossAxisSpacing: 5,
                          //             mainAxisSpacing: 5,
                          //           ),
                          //         ));
                          onPickFiles();
                        },
                        splashColor: Colors.white,
                        child: Icon(Icons.add_a_photo, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                if (file.isNotEmpty) ...{
                  Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: file.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () => showModalBottomSheet(
                                            showDragHandle: true,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) =>
                                                InteractiveViewer(
                                              onInteractionUpdate: (details) {
                                                print(details.rotation);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: FileImage(
                                                            file[index]))),
                                              ),
                                            ),
                                          ),
                                      child: Image.file(file[index])),
                                );
                              },
                            ),
                          ),
                          file.isNotEmpty
                              ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      file = [];
                                    });
                                  },
                                  child: file.length > 1
                                      ? Text("Clear all ${file.length} images")
                                      : Text("Clear image"))
                              : Container(),
                        ],
                      ),
                    ),
                  ))
                },
                TextButton(
                    onPressed: () {
                      sharePost();
                    },
                    child: Text("Post")),
                // IconButton.outlined(
                //     onPressed: () {
                //       Navigator.of(context).push(
                //           MaterialPageRoute(builder: (context) => AdsPage()));
                //     },
                //     icon: Icon(Icons.ads_click_rounded))
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
